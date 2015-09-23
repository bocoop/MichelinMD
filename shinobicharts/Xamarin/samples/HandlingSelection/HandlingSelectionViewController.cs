//
// HandlingSelectionViewController.cs
//
// Copyright 2013 Scott Logic Ltd. All rights reserved.
//
using System;
using CoreGraphics;
using Foundation;
using UIKit;

using ShinobiCharts;
using System.Collections.Generic;

namespace HandlingSelection
{
	public partial class HandlingSelectionViewController : UIViewController
	{
		static bool UserInterfaceIdiomIsPhone {
			get { return UIDevice.CurrentDevice.UserInterfaceIdiom == UIUserInterfaceIdiom.Phone; }
		}

		static string XibName {
			get { return UserInterfaceIdiomIsPhone ? "HandlingSelectionViewController_iPhone" : "HandlingSelectionViewController_iPad"; }
		}

		public HandlingSelectionViewController () : base (XibName, null) { }

		[Obsolete ("Deprecated in iOS6. Replace it with both GetSupportedInterfaceOrientations and PreferredInterfaceOrientationForPresentation")]
		public override bool ShouldAutorotateToInterfaceOrientation (UIInterfaceOrientation toInterfaceOrientation)
		{
			// Return true for supported orientations
			if (UserInterfaceIdiomIsPhone) {
				return (toInterfaceOrientation != UIInterfaceOrientation.PortraitUpsideDown);
			} else {
				return true;
			}
		}

		ShinobiChart columnChart;
		ShinobiChart pieChart;

		ColumnChartDataSource columnChartDataSource;
		PieChartDataSource pieChartDataSource;

		public override void ViewDidLoad ()
		{
			base.ViewDidLoad ();

			// Create the data
			var sales = new List<Tuple<string, List<Tuple<string, double>>>> {
				{
					"2012", new List<Tuple<string, double>> {
						{ "Broccoli", 5.65 },
						{ "Carrots", 12.6 },
						{ "Mushrooms", 8.4 }
					}
				},
				{
					"2013", new List<Tuple<string, double>> {
						{ "Broccoli", 4.35 },
						{ "Carrots", 13.2 },
						{ "Mushrooms", 4.6 },
						{ "Okra", 0.6 }
					}
				}
			};

			// Create datasources for each chart
			columnChartDataSource = new ColumnChartDataSource (sales, "2012");
			pieChartDataSource = new PieChartDataSource (sales, columnChartDataSource.DisplayYear);

			// Create the charts
			CreateColumnChart (new CGRect (0, 0, View.Bounds.Width, View.Bounds.Height / 2));
			CreatePieChart (new CGRect (0, View.Bounds.Height / 2, View.Bounds.Width, View.Bounds.Height / 2));
		}

		void CreateColumnChart (CGRect frame)
		{
			// Create the chart
			columnChart = new ShinobiChart (frame.Inset(40)) {
				Title = "Grocery Sales Figures",
				AutoresizingMask = ~UIViewAutoresizing.None,
				LicenseKey = "" //TODO: add your trail licence key here!
			};

			// Add a pair of axes
			var xAxis = new SChartCategoryAxis ();
			xAxis.Style.InterSeriesPadding = 0;
			columnChart.XAxis = xAxis;

			var yAxis = new SChartNumberAxis {
				Title = "Sales (1000s)",
				RangePaddingHigh = new NSNumber(1)
			};
			columnChart.YAxis = yAxis;

			// Add to the view
			View.AddSubview (columnChart);

			var columnChartDelegate = new ColumnChartDelegate();
			columnChartDelegate.ToggledSelection += ColumnChartToggledSelection;

			columnChart.DataSource = columnChartDataSource;
			columnChart.Delegate = columnChartDelegate;

			// Show the legend
			columnChart.Legend.Hidden = false;
			columnChart.Legend.Placement = SChartLegendPlacement.InsidePlotArea;

		}

		void ColumnChartToggledSelection (ShinobiChart chart, SChartSeries series, SChartDataPoint dataPoint, CGPoint pixelPoint)
		{
			// Determine which year was tapped
			string tappedYear = series.Title;

			// Update the datasources
			columnChartDataSource.DisplayYear = tappedYear;
			pieChartDataSource.DisplayYear = tappedYear;

			// Update the pie chart state
			UpdatePieTitle ();
			pieChart.ReloadData ();
			pieChart.RedrawChart ();
		}

		void CreatePieChart (CGRect frame)
		{
			// Create the chart
			pieChart = new ShinobiChart (frame.Inset(40)) {
				AutoresizingMask = ~UIViewAutoresizing.None,
				LicenseKey = "", // TODO: add your trail licence key here!
				DataSource = pieChartDataSource
			};
			UpdatePieTitle ();
			pieChart.Legend.Hidden = false;

			View.AddSubview (pieChart);
		}

		void UpdatePieTitle ()
		{
			pieChart.Title = String.Format ("Grocery Sales For {0}", pieChartDataSource.DisplayYear);
		}
	}
}

