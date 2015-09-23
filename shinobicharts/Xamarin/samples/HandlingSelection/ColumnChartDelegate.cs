//
// ColumnChartDelegate.cs
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
	class ColumnChartDelegate : SChartDelegate
	{
		public delegate void ToggledSelectionEventHandler (ShinobiChart chart, SChartSeries series, SChartDataPoint dataPoint, CGPoint pixelPoint);

		public event ToggledSelectionEventHandler ToggledSelection;

		protected override void OnToggledSelection (ShinobiChart chart, SChartSeries series, SChartDataPoint dataPoint, CGPoint pixelPoint)
		{
			if (ToggledSelection != null) {
				ToggledSelection (chart, series, dataPoint, pixelPoint);
			}
		}
	}
}

