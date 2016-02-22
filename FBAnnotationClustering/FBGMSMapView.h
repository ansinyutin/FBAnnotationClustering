//
//  FBGMSMapView.h
//  AnnotationClustering
//
//  Created by Andrey Sinyutin on 19.02.16.
//  Copyright © 2016 Infinum Ltd. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import "FBAnnotation.h"
#import "FBGMSMapViewDelegate.h"
#import "FBMarker.h"
#import <MapKit/MapKit.h>


@interface FBGMSMapView : GMSMapView

@property (nonatomic, weak) id<FBGMSMapViewDelegate> markerDelegate;

@property (nonatomic, readonly, getter=annotations) NSArray<id<FBAnnotation>> *annotations;


- (void)addAnnotation:(id<FBAnnotation> )annotation;
- (void)addAnnotations:(NSArray<id<FBAnnotation>> *)annotations;

- (void)removeAnnotation:(id<FBAnnotation> )annotation;
- (void)removeAnnotations:(NSArray<id<FBAnnotation>> *)annotations;

- (MKMapRect)MKMapRectForCoordinateRegion:(MKCoordinateRegion)region;
- (MKMapRect)MKMapRect;

@end

