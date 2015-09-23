//
//  ViewController.swift
//  ShinobiControls
//
//  Copyright (c) Scott Logic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SChartDatasource {

    // Store index to append a new data point
    var currentDataIndex: Int = 0
    
    // MutableArray to store SChartDataPoint objects to be drawn on chart
    var streamedData: [SChartDataPoint] = []
    
    // Create the chart after the view has loaded
    var chart: ShinobiChart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a margin inset from view controller view based on device
        let margin = (UIDevice.currentDevice().userInterfaceIdiom == .Phone) ? CGFloat(20) : CGFloat(50)
        
        // Create the chart object
        chart = ShinobiChart(frame: CGRectInset(view.bounds, margin, margin))
        chart.title = "Streaming"
        chart.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        
        chart.licenseKey = "" // TODO: add your trial licence key here!
        
        // Add x and y axis
        chart.xAxis = SChartNumberAxis()
        chart.yAxis = SChartNumberAxis()
        
        // This view controller will provide the data points to the chart
        chart.datasource = self
        
        // Add chart to the controller's view
        view.addSubview(chart)
        
        // Create initial data points
        let numberOfDataPoints = 360
        
        for index in 0..<numberOfDataPoints {
            let dataPointAtIndex = dataPointWithIndex(index)
            streamedData.append(dataPointAtIndex)
        }
        
        // update current index value so new items are appended to right side of chart
        currentDataIndex = streamedData.count
        
        // create the timer to update line series
        NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "updateLineSeries", userInfo: nil, repeats: true)
        
    }
    
    // MARK: - Custom Functions
    
    // Add and remove SChartDataPoint objects
    func updateLineSeries() {
        
        // Remove leftmost data point from array
        streamedData.removeAtIndex(0)
        
        // Append new data point item
        let newDataPoint = dataPointWithIndex(currentDataIndex)
        streamedData.append(newDataPoint)
        
        // Increment the data index value for next time timer invokes this function
        currentDataIndex++
        
        // Notify chart we're removing an item and appending another
        chart.removeNumberOfDataPoints(1, fromStartOfSeriesAtIndex: 0)
        chart.appendNumberOfDataPoints(1, toEndOfSeriesAtIndex: 0)
        
        // Finally, redraw the chart
        chart.redrawChart()
    }
    
    // Create a SChartDataPoint object and set x and y attributes
    func dataPointWithIndex(index: Int) -> SChartDataPoint {
        let dataPoint = SChartDataPoint()
        dataPoint.xValue = index
        dataPoint.yValue = sinOfValue(index)
        return dataPoint
    }
    
    // Given the x value, return y such that y = sin(x)
    func sinOfValue(value: Int) -> Double {
        let valueInRadians = Double(value) * (M_PI / 180.0)
        return sin(valueInRadians)
    }
    
    // MARK: - SChartDatasource Functions
    
    // We have one set of data to draw (sin curve)
    func numberOfSeriesInSChart(chart: ShinobiChart!) -> Int {
        return 1
    }
    
    // Create line series chart
    func sChart(chart: ShinobiChart!, seriesAtIndex index: Int) -> SChartSeries! {
        let lineSeries = SChartLineSeries()
        lineSeries.style().lineWidth = 2
        
        return lineSeries
    }
    
    // Number of data points is equal to the number of data point objects in the streamedData array
    func sChart(chart: ShinobiChart!, numberOfDataPointsForSeriesAtIndex seriesIndex: Int) -> Int {
        return streamedData.count
    }
    
    // Retrieve data point from streamedData array
    func sChart(chart: ShinobiChart!, dataPointAtIndex dataIndex: Int, forSeriesAtIndex seriesIndex: Int) -> SChartData! {
        return streamedData[dataIndex]
    }

}

