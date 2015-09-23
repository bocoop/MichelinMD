//
// PolarChartDataSource.cs
//
// Copyright 2013 Scott Logic Ltd. All rights reserved.
//
﻿using System;
using ShinobiCharts;
using Foundation;

namespace PolarChart
{
	public class PolarChartDataSource : SChartDataSource
	{
		public override nint GetNumberOfSeries (ShinobiChart chart)
		{
			return 1;
		}

		public override SChartSeries GetSeries (ShinobiChart chart, nint dataSeriesIndex)
		{
			return new SChartRadialLineSeries ();
		}

		public override nint GetNumberOfDataPoints (ShinobiChart chart, nint dataSeriesIndex)
		{
			return 360;
		}

		public override SChartData GetDataPoint (ShinobiChart chart, nint dataIndex, nint dataSeriesIndex)
		{
			return new SChartDataPoint {
				XValue = NSNumber.FromNInt(dataIndex),
				YValue = NSNumber.FromNInt(dataIndex),
			};
		}
	}
}

