//
//  FBCircleClusterView.m
//  AnnotationClustering
//
//  Created by Andrey Sinyutin on 20.02.16.
//  Copyright © 2016 Infinum Ltd. All rights reserved.
//

#import "FBCircleClusterView.h"
#import "NSString+Size.h"

@implementation FBCircleClusterView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.font = [UIFont boldSystemFontOfSize:14];
        [self initDefaults];
    }
    return self;
}


- (instancetype)initWithFont:(UIFont*)font
{
    self = [super init];
    if (self) {
        self.font = (font) ?: [UIFont boldSystemFontOfSize:14];
        [self initDefaults];
    }
    return self;
}

- (void) initDefaults
{
    self.bgColor = [UIColor redColor];
    self.textColor = [UIColor whiteColor];
    self.strokeColor = [UIColor whiteColor];
    self.backgroundColor = UIColor.clearColor;
}

+(UIImage*) clusterImageForText:(NSString*)text
{
    return [self clusterImageForText:text withFont:nil];
}

+(UIImage*) clusterImageForText:(NSString*)text withFont:(UIFont*) font
{
    
    FBCircleClusterView * view = [[FBCircleClusterView alloc] initWithFont:font];
    view.text = text;
    
    UIImage * img;
    
    [view refreshSize];
    [view setNeedsDisplay];
    
    UIGraphicsBeginImageContextWithOptions(view.layer.bounds.size, false, 0.0);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

- (void)refreshSize;
{
    CGSize size = [self clusterSize];
    self.bounds = CGRectMake(0, 0, size.width, size.height);
}

- (CGSize)clusterSize
{
    CGSize textSize = self.text ? [self.text sizeUsingFont:self.font] : CGSizeMake(20, 20);
    
    CGFloat circlePadding = textSize.height;
    
    CGSize frameSize = CGSizeMake(textSize.width + circlePadding, textSize.width + circlePadding);
    
    return frameSize;
}

-(void)drawRect:(CGRect)rect
{
    CGSize textSize = self.text ? [self.text sizeUsingFont:self.font] : CGSizeMake(20, 20);
    
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* bgColor = self.bgColor;
    UIColor* textColor = self.textColor;
    UIColor* strokeColor = self.strokeColor;
    
    
    CGFloat circlePadding = textSize.height;
    
    //// Variable Declarations
    CGSize frameSize = CGSizeMake(textSize.width + circlePadding, textSize.width + circlePadding);
    CGFloat strokeWidth = (int)(frameSize.width / 10);
    CGSize circleSize = CGSizeMake(frameSize.width - strokeWidth, frameSize.height - strokeWidth);
    CGFloat textTopOffset = (circleSize.height - textSize.height) / 2.0;
    CGFloat textLeftOffset = (circleSize.width - textSize.width) / 2.0;
    CGFloat circleMargin = strokeWidth / 2.0;
    
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(circleMargin, circleMargin, circleSize.width, circleSize.height)];
    [bgColor setFill];
    [ovalPath fill];
    [strokeColor setStroke];
    ovalPath.lineWidth = strokeWidth;
    [ovalPath stroke];
    
    
    //// Text Drawing
    CGRect textRect = CGRectMake(0  , textTopOffset, frameSize.width, textSize.height);
    UIBezierPath* textPath = [UIBezierPath bezierPathWithRect: textRect];
//    [UIColor.lightGrayColor setStroke];
//    textPath.lineWidth = 0.5f;
//    [textPath stroke];
    {
        NSString* textContent = self.text;
        NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        textStyle.alignment = NSTextAlignmentCenter;
        
        NSDictionary* textFontAttributes = @{NSFontAttributeName: self.font, NSForegroundColorAttributeName: textColor, NSParagraphStyleAttributeName: textStyle};
        
        CGFloat textTextHeight = [textContent boundingRectWithSize: CGSizeMake(textRect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: textFontAttributes context: nil].size.height;
        CGContextSaveGState(context);
        CGContextClipToRect(context, textRect);
        [textContent drawInRect: CGRectMake(CGRectGetMinX(textRect), CGRectGetMinY(textRect) + (CGRectGetHeight(textRect) - textTextHeight) / 2, CGRectGetWidth(textRect), textTextHeight) withAttributes: textFontAttributes];
        CGContextRestoreGState(context);
    }
}


@end
