//
//  ColumnChartDataSource.m
//  HandlingSelection
//
//  Created by Colin Eberhardt on 16/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "ColumnChartDataSource.h"

@implementation ColumnChartDataSource
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


#pragma mark - SChartDatasource methods

- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return _sales.count;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index {
    SChartColumnSeries *columnSeries = [[SChartColumnSeries alloc] init];
    NSString* year = _sales.allKeys[index];
    columnSeries.title = year;
    columnSeries.selectionMode = SChartSelectionSeries;
    columnSeries.style.showAreaWithGradient = NO;
    columnSeries.selectedStyle.showAreaWithGradient = NO;
    columnSeries.selectedStyle.areaColor = [UIColor redColor];
    columnSeries.selectedStyle.lineWidth = @0.0;
    
    // set the selected state of the line series - this reflects the initial UI state
    columnSeries.selected = [year isEqualToString:self.displayYear];
    return columnSeries;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    NSString* year = _sales.allKeys[seriesIndex];
    NSDictionary* salesForYear = _sales[year];
    return salesForYear.count;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {
    SChartDataPoint *datapoint = [[SChartDataPoint alloc] init];
    
    NSString* year = _sales.allKeys[seriesIndex];
    NSDictionary* salesForYear = _sales[year];
    
    NSString* key = salesForYear.allKeys[dataIndex];
    datapoint.xValue = key;
    datapoint.yValue = salesForYear[key];
    return datapoint;
}


@end
