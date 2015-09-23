//
//  ViewController.swift
//  ShinobiControls
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SChartDatasource {
    
    // Dummy temperature data
    let minTemps: [String : [Double]] = [
        "San Francisco" : [8.1, 9.1, 9.2, 9.5, 11.0, 12.2, 12.5, 13.1, 13.0, 12.1, 10.3, 8.4],
        "Newcastle upon Tyne" : [2.2, 2.2, 3.3, 4.8, 7.2, 10.0, 12.3, 12.3, 10.4, 7.7, 4.9, 2.5]
    ]
    
    // Chart created using storyboard
    @IBOutlet weak var radarChart: ShinobiChart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        radarChart.licenseKey = "" // TODO: Add Trial license key here
        
        radarChart.title = "Average Minimum Temperatures by Month"
    
        radarChart.titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 16.0);
        
        // Create chart axes
        
        let xAxis = SChartCategoryAxis()
        xAxis.style.majorGridLineStyle.lineRenderMode = SChartRadialLineRenderMode.Linear
        xAxis.style.majorGridLineStyle.showMajorGridLines = true
        xAxis.style.majorGridLineStyle.lineColor = UIColor.lightGrayColor()
        
        radarChart.xAxis = xAxis
        
        // Add a range to the y axis
        let yAxis = SChartNumberAxis(range: SChartNumberRange(minimum: 0, andMaximum: 15))
        yAxis.style.majorGridLineStyle.lineRenderMode = SChartRadialLineRenderMode.Linear
        yAxis.style.majorGridLineStyle.showMajorGridLines = true
        yAxis.style.majorGridLineStyle.lineColor = UIColor.lightGrayColor()
        yAxis.title = "Temp (°C)"
        
        radarChart.yAxis = yAxis
        
        // Show legend and position along bottom
        radarChart.legend.hidden = false
        radarChart.legend.position = SChartLegendPositionBottomMiddle
        
        // This view controller will provide the chart with data
        radarChart.datasource = self
    }
    
    // Return a month as a string given a data point index (0 = January, 1 = February, e.t.c)
    func monthStringForIndex(index: Int) -> String {
        let formatter = NSDateFormatter()
        let months = formatter.monthSymbols as NSArray
        
        return months[index] as String
    }
    
    // MARK:- SChartDatasource Functions
    func numberOfSeriesInSChart(chart: ShinobiChart!) -> Int {
        return minTemps.count
    }
    
    // Create radar series object
    func sChart(chart: ShinobiChart!, seriesAtIndex index: Int) -> SChartSeries! {
        let radarSeries = SChartRadialLineSeries()
        
        // Set title of series to display in legend
        radarSeries.title = minTemps.keys.array[index]
        
        // Increase the line width
        radarSeries.style().lineWidth = 3
        
        // Join up first and last points
        radarSeries.pointsWrapAround = true
        
        return radarSeries
    }
    
    func sChart(chart: ShinobiChart!, numberOfDataPointsForSeriesAtIndex seriesIndex: Int) -> Int {
         // We have data points for each month of the year
        return 12
    }
    
    func sChart(chart: ShinobiChart!, dataPointAtIndex dataIndex: Int, forSeriesAtIndex seriesIndex: Int) -> SChartData! {
        
        // City that series is showing temperature data for
        let cityKey = minTemps.keys.array[seriesIndex]
        
        // Create data point
        let dataPoint = SChartDataPoint()
        
        // X value is month title
        let monthString = monthStringForIndex(dataIndex)
        dataPoint.xValue = monthString
        
        // Y axis is average minimum temperature for month
        let tempData = minTemps[cityKey]!
        dataPoint.yValue = tempData[dataIndex]
        
        return dataPoint
    }
    
}
