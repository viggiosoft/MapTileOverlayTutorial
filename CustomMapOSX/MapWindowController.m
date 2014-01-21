//
//  MapWindowController.m
//  CustomMap
//
//  Created by Carlo Vigiani on 21/Jan/14.
//  Copyright (c) 2014 viggiosoft. All rights reserved.
//

#import "MapWindowController.h"
#import "GridTileOverlay.h"

typedef NS_ENUM(NSInteger, CustomMapTileOverlayType) {
    CustomMapTileOverlayTypeApple = 0,
    CustomMapTileOverlayTypeOpenStreet = 1,
    CustomMapTileOverlayTypeGoogle = 2,
    CustomMapTileOverlayTypeOffline = 3
};

@import MapKit;

@interface MapWindowController () <MKMapViewDelegate,NSWindowDelegate>

@property (weak) IBOutlet MKMapView *mapView;
@property (weak) IBOutlet NSSegmentedControl *overlaySelector;
@property (strong, nonatomic) MKTileOverlay *tileOverlay;
@property (strong, nonatomic) MKTileOverlay *gridOverlay;
@property (assign, nonatomic) CustomMapTileOverlayType overlayType;

- (IBAction)overlaySelectorChanged:(id)sender;

@end

@implementation MapWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    self.overlayType = CustomMapTileOverlayTypeApple;
    
    // load grid tile overlay
    self.gridOverlay = [[GridTileOverlay alloc] init];
    self.gridOverlay.canReplaceMapContent=NO;
    [self.mapView addOverlay:self.gridOverlay level:MKOverlayLevelAboveLabels];
    
    // Do any additional setup after loading the view from its nib.
    self.overlaySelector.selectedSegment = self.overlayType;
    [self reloadTileOverlay];
    
}

#pragma mark - IBAction

- (IBAction)overlaySelectorChanged:(id)sender {
    self.overlayType=self.overlaySelector.selectedSegment;
    [self reloadTileOverlay];
}

#pragma mark - TileOverlay

-(void)reloadTileOverlay {
    
    // remove existing map tile overlay
    if(self.tileOverlay) {
        [self.mapView removeOverlay:self.tileOverlay];
    }
    
    // define overlay
    if(self.overlayType==CustomMapTileOverlayTypeApple) {
        // do nothing
        self.tileOverlay = nil;
        
    } else if(self.overlayType==CustomMapTileOverlayTypeOpenStreet || self.overlayType==CustomMapTileOverlayTypeGoogle) {
        // use online overlay
        NSString *urlTemplate = nil;
        if(self.overlayType==CustomMapTileOverlayTypeOpenStreet) {
            urlTemplate = @"http://c.tile.openstreetmap.org/{z}/{x}/{y}.png";
        } else {
            urlTemplate = @"http://mt0.google.com/vt/x={x}&y={y}&z={z}";
        }
        self.tileOverlay = [[MKTileOverlay alloc] initWithURLTemplate:urlTemplate];
        self.tileOverlay.canReplaceMapContent=YES;
        [self.mapView insertOverlay:self.tileOverlay belowOverlay:self.gridOverlay];
    }
    else if(self.overlayType==CustomMapTileOverlayTypeOffline) {
        NSString *baseURL = [[[NSBundle mainBundle] bundleURL] absoluteString];
        NSString *urlTemplate = [baseURL stringByAppendingString:@"/Contents/Resources/tiles/{z}/{x}/{y}.png"];
        self.tileOverlay = [[MKTileOverlay alloc] initWithURLTemplate:urlTemplate];
        self.tileOverlay.canReplaceMapContent=YES;
        [self.mapView insertOverlay:self.tileOverlay belowOverlay:self.gridOverlay];
    }
    
    
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    if([overlay isKindOfClass:[MKTileOverlay class]]) {
        MKTileOverlay *tileOverlay = (MKTileOverlay *)overlay;
        MKTileOverlayRenderer *renderer = nil;
        if([tileOverlay isKindOfClass:[GridTileOverlay class]]) {
#if ( OFFLINE_USE_CUSTOM_OVERLAY_RENDERER == 1 )
            renderer = [[GridTileOverlayRenderer alloc] initWithTileOverlay:tileOverlay];
#else
            renderer = [[MKTileOverlayRenderer alloc] initWithTileOverlay:tileOverlay];
#endif
        } else {
            renderer = [[MKTileOverlayRenderer alloc] initWithTileOverlay:tileOverlay];
        }
        
        return renderer;
    }
    
    return nil;
}


#pragma mark - NSWindowDelegate

-(void)windowWillClose:(NSNotification *)notification {
    [[NSApplication sharedApplication] terminate:nil];
}

@end
