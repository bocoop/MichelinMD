//
//  ViewController.swift
//  ShinobiControls
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SChartDatasource {
    
    /// Chart to display stock data in (created using a storyboard)
    @IBOutlet weak var chart: ShinobiChart!
    
    var stockPriceData: [SChartDataPoint] = []
    
    let dateFormatter = NSDateFormatter()
    
    required init(coder aDecoder: NSCoder) {
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chart.title = "Apple Stock Price"
        chart.licenseKey = "" // TODO: Insert license key here
        
        // X Axis
        let xAxis = SChartDiscontinuousDateTimeAxis()
        xAxis.title = "Date"
        enablePanningAndZoomingOnAxis(xAxis)
        
        /**
            Using 2nd January as an anchor, skip all dates on x axis that fall on weekends.
        
            Length of time to skip = 2 days (saturday and sunday)
            Repeat frequency = 1 week
        **/
        let anchorDate = dateFormatter.dateFromString("02-01-2010") // 01-01-2010 was a Saturday
        let weekends = SChartRepeatedTimePeriod(start: anchorDate, andLength: SChartDateFrequency.dateFrequencyWithDay(2) as SChartDateFrequency, andFrequency: SChartDateFrequency.dateFrequencyWithWeek(1) as SChartDateFrequency)
        xAxis.addExcludedRepeatedTimePeriod(weekends)
        
        chart.xAxis = xAxis
        
        // Y Axis
        let yAxis = SChartNumberAxis()
        yAxis.title = "Price (USD)"
        enablePanningAndZoomingOnAxis(yAxis)
        
        chart.yAxis = yAxis
        
        loadChartData()
        
        // This view controller will provide data to the chart
        chart.datasource = self
    }
    
    func enablePanningAndZoomingOnAxis(axis: SChartAxis) {
        axis.enableGesturePanning = true
        axis.enableGestureZooming = true
    }
    
    // MARK:- Custom Methods
    
    /**
    Loads file and parses JSON
    
    :param: fileName The JSON file to load
    
    :returns: Array of parsed key-value objects
    */
    func JSONDataFromFile(fileName: String) -> [[String : AnyObject]] {
        if let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: "json") {
            if let jsonData = NSData(contentsOfFile: filePath) {
                var error: NSError?
                return NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments, error: &error) as [[String : AnyObject]]
            }
            else {
                println("There was an issue loading the JSON file")
            }
        }
        else {
            println("Invalid filename supplied")
        }
        
        // We were unable to load JSON data
        return []
    }
    
    /// Load stock price and volume data from a JSON file
    func loadChartData() {
        
        // Create volume and stock price data points from JSON data
        for dataPoint in JSONDataFromFile("AppleStockPrices") {
            
            let date = dateFormatter.dateFromString(dataPoint["date"]! as String)
            
            let stockDataPoint = SChartDataPoint()
            stockDataPoint.xValue = date
            stockDataPoint.yValue = dataPoint["close"]
            stockPriceData.append(stockDataPoint)
        }
    }
    
    // MARK:- SChartDatasource Methods
    
    // One set of data (Apple Stock Prices)
    func numberOfSeriesInSChart(chart: ShinobiChart!) -> Int {
        return 1
    }
    
    // Create line series object
    func sChart(chart: ShinobiChart!, seriesAtIndex index: Int) -> SChartSeries! {
        return SChartLineSeries()
    }
    
    func sChart(chart: ShinobiChart!, numberOfDataPointsForSeriesAtIndex seriesIndex: Int) -> Int {
        return stockPriceData.count
    }
    
    func sChart(chart: ShinobiChart!, dataPointAtIndex dataIndex: Int, forSeriesAtIndex seriesIndex: Int) -> SChartData! {
        return stockPriceData[dataIndex]
    }

}
