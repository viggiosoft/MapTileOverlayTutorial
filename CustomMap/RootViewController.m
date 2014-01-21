//
//  RootViewController.m
//  CustomMap
//
//  Created by Carlo Vigiani on 19/Jan/14.
//  Copyright (c) 2014 viggiosoft. All rights reserved.
//

#import "RootViewController.h"
#import "GridTileOverlay.h"
#if ( OFFLINE_USE_CUSTOM_OVERLAY_RENDERER == 1)
#import "GridTileOverlayRenderer.h"
#endif

typedef NS_ENUM(NSInteger, CustomMapTileOverlayType) {
    CustomMapTileOverlayTypeApple = 0,
    CustomMapTileOverlayTypeOpenStreet = 1,
    CustomMapTileOverlayTypeGoogle = 2,
    CustomMapTileOverlayTypeOffline = 3
};

@import MapKit;

@interface RootViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *overlaySelector;
@property (strong, nonatomic) MKTileOverlay *tileOverlay;
@property (strong, nonatomic) MKTileOverlay *gridOverlay;

@property (assign, nonatomic) CustomMapTileOverlayType overlayType;

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.overlayType = CustomMapTileOverlayTypeApple;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // load grid tile overlay
    self.gridOverlay = [[GridTileOverlay alloc] init];
    self.gridOverlay.canReplaceMapContent=NO;
    [self.mapView addOverlay:self.gridOverlay level:MKOverlayLevelAboveLabels];
    
    // Do any additional setup after loading the view from its nib.
    self.overlaySelector.selectedSegmentIndex = self.overlayType;
    [self reloadTileOverlay];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

- (IBAction)overlaySelectorChanged:(id)sender {
    self.overlayType=self.overlaySelector.selectedSegmentIndex;
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
        NSString *urlTemplate = [baseURL stringByAppendingString:@"/tiles/{z}/{x}/{y}.png"];
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

@end
