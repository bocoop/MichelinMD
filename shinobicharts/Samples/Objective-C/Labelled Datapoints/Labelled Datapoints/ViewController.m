//
//  ViewController.m
//  Labelled Datapoints
//
//  Created by Thomas Kelly on 27/11/2013.
//  Copyright (c) 2013 Scott Logic. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation ViewController
{
    NSArray *data;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [ShinobiCharts setLicenseKey:@""]; // TODO: Set license key - Trial frameworks only
    
    data = @[@0.5, @6.3, @2.1, @4.5, @2.2, @1, @0, @-1];
    
    //Set up chart
    ShinobiChart *chart = [[ShinobiChart alloc] initWithFrame:self.view.bounds withPrimaryXAxisType:SChartAxisTypeNumber withPrimaryYAxisType:SChartAxisTypeNumber];
    chart.datasource = self;
    chart.delegate = self;
    chart.autoresizingMask = ~UIViewAutoresizingNone;
    [self.view addSubview:chart];
    
    chart.yAxis.rangePaddingLow = @0.5;
    chart.yAxis.rangePaddingHigh = @0.5;
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Delegate methods

-(void)sChart:(ShinobiChart *)chart alterDataPointLabel:(SChartDataPointLabel *)label forDataPoint:(SChartDataPoint *)datapoint inSeries:(SChartSeries *)series
{
    //Do some additional label styling
    label.backgroundColor = [UIColor colorWithWhite:.8 alpha:1];
    
    // Increase width of label, but keep in center of column
    CGPoint center = label.center;
    CGRect labelFrame = label.frame;
    labelFrame.size.width = 40.f;
    label.frame = labelFrame;
    label.center = center;
    
    label.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - Datasource methods

-(NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart
{
    return 1;
}

-(NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex
{
    return [data count];
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index
{
    SChartColumnSeries *series = [SChartColumnSeries new];
    
    //Display labels
    series.style.dataPointLabelStyle.showLabels = YES;
    
    //Position labels
    series.style.dataPointLabelStyle.offsetFromDataPoint = CGPointMake(0, -15);
    series.style.dataPointLabelStyle.offsetFlippedForNegativeValues = YES;
    
    //Style labels
    series.style.dataPointLabelStyle.textColor = [UIColor blackColor];
    series.style.dataPointLabelStyle.displayValues = SChartDataPointLabelDisplayValuesY;
    
    return series;
}

-(id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex
{
    SChartDataPoint *dp = [SChartDataPoint new];
    dp.xValue = @(dataIndex);
    dp.yValue = [data objectAtIndex:dataIndex];
    return dp;
}

@end
