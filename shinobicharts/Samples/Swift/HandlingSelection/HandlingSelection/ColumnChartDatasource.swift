//
//  ColumnChartDatasource.swift
//  ShinobiControls
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

import Foundation

class ColumnChartDatasource: NSObject, SChartDatasource {
    
    let grocerySalesData: [String:[String:Double]]

    var displayYear: String
    
    init(salesData: [String:[String:Double]], year: String) {
        self.grocerySalesData = salesData
        displayYear = year
    }
    
    // MARK:- Custom Functions
    
    // Get the year string for a given series index
    func titleForSeriesAtIndex(index: Int) -> String! {
        let allYears = grocerySalesData.keys.array
        let columnSeriesYear = allYears[index]
        
        return columnSeriesYear
    }
    
    // Get key-value pairs of grocery sales data for the series at a given index
    func salesForSeriesIndex(index: Int) -> [String:Double]! {
        let columnSeriesYear = titleForSeriesAtIndex(index)
        return grocerySalesData[columnSeriesYear]
    }
    
    // MARK:- SChartDatasource functions
    
    func numberOfSeriesInSChart(chart: ShinobiChart!) -> Int {
        return grocerySalesData.count
    }
    
    // Create column series object
    func sChart(chart: ShinobiChart!, seriesAtIndex index: Int) -> SChartSeries! {
        
        let year = titleForSeriesAtIndex(index)
        
        let columnSeries = SChartColumnSeries()
        
        // Title is used to determine which set of data to display in pie series when a series is selected
        columnSeries.title = year
        
        // Want entire series to be selected if a column is tapped
        columnSeries.selectionMode = SChartSelectionSeries
        
        // Override some of the default styles for an unselected series
        columnSeries.style().showAreaWithGradient = false
        columnSeries.style().lineWidth = 0;
        
        // Set style of column series when selected
        columnSeries.selectedStyle().showAreaWithGradient = false
        columnSeries.selectedStyle().areaColor = UIColor.redColor()
        columnSeries.selectedStyle().lineWidth = 8
        columnSeries.selectedStyle().lineColor = UIColor.blackColor()
        
        // Initially set 2014 data to be selected
        if columnSeries.title == displayYear {
            columnSeries.selected = true
        }
        
        return columnSeries
    }
    
    func sChart(chart: ShinobiChart!, numberOfDataPointsForSeriesAtIndex seriesIndex: Int) -> Int {
        return salesForSeriesIndex(seriesIndex).count
    }
    
    // Create data points representing the columns
    func sChart(chart: ShinobiChart!, dataPointAtIndex dataIndex: Int, forSeriesAtIndex seriesIndex: Int) -> SChartData! {
        let dataPoint = SChartDataPoint()
        
        let salesForSeries = salesForSeriesIndex(seriesIndex)
        
        let groceryType = salesForSeries.keys.array[dataIndex]
        
        dataPoint.xValue = groceryType
        dataPoint.yValue = salesForSeries[groceryType]
        
        return dataPoint
        
    }
    
}