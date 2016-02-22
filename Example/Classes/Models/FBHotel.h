//
//  FBHotel.h
//  AnnotationClustering
//
//  Created by Andrey Sinyutin on 20.02.16.
//  Copyright © 2016 Infinum Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "FBAnnotation.h"

@interface FBHotel : NSObject <FBAnnotation>

@property (nonatomic, strong) NSNumber * uid;

@property (nonatomic) CLLocationCoordinate2D position;


@end
