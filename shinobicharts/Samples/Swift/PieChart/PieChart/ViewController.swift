//
//  ViewController.swift
//  ShinobiControls
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SChartDatasource, SChartDelegate {
    
    let drinkPopularityData: [String: Double] = ["Coke" : 20.5, "Coffee" : 39.5, "Tea" : 30.5, "Water" : 5, "Other" : 4.5]
    
    var selectedDrinksTotalPopularity = 0.00;
    
    // Chart created using a storyboard
    @IBOutlet weak var pieChart: ShinobiChart!
    
    // Label to display combined total of all selected segments
    @IBOutlet weak var selectedDrinksLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pieChart.title = "Most Popular Drinks (%)"
        
        pieChart.licenseKey = "" // TODO: Insert Trial license key here
        
        // Center title in view
        pieChart.titleCentresOn = SChartTitleCentresOnChart
        
        // Show the legend and position along the right edge in the middle of the screen
        pieChart.legend.hidden = false
        pieChart.legend.position = SChartLegendPositionMiddleRight
        
        // This view controller will provide the data points to the chart
        pieChart.datasource = self
        
        // Set this controller to be the chart's delegate in order to respond to touches on a pie segment
        pieChart.delegate = self;
    }
    
    // MARK:- SChartDatasource Functions
    
    // Only have one series of data to display (drink popularity)
    func numberOfSeriesInSChart(chart: ShinobiChart!) -> Int {
        return 1
    }
    
    // Create pie series object
    func sChart(chart: ShinobiChart!, seriesAtIndex index: Int) -> SChartSeries! {
        let pieSeries = SChartPieSeries()
        
        pieSeries.style().labelBackgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
        
        // Configure some basic styles when a segment is selected
        pieSeries.selectedStyle().protrusion = 30
        pieSeries.selectionAnimation.duration = 0.4
        pieSeries.selectedPosition = 0
        
        return pieSeries
    }
    
    func sChart(chart: ShinobiChart!, numberOfDataPointsForSeriesAtIndex seriesIndex: Int) -> Int {
        return drinkPopularityData.count
    }
    
    // Create data points to represent each segment of the pie chart
    func sChart(chart: ShinobiChart!, dataPointAtIndex dataIndex: Int, forSeriesAtIndex seriesIndex: Int) -> SChartData! {
        let dataPoint = SChartDataPoint()
        
        let drinkTitle = drinkPopularityData.keys.array[dataIndex]
        
        // Used to identify segment category in the legend
        dataPoint.xValue = drinkTitle
        // Value segment represents out of total
        dataPoint.yValue = drinkPopularityData[drinkTitle]
        
        return dataPoint
    }
    
    // MARK:- SChartDelegate Functions
    
    // Display combined popularity of all selected segments
    func sChart(chart: ShinobiChart!, toggledSelectionForRadialPoint dataPoint: SChartRadialDataPoint!, inSeries series: SChartRadialSeries!, atPixelCoordinate pixelPoint: CGPoint) {
        
        let yVal = dataPoint.yValue as Double
        
        if (dataPoint.selected) {
            selectedDrinksTotalPopularity += yVal
        }
        else {
            selectedDrinksTotalPopularity -= yVal
        }
        
        // Convert popularity total to string and update label text
        let popularityString = String(format:"%.2f", selectedDrinksTotalPopularity)
        selectedDrinksLabel.text = "Selected Drinks' Popularity: " + popularityString + "%"
    }
    
}
