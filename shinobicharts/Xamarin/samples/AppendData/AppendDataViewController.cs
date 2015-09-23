//
// AppendDataViewController.cs
//
// Copyright 2013 Scott Logic Ltd. All rights reserved.
//
using System;
using CoreGraphics;
using Foundation;
using UIKit;

using ShinobiCharts;
using System.Collections.Generic;
using System.Timers;

namespace AppendData
{
	public partial class AppendDataViewController : UIViewController
	{
		static bool UserInterfaceIdiomIsPhone {
			get { return UIDevice.CurrentDevice.UserInterfaceIdiom == UIUserInterfaceIdiom.Phone; }
		}

		public AppendDataViewController () : base (UserInterfaceIdiomIsPhone ? "AppendDataViewController_iPhone" : "AppendDataViewController_iPad", null)
		{
		}

		ShinobiChart chart;

		public override void ViewDidLoad ()
		{
			base.ViewDidLoad ();

			// Create the chart
			chart = new ShinobiChart (new CGRect(20, 20, View.Bounds.Width - 40, View.Bounds.Height - 40)) {
				Title = "Streaming",
				AutoresizingMask = ~UIViewAutoresizing.None,

				// Use a number axis for the x axis
				XAxis = new SChartNumberAxis(),

				// Use a number axis for the y axis
				YAxis = new SChartNumberAxis(),

				DataSource = new AppendDataDataSource()
			};

			// Add the chart to the view controller
			View.AddSubview (chart);

			// Setup a timer to increment the data
			Timer timer = new Timer ();
			timer.Interval = 10;
			timer.Elapsed += (s, e) => {
				// Take care to update on the main thread
				BeginInvokeOnMainThread (() => {
					// Update our data
					(chart.DataSource as AppendDataDataSource).AdvanceData();

					//Refresh the chart
					chart.RemoveFromStart(1, 0);
					chart.AppendToEnd(1, 0);
					chart.RedrawChart();
				});
			};
			timer.Start ();
		}
	}
}

