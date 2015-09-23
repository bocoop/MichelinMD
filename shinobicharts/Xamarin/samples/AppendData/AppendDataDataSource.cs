//
// AppendDataDataSource.cs
//
// Copyright 2013 Scott Logic Ltd. All rights reserved.
//
using System;
using CoreGraphics;
using Foundation;
using UIKit;
using ShinobiCharts;
using System.Collections.Generic;
using System.Timers;

namespace AppendData
{
	class AppendDataDataSource : SChartDataSource
	{
		// A variable to hold the data for the chart
		List<SChartDataPoint> _streamedData;

		/// <summary>
		/// Initializes a new instance of the DataSource.
		/// </summary>
		public AppendDataDataSource()
			: base ()
		{
			_streamedData = new List<SChartDataPoint>();
			for(nint i = 0; i < 360; i++) {
				_streamedData.Add(CreateDataPoint(i));
			}
		}

		/// <summary>
		/// Creates a new data point based on the index given
		/// </summary>
		/// <returns>The new data point.</returns>
		/// <param name="index">The X value to create the data point with.</param>
		private SChartDataPoint CreateDataPoint(nint index)
		{
			return new SChartDataPoint() {
				XValue = new NSNumber(index),
				YValue = new NSNumber(Math.Sin(index * Math.PI / 180.0))
			};
		}

		/// <summary>
		/// Advances the data by one.
		/// This removes the first value, and adds a new value onto the end
		/// </summary>
		public void AdvanceData()
		{
			_streamedData.RemoveAt (0);
			nint lastX = ((NSNumber)_streamedData [_streamedData.Count - 1].XValue).Int32Value;
			_streamedData.Add (CreateDataPoint(lastX + 1));
		}

		#region SChartDataSource methods

		public override nint GetNumberOfSeries (ShinobiChart chart)
		{
			return 1;
		}

		public override SChartSeries GetSeries (ShinobiChart chart, nint dataSeriesIndex)
		{
			// In our example all series are line series
			SChartLineSeries lineSeries = new SChartLineSeries ();
			lineSeries.Style.LineWidth = 2;
			return lineSeries;
		}

		public override nint GetNumberOfDataPoints (ShinobiChart chart, nint dataSeriesIndex)
		{
			return _streamedData.Count;
		}

		public override SChartData GetDataPoint (ShinobiChart chart, nint dataIndex, nint dataSeriesIndex)
		{
			return _streamedData [(int)dataIndex];
		}

		#endregion

	}
}

