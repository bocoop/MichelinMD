//
//  ViewController.swift
//  ShinobiControls
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SChartDatasource, SChartDelegate {

    var ukEconomyGrowthData: [SChartDataPoint] = []
    
    // Colors
    let positiveGreen = UIColor(red:0.17, green:0.35, blue:0.13, alpha:1)
    let negativeRed = UIColor(red:0.63, green:0, blue:0.01, alpha:1)
    
    @IBOutlet weak var chart: ShinobiChart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadGrowthDataFromFile()
        
        chart.licenseKey = "" // TODO: Add Trial license key here
        
        chart.title = "UK Growth Rates"
        
        // Create chart axes
        chart.xAxis = SChartCategoryAxis()
        chart.xAxis.title = "Year"
        
        let yAxis = SChartNumberAxis()
        yAxis.title = "Growth (%)"
        yAxis.rangePaddingLow = 1.5
        yAxis.rangePaddingHigh = 1.5
        
        chart.yAxis = yAxis
        
        // This controller will provide the data to the chart
        chart.datasource = self
        
        // To alter datapoint label styles we need to implement a delegate function
        chart.delegate = self
        
    }
    
    // Load and parse contents of JSON file into data array
    func loadGrowthDataFromFile() {
        let filePath = NSBundle.mainBundle().pathForResource("UK_GDP", ofType: "json")
        let jsonData = NSData(contentsOfFile: filePath!)
        
        // Parse JSON into hourly commit data
        var error: NSError?
        let parsedData = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.AllowFragments, error: &error) as [[String : AnyObject]]
        
        // Iterate through hourly commit data
        for yearData in parsedData {
           
            let dataPoint = SChartDataPoint()
            dataPoint.xValue = yearData["year"]
            dataPoint.yValue = yearData["growthRate"]
            
            ukEconomyGrowthData.append(dataPoint)
        }
    }
    
    // MARK:- SChartDatasource Functions
    func numberOfSeriesInSChart(chart: ShinobiChart!) -> Int {
        return 1
    }
    
    // Create column series object
    func sChart(chart: ShinobiChart!, seriesAtIndex index: Int) -> SChartSeries! {
        let series = SChartColumnSeries()
        
        // Configure column colors for positive and negative Y values
        series.style().showAreaWithGradient = false
        series.style().areaColor = positiveGreen // Green
        series.style().areaColorBelowBaseline = negativeRed // Red
        
        // Display labels for each column
        series.style().dataPointLabelStyle.showLabels = true
        
        // Position labels slightly above data point on y axis
        series.style().dataPointLabelStyle.offsetFromDataPoint = CGPoint(x: 0, y: -15)
        
        // Label should contain just the y value of each data point
        series.style().dataPointLabelStyle.displayValues = SChartDataPointLabelDisplayValues.Y
        
        series.style().dataPointLabelStyle.textColor = UIColor.blackColor()
    
        return series
    }
    
    func sChart(chart: ShinobiChart!, numberOfDataPointsForSeriesAtIndex seriesIndex: Int) -> Int {
        return ukEconomyGrowthData.count
    }
    
    func sChart(chart: ShinobiChart!, dataPointAtIndex dataIndex: Int, forSeriesAtIndex seriesIndex: Int) -> SChartData! {
        return ukEconomyGrowthData[dataIndex]
    }
    
    // MARK:- SChartDelegate Functions
    func sChart(chart: ShinobiChart!, alterDataPointLabel label: SChartDataPointLabel!, forDataPoint dataPoint: SChartDataPoint!, inSeries series: SChartSeries!) {
        
        // Want to alter background color based on positive, negative or neutral
        var labelBackgroundColor: UIColor
        
        let rate = dataPoint.yValue as Double
        
        if rate > 0 {
            labelBackgroundColor = positiveGreen // Green
        }
        else if rate == 0 {
            labelBackgroundColor = UIColor.grayColor()
        }
        else {
            labelBackgroundColor = negativeRed // Red
        }
        
        label.font = UIFont.boldSystemFontOfSize(18)
        label.textColor = labelBackgroundColor
        
        // Resize label to fit increased font size
        label.sizeToFit()
    }
    
}

