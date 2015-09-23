//
// BubbleSeriesDataSource.cs
//
// Copyright 2013 Scott Logic Ltd. All rights reserved.
//
using System;
using System.IO;
using System.Json;
using System.Collections.Generic;
using Foundation;

using ShinobiCharts;

namespace BubbleSeries
{
	public class BubbleSeriesDataSource : SChartDataSource
	{
		List<SChartBubbleDataPoint> _data = new List<SChartBubbleDataPoint> ();

		public BubbleSeriesDataSource()
			: base()
		{
			JsonValue data = JsonObject.Load(new StreamReader("./punchcard.json"));
			foreach (JsonValue jsonPoint in data) {
				NSNumber commits = NSNumber.FromDouble((double)jsonPoint ["commits"]);
				if (commits.NIntValue > 0) {
					_data.Add (new SChartBubbleDataPoint {
						XValue = NSNumber.FromDouble((double)jsonPoint["hour"]),
						YValue = new NSString(jsonPoint["day"]),
						Area = commits.DoubleValue
					});
				}
			};
		}

		#region implemented abstract members of SChartDataSource

		public override nint GetNumberOfSeries (ShinobiChart chart)
		{
			return 1;
		}

		public override SChartSeries GetSeries (ShinobiChart chart, nint dataSeriesIndex)
		{
			return new SChartBubbleSeries {
				AutoScalingBiggestBubbleDiameter = 40
			};
		}

		public override nint GetNumberOfDataPoints (ShinobiChart chart, nint dataSeriesIndex)
		{
			return _data.Count;
		}

		public override SChartData GetDataPoint (ShinobiChart chart, nint dataIndex, nint dataSeriesIndex)
		{
			return _data [(int)dataIndex];
		}

		#endregion

	}
}

