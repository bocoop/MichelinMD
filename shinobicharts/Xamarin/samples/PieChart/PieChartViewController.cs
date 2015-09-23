//
// PieChartViewController.cs
//
// Copyright 2013 Scott Logic Ltd. All rights reserved.
//
using System;
using CoreGraphics;
using Foundation;
using UIKit;
using System.Collections.Generic;
using ShinobiCharts;

namespace PieChart
{
	public partial class PieChartViewController : UIViewController
	{
		static bool UserInterfaceIdiomIsPhone {
			get { return UIDevice.CurrentDevice.UserInterfaceIdiom == UIUserInterfaceIdiom.Phone; }
		}

		ShinobiChart chart;

		public PieChartViewController ()
			: base (UserInterfaceIdiomIsPhone ? "PieChartViewController_iPhone" : "PieChartViewController_iPad", null)
		{
		}

		public override void ViewDidLoad ()
		{
			base.ViewDidLoad ();

			// create the chart
			nfloat margin = UserInterfaceIdiomIsPhone ? 10 : 50;
			CGRect frame = new CGRect (margin, margin, View.Bounds.Width - 2 * margin, View.Bounds.Height - 2 * margin);
			chart = new ShinobiChart (frame) {
				Title = "Countries By Area",

				// ensure the chart fills the screen
				AutoresizingMask = ~UIViewAutoresizing.None,

				// TODO: add your trail licence key here!
				LicenseKey = ""
			};

			View.AddSubview (chart);

			chart.DataSource = new PieChartDataSource ();
			chart.Delegate = new PieChartDelegate ();

			// show the legend
			chart.Legend.Hidden = false;
		}
	}
}

