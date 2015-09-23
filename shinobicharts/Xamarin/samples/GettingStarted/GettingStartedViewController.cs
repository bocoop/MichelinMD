//
// GettingStartedViewController.cs
//
// Copyright 2013 Scott Logic Ltd. All rights reserved.
//
using System;
using CoreGraphics;
using Foundation;
using UIKit;

using ShinobiCharts;

namespace GettingStarted
{
	public partial class GettingStartedViewController : UIViewController
	{
		static bool UserInterfaceIdiomIsPhone {
			get { return UIDevice.CurrentDevice.UserInterfaceIdiom == UIUserInterfaceIdiom.Phone; }
		}

		ShinobiChart chart;

		public GettingStartedViewController ()
			: base (UserInterfaceIdiomIsPhone ? "GettingStartedViewController_iPhone" : "GettingStartedViewController_iPad", null)
		{
		}

		public override void ViewDidLoad ()
		{
			base.ViewDidLoad ();
			
			View.BackgroundColor = UIColor.White;

			// Create the chart
			nfloat margin = UserInterfaceIdiomIsPhone ? 10 : 50;
			chart = new ShinobiChart (new CGRect (margin, margin, View.Bounds.Width - 2 * margin, View.Bounds.Height - 2 * margin)) {
				Title = "Trigonometric Functions",
				AutoresizingMask = ~UIViewAutoresizing.None,
				LicenseKey = "" // TODO: Add your trail licence key here!
			};

			// Add a pair of axes
			SChartNumberAxis xAxis = new SChartNumberAxis () {
				Title = "X Value"
			};
			chart.XAxis = xAxis;

			SChartNumberAxis yAxis = new SChartNumberAxis () {
				Title = "Y Value",
				RangePaddingLow = new NSNumber(0.1),
				RangePaddingHigh = new NSNumber(0.1)
			};
			chart.YAxis = yAxis;

			// Enable gestures
			xAxis.EnableGesturePanning = true;
			xAxis.EnableGestureZooming = true;
			yAxis.EnableGesturePanning = true;
			yAxis.EnableGestureZooming = true;

			// Add to the view
			View.AddSubview (chart);

			// Set the data source
			chart.DataSource = new GettingStartedDataSource();

			// Hide the legend if on displaying on iPhone to save space
			chart.Legend.Hidden = UserInterfaceIdiomIsPhone;
		}

		[Obsolete]
		public override bool ShouldAutorotateToInterfaceOrientation (UIInterfaceOrientation toInterfaceOrientation)
		{
			// Return true for supported orientations
			if (UserInterfaceIdiomIsPhone) {
				return (toInterfaceOrientation != UIInterfaceOrientation.PortraitUpsideDown);
			} else {
				return true;
			}
		}
	}
}

