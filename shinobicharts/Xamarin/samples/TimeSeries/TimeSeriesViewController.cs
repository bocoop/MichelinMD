//
// TimeSeriesViewController.cs
//
// Copyright 2013 Scott Logic Ltd. All rights reserved.
//
using System;
using CoreGraphics;
using Foundation;
using UIKit;
using ShinobiCharts;

namespace TimeSeries
{
	public partial class TimeSeriesViewController : UIViewController
	{
		static bool UserInterfaceIdiomIsPhone {
			get { return UIDevice.CurrentDevice.UserInterfaceIdiom == UIUserInterfaceIdiom.Phone; }
		}

		ShinobiChart chart;

		public TimeSeriesViewController ()
			: base (UserInterfaceIdiomIsPhone ? "TimeSeriesViewController_iPhone" : "TimeSeriesViewController_iPad", null)
		{
		}

		public override void ViewDidLoad ()
		{
			base.ViewDidLoad ();

			// Create the chart
			View.BackgroundColor = UIColor.White;
			nfloat margin = UserInterfaceIdiomIsPhone ? 10 : 50;
			CGRect frame = new CGRect (margin, margin, View.Bounds.Width - 2 * margin, View.Bounds.Height - 2 * margin);
			chart = new ShinobiChart (frame) {
				Title = "Apple Stock price",
				AutoresizingMask = ~UIViewAutoresizing.None,
				LicenseKey = "" // TODO: add your trail licence key here!
			};

			// A time period that defines the weekends
			SChartRepeatedTimePeriod weekends = new SChartRepeatedTimePeriod (
				new NSDateFormatter { DateFormat = "dd-MM-yyyy" }.Parse ("02-01-2010"),
				SChartDateFrequency.CreateWithDay (2),
				SChartDateFrequency.CreateWithWeek (1));

			// Add a discountinuous date axis
			SChartDiscontinuousDateTimeAxis xAxis = new SChartDiscontinuousDateTimeAxis (){
				Title = "Date",
				EnableGesturePanning = true,
				EnableGestureZooming = true
			};
			xAxis.AddExcludedRepeatedTimePeriod (weekends);
			chart.XAxis = xAxis;

			chart.YAxis = new SChartNumberAxis {
				Title = "Price (USD)",
				EnableGesturePanning = true,
				EnableGestureZooming = true
			};

			View.AddSubview (chart);

			chart.DataSource = new TimeSeriesDataSource ();
		}
	}
}

