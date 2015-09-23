//
// AddingAnnotationsDelegate.cs
//
// Copyright 2013 Scott Logic Ltd. All rights reserved.
//
using System;
using CoreGraphics;
using Foundation;
using UIKit;
using ShinobiCharts;
using System.Json;
using System.IO;

namespace AddingAnnotations
{
	public class AddingAnnotationsDelegate : SChartDelegate
	{
		bool firstChartRender = false;
		NSDateFormatter dateFormatter = new NSDateFormatter { DateFormat = "dd-MM-yyyy" };

		protected override void OnRenderFinished (ShinobiChart chart)
		{
			if (!firstChartRender) {
				firstChartRender = true;

				AddDateMarkerAnnoations (chart);
				AddCustomAnnotation (chart);
			}
		}

		void AddDateMarkerAnnoations (ShinobiChart chart)
		{
			// Read the annotations from a JSON file
			JsonValue annotations = JsonObject.Load(new StreamReader("./Annotations.json"));
			CGAffineTransform rotationTransform = CGAffineTransform.MakeRotation ((nfloat)Math.PI / 2);

			// create a line and text annotation for each 'date' marker on the chart
			foreach (JsonValue annotation in annotations) {
				// Extract the data for this annotation
				NSDate date = dateFormatter.Parse (annotation ["date"]);
				double yLocation = (double)annotation ["y-location"];
				NSNumber yValue = NSNumber.FromNInt ((nint)yLocation);
				NSString text = new NSString(annotation ["annotation"]);

				// Add a vertical line annotation
				SChartAnnotation releaseAnnotation = SChartAnnotation.GetVerticalLine (date, chart.XAxis, chart.YAxis, 2, UIColor.FromWhiteAlpha (0.7f, 1));
				releaseAnnotation.Position = SChartAnnotationPosition.AboveData;
				chart.AddAnnotation (releaseAnnotation);

				// Add a text annotation
				SChartAnnotation releaseLabel = SChartAnnotation.GetAnnotation (text, UIFont.SystemFontOfSize(14), chart.XAxis, chart.YAxis, date, yValue, UIColor.Black, chart.PlotBackgroundColor);

				//Rotate the text by 90 degrees
				releaseLabel.Transform = rotationTransform;
				releaseLabel.Position = SChartAnnotationPosition.AboveData;

				chart.AddAnnotation (releaseLabel);
			}
		}

		void AddCustomAnnotation (ShinobiChart chart)
		{
			// Create an annotation
			SChartAnnotationZooming an = new SChartAnnotationZooming {
				XAxis = chart.XAxis,
				YAxis = chart.YAxis,

				// Set its location - using the data coordinate system
				XValue = dateFormatter.Parse ("01-01-2009"),
				YValue = new NSNumber(250),

				// Pin all four corners of the annotation so that it stretches
				XValueMax = dateFormatter.Parse ("01-01-2011"),
				YValueMax = new NSNumber(550),

				// Set bounds
				Bounds = new CGRect (0, 0, 50, 50),
				Position = SChartAnnotationPosition.BelowData
			};

			// Add some custom content to the annotation
			UIImage image = new UIImage ("Apple.png");
			UIImageView imageView = new UIImageView (image) { Alpha = 0.1f };
			an.AddSubview (imageView);

			// Add to the chart
			chart.AddAnnotation (an);
		}
	}
}

