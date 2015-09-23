//
//  ViewController.m
//  CandlestickChart
//
//  Created by Colin Eberhardt on 09/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "ViewController.h"
#import <ShinobiCharts/ShinobiChart.h>

@interface ViewController () <SChartDatasource>

@end

@implementation ViewController
{
    ShinobiChart* _chart;
    NSMutableArray* _timeSeries;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create the chart
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat margin = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 20.0 : 50.0;
    _chart = [[ShinobiChart alloc] initWithFrame:CGRectMake(0, margin, self.view.bounds.size.width, self.view.bounds.size.height - margin)];
    _chart.title = @"Apple Stock Price";
    
    _chart.autoresizingMask =  ~UIViewAutoresizingNone;
    
    _chart.licenseKey = @""; // TODO: add your trial licence key here!
    
    // add a discontinuous date axis
    SChartDateTimeAxis *xAxis = [[SChartDateTimeAxis alloc] init];
    xAxis.title = @"Date";
    _chart.xAxis = xAxis;
    
    SChartNumberAxis *yAxis = [[SChartNumberAxis alloc] init];
    yAxis.title = @"Price (USD)";
    _chart.yAxis = yAxis;
    
    // create some data
    [self loadChartData];
    
    // enable gestures
    yAxis.enableGesturePanning = YES;
    yAxis.enableGestureZooming = YES;
    xAxis.enableGesturePanning = YES;
    xAxis.enableGestureZooming = YES;
    
    // add to the view
    [self.view addSubview:_chart];
    
    _chart.datasource = self;
}

- (void)loadChartData {
    _timeSeries = [NSMutableArray new];
    
    // load the JSON data into an array
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"AppleStockPrices" ofType:@"json"];
    NSData* json = [NSData dataWithContentsOfFile:filePath];
    NSArray* data = [NSJSONSerialization JSONObjectWithData:json
                                                    options:NSJSONReadingAllowFragments
                                                      error:nil];
    
    // iterate over the array, creating a datapoint for each value.
    for (NSDictionary* jsonPoint  in data) {
        SChartMultiYDataPoint* datapoint = [SChartMultiYDataPoint new];
        datapoint.xValue = [self dateFromString:jsonPoint[@"date"]];
        NSDictionary* yValues = @{SChartCandlestickKeyOpen: jsonPoint[@"open"],
                                  SChartCandlestickKeyHigh: jsonPoint[@"high"],
                                  SChartCandlestickKeyLow: jsonPoint[@"low"],
                                  SChartCandlestickKeyClose: jsonPoint[@"close"]};
        datapoint.yValues = [NSMutableDictionary dictionaryWithDictionary:yValues];
        [_timeSeries addObject:datapoint];
    }
    
}

#pragma mark - utility methods

- (NSDate*) dateFromString:(NSString*)date {
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    }
    return [dateFormatter dateFromString:date];
}


#pragma mark - SChartDatasource methods

- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return 1;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index {
    SChartCandlestickSeries* candleStickSeries = [[SChartCandlestickSeries alloc] init];
    return candleStickSeries;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    return _timeSeries.count;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {
    return _timeSeries[dataIndex];
}

@end
