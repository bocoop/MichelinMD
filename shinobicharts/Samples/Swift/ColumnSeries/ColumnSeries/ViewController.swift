//
//  ViewController.swift
//  ShinobiControls
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SChartDatasource {
    
    // Grocery sales data array of dictionaries containing key value pairs matching grocery items to sales (in 1000s)
    let salesData: [[String : Double]] = [
        ["Broccoli" : 5.65, "Carrots" : 12.6, "Mushrooms" : 8.4], // 2013 sales
        ["Broccoli" : 4.35, "Carrots" : 13.2, "Mushrooms" : 4.6, "Okra" : 0.6] // 2014 sales
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add a margin between the view and chart
        let margin: CGFloat = UIDevice.currentDevice().userInterfaceIdiom == .Phone ? 20 : 50
        
        // Create the chart
        let chart = ShinobiChart(frame: CGRectInset(view.bounds, margin, margin))
        chart.title = "Grocery Sales Figures"
        
        chart.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        
        chart.licenseKey = "" // TODO: Add your trial license key here
        
        // Create and add axes to chart
        let xAxis = SChartCategoryAxis()
        
        // Don't add any padding between series columns with same x value
        xAxis.style.interSeriesPadding = 0
        chart.xAxis = xAxis
        
        let yAxis = SChartNumberAxis()
        yAxis.title = "Sales (1000s)"
        yAxis.rangePaddingHigh = 1
        chart.yAxis = yAxis
        
        // Add chart to the view
        view.addSubview(chart)
        
        // This view controller will provide data to the chart
        chart.datasource = self
        
        // Show the legend on all devices
        chart.legend.hidden = false
        chart.legend.placement = SChartLegendPlacementInsidePlotArea
    }
    
    // MARK:- SChartDatasource Functions
    
    // Two series of data (2013 and 2014 sales data)
    func numberOfSeriesInSChart(chart: ShinobiChart!) -> Int {
        return 2
    }
    
    // Create column series objects for both sets of data and assign relevant title
    func sChart(chart: ShinobiChart!, seriesAtIndex index: Int) -> SChartSeries! {
        let columnSeries = SChartColumnSeries()
        columnSeries.title = (index == 0 ? "2013" : "2014")
        return columnSeries
    }
    
    // Number of datapoints in series is equivalent to number of grocery items for year at seriesIndex
    func sChart(chart: ShinobiChart!, numberOfDataPointsForSeriesAtIndex seriesIndex: Int) -> Int {
        return salesData[seriesIndex].count
    }
    
    // Create data point objects
    func sChart(chart: ShinobiChart!, dataPointAtIndex dataIndex: Int, forSeriesAtIndex seriesIndex: Int) -> SChartData! {
        let dataPoint = SChartDataPoint()
        
        // Get array of keys (grocery names) for the series
        let allGroceriesInYear = [String](salesData[seriesIndex].keys)
        
        let groceryForDataPoint = allGroceriesInYear[dataIndex]
        
        // Set data point x and y values to grocery title and sales data
        dataPoint.xValue = groceryForDataPoint
        dataPoint.yValue = salesData[seriesIndex][groceryForDataPoint]
        
        return dataPoint
    }

}

