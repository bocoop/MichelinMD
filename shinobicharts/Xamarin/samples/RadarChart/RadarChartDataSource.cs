//
// RadarChartDataSource.cs
//
// Copyright 2013 Scott Logic Ltd. All rights reserved.
//
﻿using System;
using System.Collections.Generic;
using System.Linq;
using ShinobiCharts;
using Foundation;

namespace RadarChart
{
	public class RadarChartDataSource : SChartDataSource
	{
		Dictionary<string, nint> playerRatings;

		public RadarChartDataSource ()
		{
			playerRatings = new Dictionary<string, nint> {
				{ "Speed", 92 },
				{ "Power", 68 },
				{ "Agility", 74 },
				{ "Vision", 80 },
				{ "Style", 65 },
			};
		}

		public override nint GetNumberOfSeries (ShinobiChart chart)
		{
			return 1;
		}

		public override SChartSeries GetSeries (ShinobiChart chart, nint dataSeriesIndex)
		{
			SChartRadialLineSeries radialLineSeries = new SChartRadialLineSeries ();

			// Fill the series
			radialLineSeries.Style.ShowFill = true;

			// Join up the first and last points
			radialLineSeries.PointsWrapAround = true;

			return radialLineSeries;
		}

		public override nint GetNumberOfDataPoints (ShinobiChart chart, nint dataSeriesIndex)
		{
			return playerRatings.Count;
		}

		public override SChartData GetDataPoint (ShinobiChart chart, nint dataIndex, nint dataSeriesIndex)
		{
			string key = playerRatings.Keys.ElementAt ((int)dataIndex);
			return new SChartDataPoint {
				XValue = (NSString)key,
				YValue = NSNumber.FromNInt(playerRatings[key]),
			};
		}
	}
}

