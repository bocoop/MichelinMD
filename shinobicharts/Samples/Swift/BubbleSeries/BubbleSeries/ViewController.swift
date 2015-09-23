//
//  ViewController.swift
//  ShinobiControls
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SChartDatasource {
    
    // Store data points for chart
    var data: [SChartDataPoint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set a margin, inset from edge determined by device used
        let margin: CGFloat = UIDevice.currentDevice().userInterfaceIdiom == .Phone ? 20 : 50
        
        // Create the chart
        let chart = ShinobiChart(frame: CGRectInset(view.bounds, margin, margin))
        chart.title = "Project Commit Punchcard"
        
        chart.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        
        chart.licenseKey = "" // TODO: Add your trial license key here
        
        // Axes creation
        let yAxis = SChartCategoryAxis()
        yAxis.title = "Day"
        yAxis.rangePaddingHigh = 0.5
        yAxis.rangePaddingLow = 0.5
        
        let xAxis = SChartNumberAxis()
        xAxis.title = "Hour"
        xAxis.rangePaddingHigh = 0.5
        xAxis.rangePaddingLow = 0.5
        
        // Add both axes to the chart
        chart.xAxis = xAxis
        chart.yAxis = yAxis
        
        // Load chart data
        loadCommitData()
        
        // Set this view controller as the provider of data to the chart
        chart.datasource = self
        
        // Add chart to the view
        view.addSubview(chart)
    }
    
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
    
    // Load and parse contents of JSON file into data array
    func loadCommitData() {
        
        // Iterate through hourly commit data loaded from punchcard.json file
        for commitInterval in JSONDataFromFile("punchcard") {
            
            let numberOfCommits = commitInterval["commits"]! as Int
            
            // Only add data point to array if at least one commit made
            if numberOfCommits > 0 {
                
                // Create SChartBubbleDataPoint object and set x and y values
                let bubbleDataPoint = SChartBubbleDataPoint()
                bubbleDataPoint.xValue = commitInterval["hour"]
                bubbleDataPoint.yValue = commitInterval["day"]
                bubbleDataPoint.area = Double(numberOfCommits)
                
                // Finally, add new data point to array
                data.append(bubbleDataPoint)
            }
            
        }
        
    }
    
    // MARK:- SChartDatasource Functions
    
    // We have one series of data (commit data)
    func numberOfSeriesInSChart(chart: ShinobiChart!) -> Int {
        return 1
    }
    
    // Create bubble series object
    func sChart(chart: ShinobiChart!, seriesAtIndex index: Int) -> SChartSeries! {
        let bubbleSeries = SChartBubbleSeries()
        
        // configure maximum value's bubble diameter
        bubbleSeries.biggestBubbleDiameterForAutoScaling = 40
        
        return bubbleSeries
    }
    
    // Number of data points is equal to length of commit data array loaded from the JSON file
    func sChart(chart: ShinobiChart!, numberOfDataPointsForSeriesAtIndex seriesIndex: Int) -> Int {
        return data.count
    }
    
    // Retrieve SChartDataPoint from data array
    func sChart(chart: ShinobiChart!, dataPointAtIndex dataIndex: Int, forSeriesAtIndex seriesIndex: Int) -> SChartData! {
        return data[dataIndex]
    }

}

