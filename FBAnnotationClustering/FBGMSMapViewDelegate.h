//
//  FBGMSMapViewDelegate.h
//  AnnotationClustering
//
//  Created by Andrey Sinyutin on 20.02.16.
//  Copyright © 2016 Infinum Ltd. All rights reserved.
//

@class FBGMSMapView;
@class FBAnnotation;
@class FBMarker;

@protocol FBGMSMapViewDelegate<NSObject>

- (FBMarker*)mapView:(FBGMSMapView *)mapView markerForAnnotation:(id<FBAnnotation>)annotation;

@end