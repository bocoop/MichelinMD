//
//  ViewController.swift
//  ShinobiControls
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SChartDelegate, SChartDatasource {
    
    var firstChartRender = true
    
    let dateFormatter = NSDateFormatter()
    
    /// Data points for chart
    var stockData: [SChartDataPoint] = []
    
    /// Chart view used to display stock data
    @IBOutlet weak var chart: ShinobiChart!
    
    required init(coder aDecoder: NSCoder) {
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the chart view
        chart.title = "Apple Stock Price"
        chart.licenseKey = "" // TODO: Add your trial license key here
        
        // Add the axes
        
        // X axis represents data of stock price data point
        let xAxis = SChartDateTimeAxis()
        xAxis.title = "Date"
        enablePanAndZoomForAxis(xAxis)
        chart.xAxis = xAxis
        
        // Y axis is price of stock for given date
        let yAxis = SChartNumberAxis()
        yAxis.title = "Price (USD)"
        enablePanAndZoomForAxis(yAxis)
        chart.yAxis = yAxis
        
        // Load the stock data
        loadStockData()
        
        // To add annotaions, need to respond to some delgate method calls
        chart.delegate = self
        // This view controller will provide the data
        chart.datasource = self
        
    }
    
    // MARK:- Custom Methods
    
    /**
        Enables panning and zooming for the given axis
    
        :param: axis The axis to enable panning and zooming on
    */
    func enablePanAndZoomForAxis(axis: SChartAxis) {
        axis.enableMomentumPanning = true
        axis.enableMomentumZooming = true
        axis.enableGestureZooming = true
        axis.enableGesturePanning = true
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
    
    /// Load apple stock data
    func loadStockData() {
        
        // Construct an SChartDataPoint object for each stock price data point
        for stockDataPoint in JSONDataFromFile("AppleStockPrices") {
            
            let dataPoint = SChartDataPoint()
            
            let dateString = stockDataPoint["date"]! as String
            dataPoint.xValue = dateFormatter.dateFromString(dateString)
            
            dataPoint.yValue = stockDataPoint["close"]! as Double

            stockData.append(dataPoint)
        }

    }
    
    /// Add annotations to chart corresponding to specific dates in stock price history
    func addDateMarkerAnnotations() {
        
        // Rotate labels by 90 degress anti-clockwise
        let angleOfRotation = CGFloat(-M_PI/2)
        let rotationTransform = CGAffineTransformRotate(CGAffineTransformIdentity, angleOfRotation)
        
        for dateAnnotation in JSONDataFromFile("Annotations") {
            
            // Get position on x-axis by retrieving data of annotation
            let dateString = dateAnnotation["date"]! as String
            let date = dateFormatter.dateFromString(dateString)
            
            // Position on y-axis is given in JSON data
            let yVal = dateAnnotation["y-location"]! as CGFloat
            
            // Retrieve annoation text
            let annotationText = dateAnnotation["annotation"]! as String
            
            // Add a vertical line annotation
            let annotationLine = SChartAnnotation.verticalLineAtPosition(date, withXAxis: chart.xAxis, andYAxis: chart.yAxis, withWidth: 2, withColor: UIColor(white: 0.9, alpha: 1))
            chart.addAnnotation(annotationLine)
            
            // Create annotation label
            let annotationLabel = SChartAnnotation(text: annotationText, andFont: UIFont.systemFontOfSize(14), withXAxis: chart.xAxis, andYAxis: chart.yAxis, atXPosition: date, andYPosition: yVal, withTextColor: UIColor.blackColor(), withBackgroundColor: chart.plotAreaBackgroundColor.colorWithAlphaComponent(0.6))
            
            // Rotate the label
            annotationLabel.transform = rotationTransform
            
            // Position label above chart data
            annotationLabel.position = SChartAnnotationAboveData
            
            // Add text annotation to chart
            chart.addAnnotation(annotationLabel)
        }
    }
    
    /// Add Apple logo image to chart as a custom annotation view
    func addAppleLogoToChart() {
        
        // Create a zoomable annotation
        let annotation = SChartAnnotationZooming()
        annotation.xAxis = chart.xAxis
        annotation.yAxis = chart.yAxis
        
        // Pin logo corners
        annotation.xValue = dateFormatter.dateFromString("01-01-2009")
        annotation.yValue = 250
        annotation.xValueMax = dateFormatter.dateFromString("01-01-2011")
        annotation.yValueMax = 550
        
        // Position below chart data
        annotation.position = SChartAnnotationBelowData
        
        // Load in image and add to annotation
        let logoView = UIImageView(image: UIImage(named: "Apple"))
        logoView.alpha = 0.2
        
        annotation.addSubview(logoView)
        
        // Finally, add annotation to chart
        chart.addAnnotation(annotation)
    }
    
    // MARK:- SChartDatasource Methods
    
    func numberOfSeriesInSChart(chart: ShinobiChart!) -> Int {
        return 1
    }
    
    func sChart(chart: ShinobiChart!, seriesAtIndex index: Int) -> SChartSeries! {
        return SChartLineSeries()
    }
    
    func sChart(chart: ShinobiChart!, numberOfDataPointsForSeriesAtIndex seriesIndex: Int) -> Int {
        return stockData.count
    }
    
    func sChart(chart: ShinobiChart!, dataPointAtIndex dataIndex: Int, forSeriesAtIndex seriesIndex: Int) -> SChartData! {
        return stockData[dataIndex]
    }
    
    // MARK:- SChartDelegate Methods
    
    // On first render, add annotations to chart
    func sChartRenderFinished(chart: ShinobiChart!) {
        if firstChartRender {
            firstChartRender = false
            
            // Add annotations to chart
            addAppleLogoToChart()
            addDateMarkerAnnotations()
        }
    }

}
