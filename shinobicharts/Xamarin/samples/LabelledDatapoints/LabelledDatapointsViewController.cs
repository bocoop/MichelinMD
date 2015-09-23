//
// LabelledDatapointsViewController.cs
//
// Copyright 2013 Scott Logic Ltd. All rights reserved.
//
﻿using System;
using CoreGraphics;
using Foundation;
using UIKit;
using ShinobiCharts;

namespace LabelledDatapoints
{
	public partial class LabelledDatapointsViewController : UIViewController
	{
		static bool UserInterfaceIdiomIsPhone {
			get { return UIDevice.CurrentDevice.UserInterfaceIdiom == UIUserInterfaceIdiom.Phone; }
		}

		static string XibName {
			get { return UserInterfaceIdiomIsPhone ? "LabelledDatapointsViewController_iPhone" : "LabelledDatapointsViewController_iPad"; }
		}

		public LabelledDatapointsViewController ()
			: base (XibName, null)
		{
		}

		public override void ViewDidLoad ()
		{
			base.ViewDidLoad ();

			// Set up chart
			ShinobiChart chart = new ShinobiChart (View.Bounds, SChartAxisType.Number, SChartAxisType.Number) {
				DataSource = new LabelledDatapointsDataSource(),
				Delegate = new LabelledDatapointsDelegate(),
				AutoresizingMask = ~UIViewAutoresizing.None,
			};
			View.AddSubview (chart);

			chart.YAxis.RangePaddingLow = new NSNumber(0.5);
			chart.YAxis.RangePaddingHigh = new NSNumber(0.5);
			chart.RedrawChart ();
		}

		public override bool PrefersStatusBarHidden ()
		{
			return true;
		}
	}
}

