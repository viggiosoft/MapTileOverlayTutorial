//
//  OfflineTileOverlay.m
//  CustomMap
//
//  Created by Carlo Vigiani on 19/Jan/14.
//  Copyright (c) 2014 viggiosoft. All rights reserved.
//

#import "GridTileOverlay.h"

@interface GridTileOverlay ()

@end

@implementation GridTileOverlay


-(void)loadTileAtPath:(MKTileOverlayPath)path result:(void (^)(NSData *, NSError *))result {
    //NSLog(@"Loading tile x/y/z: %ld/%ld/%ld",(long)path.x,(long)path.y,(long)path.z);
    
    CGSize sz = self.tileSize;
    CGRect rect = CGRectMake(0, 0, sz.width, sz.height);

#if ( OFFLINE_USE_CUSTOM_OVERLAY_RENDERER == 0 )

#if TARGET_OS_IPHONE
    UIGraphicsBeginImageContext(sz);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] setStroke];
    CGContextSetLineWidth(ctx, 1.0);
    CGContextStrokeRect(ctx, CGRectMake(0, 0, sz.width, sz.height));
    NSString *text = [NSString stringWithFormat:@"X=%d\nY=%d\nZ=%d",path.x,path.y,path.z];
    [text drawInRect:rect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0],
                                           NSForegroundColorAttributeName:[UIColor blackColor]}];
    UIImage *tileImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *tileData = UIImagePNGRepresentation(tileImage);
    result(tileData,nil);
#else
    
    NSBitmapImageRep *tileImageRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL pixelsWide:sz.width pixelsHigh:sz.height bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO colorSpaceName:NSDeviceRGBColorSpace bitmapFormat:NSAlphaFirstBitmapFormat bytesPerRow:0 bitsPerPixel:0];
    NSGraphicsContext *graphicsContext = [NSGraphicsContext graphicsContextWithBitmapImageRep:tileImageRep];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:graphicsContext];
    CGContextRef ctx = (CGContextRef)graphicsContext.graphicsPort;
    CGContextSetLineWidth(ctx, 1.0);
    CGContextStrokeRect(ctx, CGRectMake(0, 0, sz.width, sz.height));
    NSString *text = [NSString stringWithFormat:@"X=%ld\nY=%ld\nZ=%ld",(long)path.x,(long)path.y,(long)path.z];
    [text drawInRect:rect withAttributes:@{NSFontAttributeName:[NSFont systemFontOfSize:20.0],
                                           NSForegroundColorAttributeName:[NSColor blackColor]}];
    [NSGraphicsContext restoreGraphicsState];
    NSData *tileData = [tileImageRep TIFFRepresentation];
    result(tileData,nil);
    
#endif
#else
    
    result([[NSData alloc] init],nil);
#endif
    
}


@end
