//
//  OfflineTileOverlayRenderer.m
//  CustomMap
//
//  Created by Carlo Vigiani on 19/Jan/14.
//  Copyright (c) 2014 viggiosoft. All rights reserved.
//

#import "GridTileOverlayRenderer.h"

@interface GridTileOverlayRenderer ()

@end

@implementation GridTileOverlayRenderer


-(void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context {
    NSLog(@"Rendering at (x,y):(%f,%f) with size (w,h):(%f,%f) zoom %f",mapRect.origin.x,mapRect.origin.y,mapRect.size.width,mapRect.size.height,zoomScale);
    CGRect rect = [self rectForMapRect:mapRect];
    NSLog(@"CGRect: %@",NSStringFromCGRect(rect));
    
    MKTileOverlayPath path;
    MKTileOverlay *tileOverlay = (MKTileOverlay *)self.overlay;
    path.x = mapRect.origin.x*zoomScale/tileOverlay.tileSize.width;
    path.y = mapRect.origin.y*zoomScale/tileOverlay.tileSize.width;
    path.z = log2(zoomScale)+20;
    
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextSetLineWidth(context, 1.0/zoomScale);
    CGContextStrokeRect(context, rect);
    
    UIGraphicsPushContext(context);
    NSString *text = [NSString stringWithFormat:@"X=%d\nY=%d\nZ=%d",path.x,path.y,path.z];
    [text drawInRect:rect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0/zoomScale],
                                           NSForegroundColorAttributeName:[UIColor blackColor]}];
    UIGraphicsPopContext();
    
}

@end
