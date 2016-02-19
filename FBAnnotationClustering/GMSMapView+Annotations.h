//
//  GMSMapView+Annotations.h
//  AnnotationClustering
//
//  Created by Andrey Sinyutin on 19.02.16.
//  Copyright © 2016 Infinum Ltd. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>


@protocol GMSMarker <NSObject>

// Center latitude and longitude of the annotation view.
// The implementation of this property must be KVO compliant.
@property (nonatomic, readonly) CLLocationCoordinate2D position;

@end


@interface GMSMapView (Annotations)

@property (nonatomic, readonly, getter=annotations) NSMutableArray<GMSMarker *> *annotations;

- (void)addAnnotation:(GMSMarker *)annotation;
- (void)addAnnotations:(NSArray<GMSMarker *> *)annotations;

- (void)removeAnnotation:(GMSMarker *)annotation;
- (void)removeAnnotations:(NSArray<GMSMarker *> *)annotations;

@end
