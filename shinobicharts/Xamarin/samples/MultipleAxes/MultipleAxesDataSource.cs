//
// MultipleAxesDataSource.cs
//
// Copyright 2013 Scott Logic Ltd. All rights reserved.
//
using System;
using System.IO;
using System.Json;
using System.Collections.Generic;
using Foundation;

using ShinobiCharts;

namespace MultipleAxes
{
	public class MultipleAxesDataSource : SChartDataSource
	{

		List<SChartDataPoint> _timeSeries = new List<SChartDataPoint>();
		List<SChartDataPoint> _volumeSeries = new List<SChartDataPoint>();

		public MultipleAxesDataSource()
			: base ()
		{
			NSDateFormatter dateFormatter = new NSDateFormatter { DateFormat = "dd-MM-yyyy" };
			JsonValue stocks = JsonObject.Load(new StreamReader("./AppleStockPrices.json"));
			foreach (JsonValue stock in stocks) {
				_timeSeries.Add (new SChartDataPoint {
					XValue = dateFormatter.Parse(stock["date"]),
					YValue = new NSNumber((double)stock["close"]),
				});
				_volumeSeries.Add (new SChartDataPoint {
					XValue = dateFormatter.Parse(stock["date"]),
					YValue = new NSNumber((double)stock["volume"] / 1000000.0),
				});
			};
		}

		#region implemented abstract members of SChartDataSource
		protected override SChartAxis GetYAxis (ShinobiChart chart, nint dataSeriesIndex)
		{
			return chart.AllYAxes [dataSeriesIndex];
		}
		public override nint GetNumberOfSeries (ShinobiChart chart)
		{
			return 2;
		}
		public override SChartSeries GetSeries (ShinobiChart chart, nint dataSeriesIndex)
		{
			return dataSeriesIndex == 1 ? (SChartSeries)new SChartColumnSeries () : (SChartSeries)new SChartLineSeries ();
		}
		public override nint GetNumberOfDataPoints (ShinobiChart chart, nint dataSeriesIndex)
		{
			return _timeSeries.Count;
		}
		public override SChartData GetDataPoint (ShinobiChart chart, nint dataIndex, nint dataSeriesIndex)
		{
			return (dataSeriesIndex == 1 ? _volumeSeries : _timeSeries) [(int)dataIndex];
		}
		#endregion
	}
}

