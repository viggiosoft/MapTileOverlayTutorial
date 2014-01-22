//
//  WatermarkTileOverlayRenderer.m
//  CustomMap
//
//  Created by Carlo Vigiani on 22/Jan/14.
//  Copyright (c) 2014 viggiosoft. All rights reserved.
//

#import "WatermarkTileOverlayRenderer.h"

@implementation WatermarkTileOverlayRenderer

-(void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context {
    
    [super drawMapRect:mapRect zoomScale:zoomScale inContext:context];
    
    CGRect rect = [self rectForMapRect:mapRect];
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:arc4random()%255/255. green:arc4random()%255/255. blue:arc4random()%255/255. alpha:0.2].CGColor);
    CGContextFillRect(context, rect);
    
    
    
    
}

@end
