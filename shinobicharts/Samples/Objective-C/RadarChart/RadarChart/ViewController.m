//
//  ViewController.m
//  RadarChart
//
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import "ViewController.h"

#import <ShinobiCharts/ShinobiCharts.h>

@interface ViewController () <SChartDatasource>

@end

@implementation ViewController{
    ShinobiChart *_chart;
    NSDictionary *_playerRatings;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create the player data.
    _playerRatings = @{@"Speed" : @92, @"Power" : @68, @"Agility" : @74, @"Vision" : @80, @"Style": @65};
    
    // Create the chart.
    _chart = [[ShinobiChart alloc] initWithFrame:self.view.bounds];
    
    // This view controller acts as the datasource.
    _chart.datasource = self;
    
    // Create the axes
    _chart.xAxis = [SChartCategoryAxis new];
    _chart.yAxis = [[SChartNumberAxis alloc] initWithRange:[[SChartNumberRange alloc] initWithMinimum:@0 andMaximum:@100]];

    //Make X-Axis line draw as a spiderweb.
    _chart.xAxis.style.majorGridLineStyle.lineRenderMode = SChartRadialLineRenderModeLinear;
    _chart.xAxis.style.majorGridLineStyle.showMajorGridLines = YES;
    _chart.xAxis.style.majorGridLineStyle.lineColor = [UIColor lightGrayColor];

    //Make Y-Axis gridlines draw as a spiderweb.
    _chart.yAxis.style.majorGridLineStyle.lineRenderMode = SChartRadialLineRenderModeLinear;
    _chart.yAxis.style.majorGridLineStyle.showMajorGridLines = YES;
    _chart.yAxis.style.majorGridLineStyle.lineColor = [UIColor lightGrayColor];
    
    // Ensure the chart fills the screen.
    _chart.autoresizingMask =  ~UIViewAutoresizingNone;
    
    // TODO: Add your trial licence key here!
    _chart.licenseKey = @"";
    
    // Add the chart to the view.
    [self.view addSubview:_chart];
}

#pragma mark - SChartDatasource methods

-(NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart
{
    return 1;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index
{
    SChartRadialLineSeries *radialLineSeries = [SChartRadialLineSeries new];
    
    // Fill the series.
    radialLineSeries.style.showFill = YES;
    
    //Join up the first and last points
    radialLineSeries.pointsWrapAround = YES;
    
    return radialLineSeries;
}

-(NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex
{
    return [_playerRatings.allKeys count];
}

-(id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex
{
    // Set the data on the datapoint.
    SChartDataPoint *dp = [SChartDataPoint new];
    dp.xValue = _playerRatings.allKeys[dataIndex];
    dp.yValue = [_playerRatings objectForKey: dp.xValue];
    
    return dp;
}

@end
