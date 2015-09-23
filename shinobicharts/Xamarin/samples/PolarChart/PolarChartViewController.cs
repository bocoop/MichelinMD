//
// PolarChartViewController.cs
//
// Copyright 2013 Scott Logic Ltd. All rights reserved.
//
﻿using System;
using CoreGraphics;
using Foundation;
using UIKit;
using ShinobiCharts;

namespace PolarChart
{
	public partial class PolarChartViewController : UIViewController
	{
		static bool UserInterfaceIdiomIsPhone {
			get { return UIDevice.CurrentDevice.UserInterfaceIdiom == UIUserInterfaceIdiom.Phone; }
		}

		ShinobiChart chart;

		public PolarChartViewController ()
			: base (UserInterfaceIdiomIsPhone ? "PolarChartViewController_iPhone" : "PolarChartViewController_iPad", null)
		{
		}

		public override void ViewDidLoad ()
		{
			base.ViewDidLoad ();

			// Create the chart.
			chart = new ShinobiChart (View.Bounds);

			// Set the data source
			chart.DataSource = new PolarChartDataSource ();

			// Create the axes
			chart.XAxis = new SChartNumberAxis ();
			chart.YAxis = new SChartNumberAxis ();

			// Ensure the chart fills the screen.
			chart.AutoresizingMask = ~UIViewAutoresizing.None;

			// TODO: Add your trial licence key here!
			chart.LicenseKey = "";

			// Add the chart to the view.
			View.AddSubview (chart);
		}
	}
}

