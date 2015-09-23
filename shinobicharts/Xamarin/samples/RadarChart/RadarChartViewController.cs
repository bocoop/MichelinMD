//
// RadarChartViewController.cs
//
// Copyright 2013 Scott Logic Ltd. All rights reserved.
//
﻿using System;
using CoreGraphics;
using Foundation;
using UIKit;
using ShinobiCharts;

namespace RadarChart
{
	public partial class RadarChartViewController : UIViewController
	{
		static bool UserInterfaceIdiomIsPhone {
			get { return UIDevice.CurrentDevice.UserInterfaceIdiom == UIUserInterfaceIdiom.Phone; }
		}

		ShinobiChart chart;

		public RadarChartViewController ()
			: base (UserInterfaceIdiomIsPhone ? "RadarChartViewController_iPhone" : "RadarChartViewController_iPad", null)
		{
		}

		public override void ViewDidLoad ()
		{
			base.ViewDidLoad ();

			// Create the chart.
			chart = new ShinobiChart (View.Bounds);

			// Assign the data source
			chart.DataSource = new RadarChartDataSource ();

			// Create the axes
			chart.XAxis = new SChartCategoryAxis ();
			chart.YAxis = new SChartNumberAxis (new SChartNumberRange (0, 100));

			// Make X-Axis line draw as a spiderweb
			chart.XAxis.Style.MajorGridLineStyle.LineRenderMode = SChartRadialLineRenderMode.Linear;
			chart.XAxis.Style.MajorGridLineStyle.ShowMajorGridLines = true;
			chart.XAxis.Style.MajorGridLineStyle.LineColor = UIColor.LightGray;

			// Make Y-Axis gridlines draw as a spiderweb
			chart.YAxis.Style.MajorGridLineStyle.LineRenderMode = SChartRadialLineRenderMode.Linear;
			chart.YAxis.Style.MajorGridLineStyle.ShowMajorGridLines = true;
			chart.YAxis.Style.MajorGridLineStyle.LineColor = UIColor.LightGray;

			// Ensure the chart fills the screen
			chart.AutoresizingMask = ~UIViewAutoresizing.None;

			// TODO: Add your trial licence key here!
			chart.LicenseKey = "";

			// Add the chart to the view.
			View.AddSubview (chart);
		}
	}
}

