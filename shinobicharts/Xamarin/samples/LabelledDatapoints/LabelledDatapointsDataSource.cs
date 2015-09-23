//
// LabelledDatapointsDataSource.cs
//
// Copyright 2013 Scott Logic Ltd. All rights reserved.
//
﻿using System;
using ShinobiCharts;
using CoreGraphics;
using UIKit;
using Foundation;

namespace LabelledDatapoints
{
	public class LabelledDatapointsDataSource : SChartDataSource
	{

		nfloat[] data = new nfloat[] { 0.5f, 6.3f, 2.1f, 4.5f, 2.2f, 1f, 0f, -1f };

		public override nint GetNumberOfSeries (ShinobiChart chart)
		{
			return 1;
		}

		public override SChartSeries GetSeries (ShinobiChart chart, nint dataSeriesIndex)
		{
			SChartColumnSeries series = new SChartColumnSeries ();

			// Display labels
			series.Style.DataPointLabelStyle.ShowLabels = true;

			// Position labels
			series.Style.DataPointLabelStyle.OffsetFromDataPoint = new CGPoint (0, -15);
			series.Style.DataPointLabelStyle.OffsetFlippedForNegativeValues = true;

			// Style labels
			series.Style.DataPointLabelStyle.TextColor = UIColor.Black;
			series.Style.DataPointLabelStyle.DisplayValues = SChartDataPointLabelDisplayValues.Y;

			return series;
		}

		public override nint GetNumberOfDataPoints (ShinobiChart chart, nint dataSeriesIndex)
		{
			return data.Length;
		}

		public override SChartData GetDataPoint (ShinobiChart chart, nint dataIndex, nint dataSeriesIndex)
		{
			return new SChartDataPoint {
				XValue = new NSNumber (dataIndex),
				YValue = new NSNumber (data [dataIndex]),
			};
		}

	}
}

