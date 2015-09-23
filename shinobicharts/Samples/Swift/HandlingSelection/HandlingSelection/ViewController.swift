//
//  ViewController.swift
//  ShinobiControls
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SChartDelegate {
    
    // Grocery sales data maps a year to dictionaries containing key value pairs matching grocery items to sales (in 1000s)
    let salesData: [String : [String : Double]] = [
        "2014" : ["Broccoli" : 4.35, "Carrots" : 13.2, "Mushrooms" : 4.6, "Okra" : 0.6], // 2014 sales
        "2013" : ["Broccoli" : 5.65, "Carrots" : 12.6, "Mushrooms" : 8.4] // 2013 sales
    ]
    
    // Initial year to display in both charts
    let initialDisplayYear = "2014"
    
    // Datasource instances
    let columnChartDatasource: ColumnChartDatasource
    let pieChartDatasource: PieChartDatasource
    
    // ShinobiChart instances created automatically using the storyboard
    @IBOutlet weak var columnChart: ShinobiChart!
    @IBOutlet weak var pieChart: ShinobiChart!
    
    required init(coder aDecoder: NSCoder) {
        
        // Utility method that prevents having to add key to every chart instance
        ShinobiCharts.setLicenseKey("") // TODO: Add your trial license key here
        
        // Create datasource objects to separate logic into specialized classes
        columnChartDatasource = ColumnChartDatasource(salesData: salesData, year: initialDisplayYear)
        pieChartDatasource = PieChartDatasource(salesData: salesData, year: initialDisplayYear)
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up both charts
        configureColumnChart()
        configurePieChart()
    }
    
    // Configure chart instance to display column series
    func configureColumnChart() {
        columnChart.title = "Grocery Sales Figures"
        
        // Create and add the axes to the chart
        let xAxis = SChartCategoryAxis()
        // Ensure sales data of the same grocery type are alongside each other with no space between them
        xAxis.style.interSeriesPadding = 0
        
        let yAxis = SChartNumberAxis()
        yAxis.title = "Sales (1000s)"
        yAxis.rangePaddingHigh = 1
        
        columnChart.xAxis = xAxis
        columnChart.yAxis = yAxis
        
        // External custom object will provide the data
        columnChart.datasource = columnChartDatasource
        
        // Stops chart listening on a timeout for a double tap
        // Therefore speeds up selection of column series
        columnChart.gestureDoubleTapEnabled = false
        
        // However, this view controller will respond to delegate functions called by column chart object
        columnChart.delegate = self
    }
    
    // Configure chart instance to display pie series
    func configurePieChart() {
        
        updatePieTitle()
        
        pieChart.datasource = pieChartDatasource
        
        pieChart.titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
        
        // Show pie chart legend
        pieChart.legend.hidden = false
        
        // Make segments unselectable
        pieChart.userInteractionEnabled = false
    }
    
    // Update the pie chart title with the current sales data year being viewed
    func updatePieTitle() {
        pieChart.title = "Grocery Sales For \(pieChartDatasource.displayYear) (1000s)"
    }
    
    // MARK:- SChartDelegate Functions
    
    // Listen out for selection of column series data points
    func sChart(chart: ShinobiChart!, toggledSelectionForSeries series: SChartSeries!, nearPoint dataPoint: SChartDataPoint!, atPixelCoordinate pixelPoint: CGPoint) {
        let tappedYear = series.title
        
        // Update pie chart only if selecting a new series of data
        if (tappedYear != pieChartDatasource.displayYear) {
            
            // Update datasources with year that selected sales data was from
            columnChartDatasource.displayYear = tappedYear
            pieChartDatasource.displayYear = tappedYear
            
            // Update pie chart state and reload
            updatePieTitle()
            pieChart.reloadData()
            pieChart.redrawChart()
        }
        else {
            // If user tapped an already selected item, make it remain selected
            series.selected = true
        }
    }

}

