//
// AddingAnnotationsViewController.cs
//
// Copyright 2013 Scott Logic Ltd. All rights reserved.
//
using System;
using CoreGraphics;
using Foundation;
using UIKit;

using ShinobiCharts;

namespace AddingAnnotations
{
	public partial class AddingAnnotationsViewController : UIViewController
	{
		static bool UserInterfaceIdiomIsPhone {
			get { return UIDevice.CurrentDevice.UserInterfaceIdiom == UIUserInterfaceIdiom.Phone; }
		}

		ShinobiChart chart;

		public AddingAnnotationsViewController ()
			: base (UserInterfaceIdiomIsPhone ? "AddingAnnotationsViewController_iPhone" : "AddingAnnotationsViewController_iPad", null)
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
				Title = "Apple Stock Price",
				AutoresizingMask = ~UIViewAutoresizing.None,
				LicenseKey = "", // TODO: add your trail licence key here!

				// add the axes
				XAxis = new SChartDateTimeAxis { Title = "Date" },
				YAxis = new SChartNumberAxis { Title = "Price (USD)" }
			};

			foreach(SChartAxis axis in chart.AllAxes) {
				axis.EnableGesturePanning = true;
				axis.EnableGestureZooming = true;
				axis.EnableMomentumPanning = true;
				axis.EnableMomentumZooming = true;
			}

			View.AddSubview(chart);

			chart.Delegate = new AddingAnnotationsDelegate ();
			chart.DataSource = new AddingAnnotationsDataSource ();
		}

		[Obsolete ("Deprecated in iOS6. Replace it with both GetSupportedInterfaceOrientations and PreferredInterfaceOrientationForPresentation")]
		public override bool ShouldAutorotateToInterfaceOrientation (UIInterfaceOrientation toInterfaceOrientation)
		{
			return !(UserInterfaceIdiomIsPhone && toInterfaceOrientation == UIInterfaceOrientation.PortraitUpsideDown);
		}
	}
}

