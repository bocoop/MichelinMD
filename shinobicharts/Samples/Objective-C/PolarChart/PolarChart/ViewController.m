//
//  ViewController.m
//  PolarChart
//
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import "ViewController.h"

#import <ShinobiCharts/ShinobiCharts.h>

@interface ViewController () <SChartDatasource>

@end

@implementation ViewController {
    ShinobiChart *_chart;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create the chart.
    _chart = [[ShinobiChart alloc] initWithFrame:self.view.bounds];
    
    // This view controller acts as the datasource.
    _chart.datasource = self;
    
    // Create the axes.
    _chart.xAxis = [SChartNumberAxis new];
    _chart.yAxis = [SChartNumberAxis new];
    
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
    return radialLineSeries;
}

-(NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex
{
    return 360;
}

-(id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex
{
    SChartDataPoint *dp = [SChartDataPoint new];
    
    dp.xValue = @(dataIndex);
    dp.yValue = @(dataIndex);
    
    return dp;
}

@end
