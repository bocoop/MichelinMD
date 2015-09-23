//
//  ViewController.swift
//  ShinobiControls
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SChartDatasource, SChartDelegate {

    @IBOutlet weak var chart: ShinobiChart!
    
    // Data point mutable arrays
    var stockPriceData: [SChartDataPoint] = []
    var volumeData: [SChartDataPoint] = []
    
    let dateFormatter: NSDateFormatter = NSDateFormatter()
    
    required init(coder aDecoder: NSCoder) {
        dateFormatter.dateFormat = "dd-MM-yyyy"
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chart.title = "Apple Inc. (AAPL)"
        chart.licenseKey = "" // TODO: Add Trial license key here
        
        /** Chart Axes Configuration 
            - Make use of ranges to initially show the chart 'zoomed-in'
        **/
        
        // X Axis
        
        // Configure date range to initially show
        let initialMinDate = dateFormatter.dateFromString("01-01-2010")
        let initialMaxDate = dateFormatter.dateFromString("01-06-2010")

        let dateRange = SChartDateRange(dateMinimum: initialMinDate, andDateMaximum: initialMaxDate)
        
        let xAxis = SChartDateTimeAxis(range: dateRange)
        xAxis.title = "Date"
        enablePanningAndZoomingOnAxis(xAxis)
        chart.xAxis = xAxis
        
        // Initially show range on y-axis between 150 and 300 USD
        let numberRange = SChartNumberRange(minimum: 150, andMaximum: 300)
        
        // Stock price y axis
        let stockPriceAxis = SChartNumberAxis(range: numberRange)
        stockPriceAxis.title = "Price (USD)"
        enablePanningAndZoomingOnAxis(stockPriceAxis)
        chart.addYAxis(stockPriceAxis)
        
        // Secondary Y axis for volume data
        let volumeAxis = SChartNumberAxis()
        volumeAxis.title = "Volume"
        
        // Format label to hide decimal places and append 'M' units
        volumeAxis.labelFormatString = "%.0fM"
        
        // Render on right-hand side (reverse)
        volumeAxis.axisPosition = SChartAxisPositionReverse
        
        // Hide gridlines
        volumeAxis.style.majorGridLineStyle.showMajorGridLines = false
        
        // Add upper padding to make the volume chart occupy bottom half of the plot area
        volumeAxis.rangePaddingHigh = 100
        
        chart.addYAxis(volumeAxis)
        
        loadChartData()
        
        // This controller will provide the chart data
        chart.datasource = self
        
        // Designate this controller as the delegate to enable alteration of tick marks
        chart.delegate = self
        
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
            
            let volumeDataPoint = SChartDataPoint()
            volumeDataPoint.xValue = date
            
            let volume = dataPoint["volume"]! as Double
            // Convert volume count to be in terms of millions
            volumeDataPoint.yValue = volume/1000000
            volumeData.append(volumeDataPoint)
            
        }
    }
    
    // MARK:- SChartDatasource Methods
    
    // As we have multiple y-axes, need to specify which the series each axis corresponds to
    func sChart(chart: ShinobiChart!, yAxisForSeriesAtIndex index: Int) -> SChartAxis! {
        return chart.allYAxes()[index] as SChartAxis
    }
    
    // Two sets of data (stock prices and volume)
    func numberOfSeriesInSChart(chart: ShinobiChart!) -> Int {
        return 2
    }
    
    // Create series objects
    func sChart(chart: ShinobiChart!, seriesAtIndex index: Int) -> SChartSeries! {
        return index == 0 ? SChartLineSeries() : SChartColumnSeries()
    }
    
    func sChart(chart: ShinobiChart!, numberOfDataPointsForSeriesAtIndex seriesIndex: Int) -> Int {
        return stockPriceData.count
    }
    
    func sChart(chart: ShinobiChart!, dataPointAtIndex dataIndex: Int, forSeriesAtIndex seriesIndex: Int) -> SChartData! {
        return seriesIndex == 0 ? stockPriceData[dataIndex] : volumeData[dataIndex]
    }
    
    // MARK:- SChartDelegate Methods
    
    // Hide tick marks with values above 100M
    func sChart(chart: ShinobiChart!, alterTickMark tickMark: SChartTickMark!, beforeAddingToAxis axis: SChartAxis!) {
        if let volumeAxis = chart.allYAxes().last as? SChartAxis {
            if axis == volumeAxis {
                if tickMark.value > 100 {
                    if let view = tickMark.tickMarkView {
                        view.hidden = true
                    }
                    if let label = tickMark.tickLabel {
                        label.text = ""
                    }
                }
            }
        }
    }
    
}
