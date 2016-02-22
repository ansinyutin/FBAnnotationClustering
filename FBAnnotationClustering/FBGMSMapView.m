//
//  FBGMSMapView.m
//  AnnotationClustering
//
//  Created by Andrey Sinyutin on 19.02.16.
//  Copyright © 2016 Infinum Ltd. All rights reserved.
//

#import "FBGMSMapView.h"
#import <GoogleMaps/GoogleMaps.h>
#import "FBGMSMapViewDelegate.h"
#import "FBMarker.h"

@interface FBGMSMapView()

@property (nonatomic, readwrite) NSMutableArray<id<FBAnnotation>> *anns;

@property (nonatomic, readwrite) NSMutableDictionary<NSNumber*, FBMarker *> *markersMap;

@end

@implementation FBGMSMapView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.anns = [[NSMutableArray alloc] initWithCapacity:0];
        self.markersMap = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return self;
}

- (NSArray*)annotations
{
    return [self.anns copy];
}

- (void)addAnnotation:(id<FBAnnotation>)annotation
{
    NSNumber * hash = [NSNumber numberWithInteger:annotation.hash];
    FBMarker * marker;
    
    if (self.markerDelegate) {
        marker = [self.markerDelegate mapView:self markerForAnnotation:annotation];
    } else {
        marker = [FBMarker markerWithPosition:annotation.position];
    }
    marker.map = self;
    marker.annotation = annotation;
    
    [_markersMap setObject:marker forKey:hash];
    [_anns addObject:annotation];
    
}
- (void)addAnnotations:(NSArray<id<FBAnnotation>> *)annotations
{
    for (id<FBAnnotation> ann in annotations) {
        [self addAnnotation:ann];
    }
}

- (void)removeAnnotation:(id<FBAnnotation>)annotation
{
    NSNumber * hash   = [NSNumber numberWithInteger:annotation.hash];
    FBMarker * marker = [_markersMap objectForKey:hash];
    
    if ( marker ) {
        marker.map        = nil;
        marker.annotation = nil;
    }
    
    [_markersMap removeObjectForKey:hash];
    [_anns removeObject:annotation];
}

- (void)removeAnnotations:(NSArray<id<FBAnnotation>> *)annotations
{
    for (id<FBAnnotation> ann in annotations) {
        [self removeAnnotation:ann];
    }
}


- (MKMapRect)MKMapRectForCoordinateRegion:(MKCoordinateRegion)region
{
    MKMapPoint a = MKMapPointForCoordinate(CLLocationCoordinate2DMake(
                                                                      region.center.latitude + region.span.latitudeDelta / 2,
                                                                      region.center.longitude - region.span.longitudeDelta / 2));
    MKMapPoint b = MKMapPointForCoordinate(CLLocationCoordinate2DMake(
                                                                      region.center.latitude - region.span.latitudeDelta / 2,
                                                                      region.center.longitude + region.span.longitudeDelta / 2));
    return MKMapRectMake(MIN(a.x,b.x), MIN(a.y,b.y), ABS(a.x-b.x), ABS(a.y-b.y));
}

- (MKMapRect)MKMapRect
{
    GMSCameraPosition * position = self.camera;
    //    CLLocationCoordinate2D tl = self.mapView.projection.visibleRegion.farLeft;
    CLLocationCoordinate2D tr = self.projection.visibleRegion.farRight;
    
    CLLocationCoordinate2D bl = self.projection.visibleRegion.nearLeft;
    //    CLLocationCoordinate2D br = self.mapView.projection.visibleRegion.nearRight;
    
    
    //    CGPoint tlPoint = [self.mapView.projection pointForCoordinate:self.mapView.projection.visibleRegion.farLeft];
    //    CGPoint trPoint = [self.mapView.projection pointForCoordinate:self.mapView.projection.visibleRegion.farRight];
    //
    //    CGPoint blPoint = [self.mapView.projection pointForCoordinate:self.mapView.projection.visibleRegion.nearLeft];
    //    CGPoint brPoint = [self.mapView.projection pointForCoordinate:self.mapView.projection.visibleRegion.nearRight];
    
    //    NSLog(@"\n|⁻ lat %f lon %f   lat %f lon %f ⁻|\n|_ lat %f lon %f   lat %f lon %f _|\n",
    //
    //          self.mapView.projection.visibleRegion.farLeft.latitude,
    //          self.mapView.projection.visibleRegion.farLeft.longitude,
    //
    //          self.mapView.projection.visibleRegion.farRight.latitude,
    //          self.mapView.projection.visibleRegion.farRight.longitude,
    //
    //          self.mapView.projection.visibleRegion.nearLeft.latitude,
    //          self.mapView.projection.visibleRegion.nearLeft.longitude,
    //
    //          self.mapView.projection.visibleRegion.nearRight.latitude,
    //          self.mapView.projection.visibleRegion.nearRight.longitude);
    //
    //
    //    NSLog(@"\n|⁻ %f,%f   %f,%f ⁻|\n|_ %f,%f   %f,%f _|\n",
    //          tlPoint.x,
    //          tlPoint.y,
    //
    //          trPoint.x,
    //          trPoint.y,
    //
    //          blPoint.x,
    //          blPoint.y,
    //
    //          brPoint.x,
    //          brPoint.y);
    
    CLLocationDegrees latDelta = fabs( tr.latitude - bl.latitude );
    CLLocationDegrees lonDelta = fabs( tr.longitude - bl.longitude );
    
    //    NSLog(@"DELTA\n ↑ %f   -> %f", latDelta, lonDelta);
    
    MKCoordinateRegion region = MKCoordinateRegionMake(position.target, MKCoordinateSpanMake(latDelta, lonDelta));
    
    MKMapRect rect = [self MKMapRectForCoordinateRegion:region];
    
    return rect;
    
}


-(NSString*) description
{
    return [NSString stringWithFormat:@"\n\nFBGMSMapView\nAnnotations:\%@\nMap\n%@",
            _anns, _markersMap];
}

@end
