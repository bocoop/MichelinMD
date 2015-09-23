//
// MultipleAxesViewController.cs
//
// Copyright 2013 Scott Logic Ltd. All rights reserved.
//
using System;
using CoreGraphics;
using Foundation;
using UIKit;

using ShinobiCharts;

namespace MultipleAxes
{
	public partial class MultipleAxesViewController : UIViewController
	{
		static bool UserInterfaceIdiomIsPhone {
			get { return UIDevice.CurrentDevice.UserInterfaceIdiom == UIUserInterfaceIdiom.Phone; }
		}

		ShinobiChart chart;

		public MultipleAxesViewController ()
			: base (UserInterfaceIdiomIsPhone ? "MultipleAxesViewController_iPhone" : "MultipleAxesViewController_iPad", null)
		{
		}

		public override void ViewDidLoad ()
		{
			base.ViewDidLoad ();
			NSDateFormatter dateFormatter = new NSDateFormatter { DateFormat = "dd-MM-yyyy" };

			// Create the chart
			View.BackgroundColor = UIColor.White;
			nfloat margin = UserInterfaceIdiomIsPhone ? 10 : 50;
			CGRect frame = new CGRect (margin, margin, View.Bounds.Width - 2 * margin, View.Bounds.Height - 2 * margin);
			chart = new ShinobiChart (frame) {
				Title = "Apple Stock Pirce",
				AutoresizingMask = ~UIViewAutoresizing.None,

				LicenseKey = "", // TODO: add your trail license key here!

				// add X & Y axes, with explicit ranges so that the chart is initially rendered 'zoomed in'
				XAxis = new SChartDateTimeAxis(new SChartDateRange(dateFormatter.Parse("01-01-2010"), dateFormatter.Parse("01-06-2010"))) {
					Title = "Date",
					EnableGesturePanning = true,
					EnableGestureZooming = true
				},

				YAxis = new SChartNumberAxis(new SChartNumberRange(150, 300)) {
					Title = "Price (USD)",
					EnableGesturePanning = true,
					EnableGestureZooming = true
				},

				DataSource = new MultipleAxesDataSource(),
				Delegate = new MultipleAxesDelegate()
			};

			// Add a secondary y-axis for volume
			SChartNumberAxis volumeAxis = new SChartNumberAxis {
				// Render on the right-hand side
				AxisPosition = SChartAxisPosition.Reverse,
				Title = "Volume",
				// Add an upper padding so that the volume chart occupies the bottom hald of the plot area
				RangePaddingHigh = new NSNumber(100)
			};

			NSNumberFormatter volumeFormatter = (volumeAxis.LabelFormatter.Formatter as NSNumberFormatter);
			volumeFormatter.MaximumFractionDigits = 0;
			volumeFormatter.PositiveSuffix = "M";
			volumeFormatter.NegativeSuffix = "M";

			// Hide gridlines
			volumeAxis.Style.MajorGridLineStyle.ShowMajorGridLines = false;
			chart.AddYAxis (volumeAxis);

			View.AddSubview (chart);
		}

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

