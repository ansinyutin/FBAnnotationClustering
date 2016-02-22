//
//  FBAnnotation.h
//  AnnotationClustering
//
//  Created by Andrey Sinyutin on 20.02.16.
//  Copyright © 2016 Infinum Ltd. All rights reserved.
//

@protocol FBAnnotation <NSObject>

@property (nonatomic, readonly) CLLocationCoordinate2D position;

//@property (nonatomic, readonly) NSString * hash;

@end
