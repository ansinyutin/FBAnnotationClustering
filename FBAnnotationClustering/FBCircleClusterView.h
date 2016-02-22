//
//  FBCircleClusterView.h
//  AnnotationClustering
//
//  Created by Andrey Sinyutin on 20.02.16.
//  Copyright © 2016 Infinum Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBCircleClusterView : UIView

@property (nonatomic, copy) NSString * text;
@property (nonatomic, strong) UIFont * font;
@property (nonatomic, strong) UIColor * textColor;
@property (nonatomic, strong) UIColor * bgColor;
@property (nonatomic, strong) UIColor * strokeColor;

+(UIImage*) clusterImageForText:(NSString*)text;
+(UIImage*) clusterImageForText:(NSString*)text withFont:(UIFont*) font;

@end
