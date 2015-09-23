//
//  PieChartDatasource.swift
//  ShinobiControls
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

import UIKit

class PieChartDatasource: NSObject, SChartDatasource {
   
    // Currently selected year
    var displayYear: String
    
    let grocerySalesData: [String:[String:Double]]
    
    init(salesData: [String:[String:Double]], year: String) {
        self.grocerySalesData = salesData
        displayYear = year
    }
    
    // MARK:- Custom Functions
    
    // Get key value pairs for currently selected year
    func salesForDisplayYear() -> [String:Double]! {
        return grocerySalesData[displayYear]
    }
    
    // MARK:- SChartDatasource Functions
    
    // One series of sales data (current selected year in column series)
    func numberOfSeriesInSChart(chart: ShinobiChart!) -> Int {
        return 1
    }
    
    // Create pie series object
    func sChart(chart: ShinobiChart!, seriesAtIndex index: Int) -> SChartSeries! {
        return SChartPieSeries()
    }
    
    func sChart(chart: ShinobiChart!, numberOfDataPointsForSeriesAtIndex seriesIndex: Int) -> Int {
        return salesForDisplayYear().count
    }
    
    // Create data points representing segments of pie series
    func sChart(chart: ShinobiChart!, dataPointAtIndex dataIndex: Int, forSeriesAtIndex seriesIndex: Int) -> SChartData! {
        
        let salesForYear = salesForDisplayYear()
        
        let groceryType = salesForYear.keys.array[dataIndex]
        
        let dataPoint = SChartDataPoint()
        dataPoint.xValue = groceryType
        dataPoint.yValue = salesForYear[groceryType]
        
        return dataPoint
    }
    
}
