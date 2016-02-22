//
//  FBMarker.h
//  AnnotationClustering
//
//  Created by Andrey Sinyutin on 20.02.16.
//  Copyright © 2016 Infinum Ltd. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import "FBAnnotation.h"

@interface FBMarker : GMSMarker

@property (nonatomic, readwrite, weak) id<FBAnnotation>  annotation;

@end
