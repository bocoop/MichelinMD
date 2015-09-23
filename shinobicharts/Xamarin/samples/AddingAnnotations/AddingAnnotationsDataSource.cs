//
// AddingAnnotationsDataSource.cs
//
// Copyright 2013 Scott Logic Ltd. All rights reserved.
//
using System;
using CoreGraphics;
using Foundation;
using UIKit;
using ShinobiCharts;
using System.Collections.Generic;
using System.IO;
using System.Json;

namespace AddingAnnotations
{
	public class AddingAnnotationsDataSource : SChartDataSource
	{
		List<SChartDataPoint> timeSeries = new List<SChartDataPoint>();

		public AddingAnnotationsDataSource()
		{
			NSDateFormatter dateFormatter = new NSDateFormatter { DateFormat = "dd-MM-yyyy" };
			JsonValue stocks = JsonObject.Load(new StreamReader("./AppleStockPrices.json"));
			foreach (JsonValue stock in stocks) {
				timeSeries.Add (new SChartDataPoint {
					XValue = dateFormatter.Parse(stock["date"]),
					YValue = new NSNumber((double)stock["close"]),
				});
			};
		}

		public override nint GetNumberOfSeries (ShinobiChart chart)
		{
			return 1;
		}

		public override SChartSeries GetSeries (ShinobiChart chart, nint dataSeriesIndex)
		{
			SChartLineSeries series = new SChartLineSeries ();
			return series;
		}

		public override nint GetNumberOfDataPoints (ShinobiChart chart, nint dataSeriesIndex)
		{
			return timeSeries.Count;
		}

		public override SChartData GetDataPoint (ShinobiChart chart, nint dataIndex, nint dataSeriesIndex)
		{
			return timeSeries [(int)dataIndex];
		}
	}
}

