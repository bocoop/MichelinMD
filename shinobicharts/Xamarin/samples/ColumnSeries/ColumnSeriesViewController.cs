//
// ColumnSeriesViewController.cs
//
// Copyright 2013 Scott Logic Ltd. All rights reserved.
//
using System;
using CoreGraphics;
using Foundation;
using UIKit;

using ShinobiCharts;

namespace ColumnSeries
{
	public partial class ColumnSeriesViewController : UIViewController
	{
		static bool UserInterfaceIdiomIsPhone {
			get { return UIDevice.CurrentDevice.UserInterfaceIdiom == UIUserInterfaceIdiom.Phone; }
		}

		ShinobiChart chart;

		public ColumnSeriesViewController ()
			: base (UserInterfaceIdiomIsPhone ? "ColumnSeriesViewController_iPhone" : "ColumnSeriesViewController_iPad", null)
		{
		}

		public override void ViewDidLoad ()
		{
			base.ViewDidLoad ();

			// Create the chart
			nfloat margin = UserInterfaceIdiomIsPhone ? 10 : 50;
			chart = new ShinobiChart (new CGRect (margin, margin, View.Bounds.Width - 2 * margin, View.Bounds.Height - 2 * margin)) {
				Title = "Grocery Sales Figures",
				AutoresizingMask = ~UIViewAutoresizing.None,
				LicenseKey = "" // TODO: add your trail licence key here!
			};

			// Add a pair of axes
			SChartCategoryAxis xAxis = new SChartCategoryAxis ();
			xAxis.Style.InterSeriesPadding = 0.1;
			chart.XAxis = xAxis;

			SChartAxis yAxis = new SChartNumberAxis () {
				Title = "Sales (1000s)",
				RangePaddingHigh = new NSNumber(1)
			};
			chart.YAxis = yAxis;

			// Add the the view
			View.AddSubview (chart);

			// Set the data source
			chart.DataSource = new ColumnSeriesDataSource ();

			// Show the legend on iPad only
			if(!UserInterfaceIdiomIsPhone) {
				chart.Legend.Hidden = false;
				chart.Legend.Placement = SChartLegendPlacement.InsidePlotArea;
			}
		}

		[Obsolete]
		public override bool ShouldAutorotateToInterfaceOrientation (UIInterfaceOrientation toInterfaceOrientation)
		{
			return !UserInterfaceIdiomIsPhone || toInterfaceOrientation != UIInterfaceOrientation.PortraitUpsideDown;
		}
	}
}

