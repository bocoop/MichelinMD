//
//  PieChartDataSource.m
//  HandlingSelection
//
//  Created by Colin Eberhardt on 16/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "PieChartDataSource.h"

@implementation PieChartDataSource
{
    NSDictionary* _sales;
}

- (id)initWithSales:(NSDictionary *)sales displayYear:(NSString *)year {
    if(self = [super init]) {
        _sales = sales;
        _displayYear = year;
    }
    return self;
}

- (NSDictionary*)dataForYear {
    NSDictionary* salesForYear = _sales[self.displayYear];
    return salesForYear;
}

#pragma mark - SChartDatasource methods

- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return 1;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index {
    SChartPieSeries *pieSeries = [[SChartPieSeries alloc] init];
    return pieSeries;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
   return [self dataForYear].count;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {
    SChartDataPoint *datapoint = [[SChartDataPoint alloc] init];
    
    NSDictionary* salesForYear = [self dataForYear];
    
    NSString* key = salesForYear.allKeys[dataIndex];
    datapoint.xValue = key;
    datapoint.yValue = salesForYear[key];
    return datapoint;
}

@end
