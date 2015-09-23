//
// MultipleAxesDelegate.cs
//
// Copyright 2013 Scott Logic Ltd. All rights reserved.
//
using System;
using System.Linq;

using ShinobiCharts;

namespace MultipleAxes
{
	public class MultipleAxesDelegate : SChartDelegate
	{
		protected override void OnAddingTickMark (ShinobiChart chart, SChartTickMark tickMark, SChartAxis axis)
		{
			// Hide any tickmarks over 100M on the right y-axis
			if (axis == chart.AllYAxes.Last ()) {
				if (tickMark.Value > 100.0f && tickMark.TickLabel != null && tickMark.TickMarkView != null) {
					tickMark.TickLabel.Text = "";
					tickMark.TickMarkView.Hidden = true;
				}
			}
		}
	}
}

