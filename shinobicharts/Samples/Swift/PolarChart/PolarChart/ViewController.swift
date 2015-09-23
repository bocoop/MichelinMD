//
//  ViewController.swift
//  ShinobiControls
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SChartDatasource {

    @IBOutlet weak var polarChart: ShinobiChart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        polarChart.licenseKey = "" // TODO: Add your Trial license key here
        
        polarChart.title = "Polar Chart Sample"
        
        // Create the chart axes
        polarChart.xAxis = SChartNumberAxis()
        polarChart.yAxis = SChartNumberAxis()
        
        // This view controller will provide the data to the chart
        polarChart.datasource = self
    }
    
    // MARK:- SChartDatasource Functions
    func numberOfSeriesInSChart(chart: ShinobiChart!) -> Int {
        return 1
    }
    
    // Create the radial line series object
    func sChart(chart: ShinobiChart!, seriesAtIndex index: Int) -> SChartSeries! {
        return SChartRadialLineSeries()
    }
    
    func sChart(chart: ShinobiChart!, numberOfDataPointsForSeriesAtIndex seriesIndex: Int) -> Int {
        return 360
    }
    
    func sChart(chart: ShinobiChart!, dataPointAtIndex dataIndex: Int, forSeriesAtIndex seriesIndex: Int) -> SChartData! {
        
        // Create data point objects and configure x and y values
        let dataPoint = SChartDataPoint()
        
        dataPoint.xValue = dataIndex
        dataPoint.yValue = dataIndex
        
        return dataPoint
    }

}
