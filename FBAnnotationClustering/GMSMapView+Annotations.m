//
//  GMSMapView+Annotations.m
//  AnnotationClustering
//
//  Created by Andrey Sinyutin on 19.02.16.
//  Copyright © 2016 Infinum Ltd. All rights reserved.
//

#import "GMSMapView+Annotations.h"

@implementation GMSMapView (Annotations)

- (NSArray*)annotations
{
    return [self.annotations copy];
}

- (void)addAnnotation:(GMSMarker *)annotation
{
    annotation.map = self;
    [self.annotations addObject:annotation];
}
- (void)addAnnotations:(NSArray<GMSMarker *> *)annotations
{
    for (GMSMarker * ann in annotations) {
        ann.map = self;
        [self.annotations addObject:ann];
    }
}

- (void)removeAnnotation:(GMSMarker *)annotation
{
    annotation.map = nil;
    [self.annotations removeObject:annotation];
}

- (void)removeAnnotations:(NSArray<GMSMarker *> *)annotations
{
    for (GMSMarker * ann in annotations) {
        ann.map = nil;
        [self.annotations removeObject:ann];
    }
}
@end
