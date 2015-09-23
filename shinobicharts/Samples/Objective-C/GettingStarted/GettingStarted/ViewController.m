//
//  ViewController.m
//  GettingStarted
//
//  Created by Colin Eberhardt on 04/07/2013.
//  Copyright (c) 2013 Scott Logic Ltd. All rights reserved.
//

#import "ViewController.h"
#import <ShinobiCharts/ShinobiCharts.h>

@interface ViewController () <SChartDatasource>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create the chart
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat margin = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 20.0 : 50.0;
    ShinobiChart *chart = [[ShinobiChart alloc] initWithFrame:CGRectMake(0, margin, self.view.bounds.size.width, self.view.bounds.size.height - margin)];
    chart.title = @"Trigonometric Functions";
    chart.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    chart.licenseKey = @""; // TODO: add your trial licence key here!
    
    // add a pair of axes
    SChartNumberAxis *xAxis = [SChartNumberAxis new];
    xAxis.title = @"X Value";
    chart.xAxis = xAxis;
    
    SChartNumberAxis *yAxis = [SChartNumberAxis new];
    yAxis.title = @"Y Value";
    yAxis.rangePaddingLow = @(0.1);
    yAxis.rangePaddingHigh = @(0.1);
    chart.yAxis = yAxis;
    
    // enable gestures
    yAxis.enableGesturePanning = YES;
    yAxis.enableGestureZooming = YES;
    xAxis.enableGesturePanning = YES;
    xAxis.enableGestureZooming = YES;
    
    // add to the view
    [self.view addSubview:chart];
    
    chart.datasource = self;
    
    chart.legend.hidden = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
}

#pragma mark - SChartDatasource methods

- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return 2;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index {
    SChartLineSeries *lineSeries = [SChartLineSeries new];
    lineSeries.style.showFill = YES;
    
    // the first series is a cosine curve, the second is a sine curve
    if (index == 0) {
        lineSeries.title = @"y = cos(x)";
    } else {
        lineSeries.title = @"y = sin(x)";
    }
    
    return lineSeries;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    return 100;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {
    SChartDataPoint *datapoint = [SChartDataPoint new];
    
    // both functions share the same x-values
    double xValue = dataIndex / 10.0;
    datapoint.xValue = [NSNumber numberWithDouble:xValue];
    
    // compute the y-value for each series
    if (seriesIndex == 0) {
        datapoint.yValue = @(cos(xValue));
    } else {
        datapoint.yValue = @(sin(xValue));
    }
    
    return datapoint;
}

@end
