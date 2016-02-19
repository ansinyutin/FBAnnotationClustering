//
//  FBViewController.m
//  AnnotationClustering
//
//  Created by Filip Bec on 06/04/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import "FBViewController.h"
#import "FBAnnotation.h"

#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>

#import <PureLayout/PureLayout.h>

#define kNUMBER_OF_LOCATIONS 1000
#define kFIRST_LOCATIONS_TO_REMOVE 50

@interface FBViewController ()<GMSMapViewDelegate>


@property (weak, nonatomic) IBOutlet UILabel *numberOfAnnotationsLabel;

@property (nonatomic, strong) GMSMapView *mapView;
@property (nonatomic, assign) NSUInteger numberOfLocations;
@property (nonatomic, strong) FBClusteringManager *clusteringManager;

@end

@implementation FBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
//    self.numberOfLocations = kNUMBER_OF_LOCATIONS;
//    [self updateLabelText];
//
    
//    // markers
    NSMutableArray *array = [self hotelLocation];
//
//    
//    // Create clustering manager
    self.clusteringManager = [[FBClusteringManager alloc] initWithAnnotations:array];
    self.clusteringManager.delegate = self;
    
//    CLLocationCoordinate2D defaultCenter = [(GMSMarker*)array[0] position];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:0
                                                            longitude:0
                                                                 zoom:0];
    self.mapView = [[GMSMapView alloc] init];
    self.mapView.delegate = self;
    [self.mapView setCamera:camera];
    self.mapView.settings.compassButton = YES;
    
    [self.view addSubview:self.mapView];
    
    [self.mapView autoPinEdgesToSuperviewEdges];
    
//    [self mapView:self.mapView regionDidChangeAnimated:NO];


//    NSMutableArray *annotationsToRemove = [[NSMutableArray alloc] init];
//    for (int i=0; i<kFIRST_LOCATIONS_TO_REMOVE; i++) {
//        [annotationsToRemove addObject:array[i]];
//    }
//    [self.clusteringManager removeAnnotations:annotationsToRemove];
}

- (MKMapRect)MKMapRectForCoordinateRegion:(MKCoordinateRegion)region
{
    MKMapPoint a = MKMapPointForCoordinate(CLLocationCoordinate2DMake(
                                                                      region.center.latitude + region.span.latitudeDelta / 2,
                                                                      region.center.longitude - region.span.longitudeDelta / 2));
    MKMapPoint b = MKMapPointForCoordinate(CLLocationCoordinate2DMake(
                                                                      region.center.latitude - region.span.latitudeDelta / 2,
                                                                      region.center.longitude + region.span.longitudeDelta / 2));
    return MKMapRectMake(MIN(a.x,b.x), MIN(a.y,b.y), ABS(a.x-b.x), ABS(a.y-b.y));
}

- (MKMapRect)getMapRect
{
    GMSCameraPosition * position = self.mapView.camera;
    CLLocationCoordinate2D tl = self.mapView.projection.visibleRegion.farLeft;
    CLLocationCoordinate2D tr = self.mapView.projection.visibleRegion.farRight;
    
    CLLocationCoordinate2D bl = self.mapView.projection.visibleRegion.nearLeft;
    CLLocationCoordinate2D br = self.mapView.projection.visibleRegion.nearRight;
    
    
    CGPoint tlPoint = [self.mapView.projection pointForCoordinate:self.mapView.projection.visibleRegion.farLeft];
    CGPoint trPoint = [self.mapView.projection pointForCoordinate:self.mapView.projection.visibleRegion.farRight];
    
    CGPoint blPoint = [self.mapView.projection pointForCoordinate:self.mapView.projection.visibleRegion.nearLeft];
    CGPoint brPoint = [self.mapView.projection pointForCoordinate:self.mapView.projection.visibleRegion.nearRight];
    
    NSLog(@"\n|⁻ lat %f lon %f   lat %f lon %f ⁻|\n|_ lat %f lon %f   lat %f lon %f _|\n",
          
          self.mapView.projection.visibleRegion.farLeft.latitude,
          self.mapView.projection.visibleRegion.farLeft.longitude,
          
          self.mapView.projection.visibleRegion.farRight.latitude,
          self.mapView.projection.visibleRegion.farRight.longitude,
          
          self.mapView.projection.visibleRegion.nearLeft.latitude,
          self.mapView.projection.visibleRegion.nearLeft.longitude,
          
          self.mapView.projection.visibleRegion.nearRight.latitude,
          self.mapView.projection.visibleRegion.nearRight.longitude);
    
    
    NSLog(@"\n|⁻ %f,%f   %f,%f ⁻|\n|_ %f,%f   %f,%f _|\n",
          tlPoint.x,
          tlPoint.y,
          
          trPoint.x,
          trPoint.y,
          
          blPoint.x,
          blPoint.y,
          
          brPoint.x,
          brPoint.y);
    
    CLLocationDegrees latDelta = fabs( tr.latitude - bl.latitude );
    CLLocationDegrees lonDelta = fabs( tr.longitude - bl.longitude );
    
    NSLog(@"DELTA\n ↑ %f   -> %f", latDelta, lonDelta);
    
    MKCoordinateRegion region = MKCoordinateRegionMake(position.target, MKCoordinateSpanMake(latDelta, lonDelta));
    
    MKMapRect rect = [self MKMapRectForCoordinateRegion:region];

    return rect;

}


- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position;
{
//    CLLocationCoordinate2D loc = CL
    
    
    
//    NSLog(@"afterMapRectSet %f,%f w %f h %f",
//          rect.origin.x,
//          rect.origin.y,
//          rect.size.width,
//          rect.size.height);
//    
//    NSLog(@"REGION %f,%f w %f h %f",
//          region.center.latitude,
//          region.center.longitude,
//          region.span.latitudeDelta,
//          region.span.longitudeDelta);
    
    [[NSOperationQueue new] addOperationWithBlock:^{
//        self.mapView.camera.zoom
        MKMapRect rect = [self getMapRect];
        double scale = self.mapView.bounds.size.width / rect.size.width;
//        double scale = self.mapView.projection.visibleRegion
        NSArray *annotations = [self.clusteringManager clusteredAnnotationsWithinMapRect:rect withZoomScale:scale];

        [self.clusteringManager displayAnnotations:annotations onMapView:mapView];
    }];
}

- (NSMutableArray*) hotelLocation
{
    
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *pathForResource = [bundlePath stringByAppendingPathComponent:@"test.csv"];
    NSError *error = nil;
    
    
    NSString * fileContents = [NSString stringWithContentsOfFile:pathForResource encoding:NSASCIIStringEncoding error:&error];
    
    NSArray *lines = [fileContents componentsSeparatedByString:@"\n"];
    NSArray * components;
    NSMutableArray * result = [[NSMutableArray alloc] initWithCapacity:lines.count];
    
    double lat,lon;
//    FBAnnotation * ann;
    GMSMarker *ann;
    
    
    for (NSString * line in lines) {
        components = [line componentsSeparatedByString:@", "];
        
        ann = [[GMSMarker alloc] init];
        
        lat = [components[1] doubleValue];
        lon = [components[0] doubleValue];
        
        ann.position = CLLocationCoordinate2DMake(lat, lon);
        
        [result addObject:ann];
    }
    
    return result;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MKMapViewDelegate

//- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
//{
//    [[NSOperationQueue new] addOperationWithBlock:^{
//        double scale = self.mapView.bounds.size.width / self.mapView.visibleMapRect.size.width;
//        NSArray *annotations = [self.clusteringManager clusteredAnnotationsWithinMapRect:mapView.visibleMapRect withZoomScale:scale];
//        
//        [self.clusteringManager displayAnnotations:annotations onMapView:mapView];
//    }];
//}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *const AnnotatioViewReuseID = @"AnnotatioViewReuseID";
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotatioViewReuseID];
    
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotatioViewReuseID];
    }
    
    // This is how you can check if annotation is a cluster
    if ([annotation isKindOfClass:[FBAnnotationCluster class]]) {
        FBAnnotationCluster *cluster = (FBAnnotationCluster *)annotation;
        cluster.title = [NSString stringWithFormat:@"%lu", (unsigned long)cluster.annotations.count];
        
        annotationView.pinColor = MKPinAnnotationColorGreen;
        annotationView.canShowCallout = YES;
    } else {
        annotationView.pinColor = MKPinAnnotationColorRed;
        annotationView.canShowCallout = NO;
    }
    
    return annotationView;
}

#pragma mark - FBClusterManager delegate - optional

- (CGFloat)cellSizeFactorForCoordinator:(FBClusteringManager *)coordinator
{
    return 1.5;
}

#pragma mark - Add annotations button action handler

- (IBAction)addNewAnnotations:(id)sender
{
    NSMutableArray *array = [self randomLocationsWithCount:kNUMBER_OF_LOCATIONS];
    [self.clusteringManager addAnnotations:array];
    
    self.numberOfLocations += kNUMBER_OF_LOCATIONS;
    [self updateLabelText];
    
    // Update annotations on the map
    [self mapView:self.mapView regionDidChangeAnimated:NO];
}

#pragma mark - Utility

- (NSMutableArray *)randomLocationsWithCount:(NSUInteger)count
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        FBAnnotation *a = [[FBAnnotation alloc] init];
        a.coordinate = CLLocationCoordinate2DMake(drand48() * 40 - 20, drand48() * 80 - 40);
        
        [array addObject:a];
    }
    return array;
}

- (void)updateLabelText
{
    self.numberOfAnnotationsLabel.text = [NSString stringWithFormat:@"Sum of all annotations: %lu", (unsigned long)self.numberOfLocations];
}

@end
