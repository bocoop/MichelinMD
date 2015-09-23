//
// GettingStartedDataSource.cs
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
	public class GettingStartedDataSource : SChartDataSource
	{
		public override nint GetNumberOfSeries (ShinobiChart chart)
		{
			return 2;
		}

		public override SChartSeries GetSeries (ShinobiChart chart, nint dataSeriesIndex)
		{
			SChartLineSeries series = new SChartLineSeries ();
			series.Style.ShowFill = true;

			// The first series is a cosine curve, the second is a sine curve
			series.Title = dataSeriesIndex == 0 ? "y = cos(x)" : "y = sin(x)";

			return series;
		}

		public override nint GetNumberOfDataPoints (ShinobiChart chart, nint dataSeriesIndex)
		{
			return 100;
		}

		public override SChartData GetDataPoint (ShinobiChart chart, nint dataIndex, nint dataSeriesIndex)
		{
			SChartDataPoint datapoint = new SChartDataPoint ();

			// both functions share the same x-values
			double xValue = dataIndex / 10.0;
			datapoint.XValue = new NSNumber(xValue);

			// compute the y-value for each series
			datapoint.YValue = new NSNumber(dataSeriesIndex == 0 ? Math.Cos(xValue) : Math.Sin(xValue));

			return datapoint;
		}
	}
}

