//
//  ViewController.m
//  MultipleAxes
//
//  Created by Colin Eberhardt on 05/08/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "ViewController.h"
#import <ShinobiCharts/ShinobiCharts.h>

@interface ViewController () <SChartDatasource, SChartDelegate>

@end

@implementation ViewController
{
    ShinobiChart* _chart;
    NSMutableArray* _timeSeries;
    NSMutableArray* _volumeSeries;
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
    
    // add X & Y axes, with explicit ranges so that the chart is initially rendered 'zoomed in'
    SChartDateRange* dateRange = [[SChartDateRange alloc] initWithDateMinimum:[self dateFromString:@"01-01-2010"]
                                                               andDateMaximum:[self dateFromString:@"01-06-2010"]];
    SChartDateTimeAxis *xAxis = [[SChartDateTimeAxis alloc] initWithRange:dateRange];
    xAxis.title = @"Date";
    _chart.xAxis = xAxis;
    
    SChartNumberRange* numberRange = [[SChartNumberRange alloc] initWithMinimum:@150 andMaximum:@300];
    SChartNumberAxis* yAxis = [[SChartNumberAxis alloc] initWithRange:numberRange];
    yAxis.title = @"Price (USD)";
    _chart.yAxis = yAxis;
    
    // add a secondary y-axis for volume
    SChartNumberAxis* volumeAxis = [SChartNumberAxis new];
    // render on the right-hand side
    volumeAxis.axisPosition = SChartAxisPositionReverse;
    volumeAxis.labelFormatString = @"%.0fM";
    volumeAxis.title = @"Volume";
    // hide gridlines
    volumeAxis.style.majorGridLineStyle.showMajorGridLines = NO;
    // add an upper padding so that the volume chart occupies the bottom half of the plot area
    volumeAxis.rangePaddingHigh = @100;
    [_chart addYAxis:volumeAxis];
    
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
    _chart.delegate = self;
}

- (void)loadChartData {
    
    _timeSeries = [NSMutableArray new];
    _volumeSeries = [NSMutableArray new];
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"AppleStockPrices" ofType:@"json"];
    
    NSData* json = [NSData dataWithContentsOfFile:filePath];
    
    NSArray* data = [NSJSONSerialization JSONObjectWithData:json
                                                    options:NSJSONReadingAllowFragments
                                                      error:nil];
    for (NSDictionary* jsonPoint  in data) {
        SChartDataPoint* datapoint = [self dataPointForDate:jsonPoint[@"date"]
                                                   andValue:jsonPoint[@"close"]];
        [_timeSeries addObject:datapoint];
        
        // add volume datapoints, changing the data units to millions
        SChartDataPoint* volumeDataPoint = [self dataPointForDate:jsonPoint[@"date"]
                                                   andValue:@([jsonPoint[@"volume"] doubleValue] / 1000000.0)];
        [_volumeSeries addObject:volumeDataPoint];
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

- (SChartDataPoint*)dataPointForDate:(NSString*)date andValue:(NSNumber*)value {
    SChartDataPoint* dataPoint = [SChartDataPoint new];
    dataPoint.xValue = [self dateFromString:date];
    dataPoint.yValue = value;
    return dataPoint;
}

#pragma mark - SChartDelegate methods

- (void)sChart:(ShinobiChart *)chart alterTickMark:(SChartTickMark *)tickMark beforeAddingToAxis:(SChartAxis *)axis {
    //Hide any tickmarks over 100M on the right y-axis
    if (axis == [chart.allYAxes lastObject]) {
        if (tickMark.value > 100.f) {
            tickMark.tickLabel.text = @"";
            tickMark.tickMarkView.hidden = YES;
        }
    }
}

#pragma mark - SChartDatasource methods

- (SChartAxis *)sChart:(ShinobiChart *)chart yAxisForSeriesAtIndex:(NSInteger)index {
    return chart.allYAxes[index];
}

- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return 2;
}

-(SChartSeries*)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index {
    SChartLineSeries* lineSeries = [[SChartLineSeries alloc] init];
    SChartColumnSeries* columnSeries = [[SChartColumnSeries alloc] init];
    return index == 1 ? columnSeries : lineSeries;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    return _timeSeries.count;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {
    return seriesIndex == 1 ? _volumeSeries[dataIndex] : _timeSeries[dataIndex];
}
@end
