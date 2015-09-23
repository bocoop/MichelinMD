//
// LabelledDatapointsDelegate.cs
//
// Copyright 2013 Scott Logic Ltd. All rights reserved.
//
﻿using System;
using ShinobiCharts;
using UIKit;
using CoreGraphics;

namespace LabelledDatapoints
{
	public class LabelledDatapointsDelegate : SChartDelegate
	{
		public override void AlterDataPointLabel (ShinobiChart chart, SChartDataPointLabel label, SChartDataPoint dataPoint, SChartSeries series)
		{
			// Do some additional label styling
			label.Layer.CornerRadius = 10;
			label.BackgroundColor = UIColor.FromWhiteAlpha (0.8f, 1f);
			label.Frame = new CGRect (label.Frame.X -10, label.Frame.Y, label.Frame.Width + 20, label.Frame.Height);
			label.TextAlignment = UITextAlignment.Center;
		}
	}
}

