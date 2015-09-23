//
// ViewController.swift
// ShinobiControls
//
// Copyright (c) Scott Logic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SChartDatasource {
    
    var timeSeries: Array<SChartMultiYDataPoint> = Array()
    let dateFormatter: NSDateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let margin = (UIDevice.currentDevice().userInterfaceIdiom == .Phone) ? CGFloat(20) : CGFloat(50)
        let chart = ShinobiChart(frame: CGRectInset(view.bounds, margin, margin))
        chart.title = "Apple Stock Price"
        chart.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        
        chart.licenseKey = "" // TODO: add your trial licence key here!
        
        // add a pair of axes
        let xAxis = SChartDateTimeAxis()
        xAxis.title = "Date"
        chart.xAxis = xAxis
        
        let yAxis = SChartNumberAxis()
        yAxis.title = "Price (USD)"
        chart.yAxis = yAxis
        
        loadChartData()
        
        // enable gestures
        yAxis.enableGesturePanning = true
        yAxis.enableGestureZooming = true
        xAxis.enableGesturePanning = true
        xAxis.enableGestureZooming = true
        
        view.addSubview(chart)
        
        chart.datasource = self
    }
    
    func loadChartData () {
        // load the JSON data into an array
        let filePath = NSBundle.mainBundle().pathForResource("AppleStockPrices", ofType: "json")
        let json = NSData(contentsOfFile: filePath!)
        
        let jsonData = NSJSONSerialization.JSONObjectWithData(json!, options: .MutableContainers, error: nil) as Array<Dictionary<String, AnyObject>>
        
        for dict in jsonData {
            
            let date = dict["date"] as NSString
            let open = dict["open"] as NSNumber
            let high = dict["high"] as NSNumber
            let low = dict["low"] as NSNumber
            let close = dict["close"] as NSNumber
            
            let datapoint = SChartMultiYDataPoint()
            datapoint.xValue = dateFormatter.dateFromString(date)
            
            let yValue = NSMutableDictionary(objectsAndKeys: open, SChartCandlestickKeyOpen, high, SChartCandlestickKeyHigh, low, SChartCandlestickKeyLow, close, SChartCandlestickKeyClose)
            
            datapoint.yValues = yValue
            
            timeSeries.append(datapoint)
        }
    }
    
    func numberOfSeriesInSChart(chart: ShinobiChart!) -> Int {
        return 1
    }
    
    func sChart(chart: ShinobiChart!, seriesAtIndex index: Int) -> SChartSeries! {
        var candleStickSeries = SChartCandlestickSeries()
        return candleStickSeries
    }
    
    func sChart(chart: ShinobiChart!, numberOfDataPointsForSeriesAtIndex seriesIndex: Int) -> Int {
        return timeSeries.count
    }
    
    func sChart(chart: ShinobiChart!, dataPointAtIndex dataIndex: Int, forSeriesAtIndex seriesIndex: Int) -> SChartData! {
        return timeSeries[dataIndex]
    }
}
