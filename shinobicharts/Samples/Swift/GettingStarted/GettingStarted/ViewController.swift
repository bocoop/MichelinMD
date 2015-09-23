//
//  ViewController.swift
//  GettingStartedSwift
//
//  Created by Chris Grant on 18/06/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SChartDatasource {
                            
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        
        let margin = (UIDevice.currentDevice().userInterfaceIdiom == .Phone) ? CGFloat(20) : CGFloat(50)
        let chart = ShinobiChart(frame: CGRectInset(view.bounds, margin, margin))
        chart.title = "Trigonometric Functions"
        chart.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        
        chart.licenseKey = "" // TODO: add your trial licence key here!
        
        // add a pair of axes
        let xAxis = SChartNumberAxis()
        xAxis.title = "X Value"
        chart.xAxis = xAxis
        
        let yAxis = SChartNumberAxis()
        yAxis.title = "Y Value"
        yAxis.rangePaddingLow = 0.1
        yAxis.rangePaddingHigh = 0.1
        chart.yAxis = yAxis
        
        // enable gestures
        yAxis.enableGesturePanning = true
        yAxis.enableGestureZooming = true
        xAxis.enableGesturePanning = true
        xAxis.enableGestureZooming = true
        
        chart.datasource = self
        
        chart.legend.hidden = UIDevice.currentDevice().userInterfaceIdiom == .Phone

        view.addSubview(chart)
    }

    func numberOfSeriesInSChart(chart: ShinobiChart!) -> Int {
        return 2
    }
    
    func sChart(chart: ShinobiChart!, seriesAtIndex index: Int) -> SChartSeries! {
        var lineSeries = SChartLineSeries()
        lineSeries.style().showFill = true
        
        if index == 0 {
            lineSeries.title = "y = cos(x)"
        } else {
            lineSeries.title = "y = sin(x)"
        }
        
        return lineSeries
    }
    
    func sChart(chart: ShinobiChart!, numberOfDataPointsForSeriesAtIndex seriesIndex: Int) -> Int {
        return 100
    }
    
    func sChart(chart: ShinobiChart!, dataPointAtIndex dataIndex: Int, forSeriesAtIndex seriesIndex: Int) -> SChartData! {
        let datapoint = SChartDataPoint()
        
        // both functions share the same x-values
        let xValue = Double(dataIndex) / 10.0
        datapoint.xValue = xValue
        
        // compute the y-value for each series
        if seriesIndex == 0 {
            datapoint.yValue = cos(Double(xValue))
        } else {
            datapoint.yValue = sin(Double(xValue))
        }
        
        return datapoint
    }
}
