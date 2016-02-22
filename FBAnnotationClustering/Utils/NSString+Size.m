//
//  NSString+Size.m
//  AnnotationClustering
//
//  Created by Andrey Sinyutin on 20.02.16.
//  Copyright © 2016 Infinum Ltd. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGSize)sizeUsingFont:(UIFont *)font
{
    NSDictionary *attributes = @{ NSFontAttributeName : font };
    CGRect rect = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    return rect.size;
}
@end
