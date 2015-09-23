//
// ColumnChartDataSource.cs
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
	class ColumnChartDataSource : SChartDataSource
	{
		public string DisplayYear {
			get;
			set;
		}

		List<Tuple<string, List<Tuple<string, double>>>> sales;

		public ColumnChartDataSource (List<Tuple<string, List<Tuple<string, double>>>> sales, string year)
		{
			this.sales = sales;
			DisplayYear = year;
		}

		#region implemented abstract members of SChartDataSource

		public override nint GetNumberOfSeries (ShinobiChart chart)
		{
			return sales.Count;
		}

		public override SChartSeries GetSeries (ShinobiChart chart, nint dataSeriesIndex)
		{
			string year = sales [(int)dataSeriesIndex].Item1;
			SChartColumnSeries columnSeries = new SChartColumnSeries {
				Title = year,
				SelectionMode = SChartSelection.Series
			};
			columnSeries.Style.ShowAreaWithGradient = false;
			columnSeries.SelectedStyle.ShowAreaWithGradient = false;
			columnSeries.SelectedStyle.AreaColor = UIColor.Red;
			columnSeries.SelectedStyle.LineWidth = 0;

			// Set the selected state of the line series - this reflects the initial UI state
			columnSeries.Selected = year == DisplayYear;
			return columnSeries;
		}

		public override nint GetNumberOfDataPoints (ShinobiChart chart, nint dataSeriesIndex)
		{
			return sales [(int)dataSeriesIndex].Item2.Count;
		}

		public override SChartData GetDataPoint (ShinobiChart chart, nint dataIndex, nint dataSeriesIndex)
		{
			var data = sales [(int)dataSeriesIndex].Item2 [(int)dataIndex];
			return new SChartDataPoint {
				XValue = new NSString(data.Item1),
				YValue = new NSNumber(data.Item2)
			};
		}

		#endregion
	}
}

