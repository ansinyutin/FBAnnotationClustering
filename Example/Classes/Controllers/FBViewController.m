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
#import "FBGMSMapView.h"
#import "FBHotel.h"

#import "FBCircleClusterView.h"

#define kNUMBER_OF_LOCATIONS 1000
#define kFIRST_LOCATIONS_TO_REMOVE 50

@interface FBViewController ()<GMSMapViewDelegate, FBGMSMapViewDelegate>


@property (weak, nonatomic) IBOutlet UILabel *numberOfAnnotationsLabel;

@property (nonatomic, strong) FBGMSMapView *mapView;
@property (nonatomic, assign) NSUInteger numberOfLocations;
@property (nonatomic, strong) FBClusteringManager *clusteringManager;
@property (nonatomic, strong) UIFont *clusterFont;

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
    
    /**
     Широта	55°45′21″N (55.755776)
     Долгота	37°36′53″E (37.614612)

     */

    // Георгий
//    CLLocationCoordinate2D centerLL = CLLocationCoordinate2DMake(55.755815, 37.614632);
    CLLocationCoordinate2D centerLL = CLLocationCoordinate2DMake(0, 0);
    


    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:centerLL.latitude
                                                            longitude:centerLL.longitude
                                                                 zoom:0];
    self.mapView = [[FBGMSMapView alloc] init];
    self.mapView.delegate = self;
    self.mapView.markerDelegate = self;
    self.mapView.camera = camera;
//    [self.mapView setCamera:camera];
    self.mapView.settings.compassButton = YES;
    
    [self.view addSubview:self.mapView];
    
    [self.mapView autoPinEdgesToSuperviewEdges];
    
    self.clusterFont = [UIFont boldSystemFontOfSize:12];
    
//    FBHotel * hotel = [FBHotel new];
//    hotel.position = centerLL;
//    
//    [self.mapView addAnnotation:hotel];
//    
    
    // Cluster Marker test
    
//    UIImage * img = [FBCircleClusterView clusterImageForText:@"111"];
//    UIImageView * cluster = [[UIImageView alloc] initWithImage:img];
//    [cluster setBounds:CGRectMake(0, 0, img.size.width, img.size.height)];
////    UIView * cluster = [[UIView alloc] init];;
////    cluster.text = @"232";
//    
//    cluster.layer.borderColor = UIColor.grayColor.CGColor;
//    cluster.layer.borderWidth = 0.5f;
////    cluster.backgroundColor = UIColor.redColor;
//    
//    [self.view addSubview:cluster];
//    
//    [cluster autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:100];
//    [cluster autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:100];
    
    
    
}


- (FBMarker*)mapView:(FBGMSMapView *)mapView markerForAnnotation:(id<FBAnnotation>)annotation
{
    FBMarker * marker = [[FBMarker alloc] init];
    
    if ([annotation isKindOfClass:[FBAnnotationCluster class]]) {
        FBAnnotationCluster *cluster = (FBAnnotationCluster *)annotation;
        
        NSString * countStr = [NSString stringWithFormat:@"%ld", cluster.annotations.count];
        
        marker.icon = [FBCircleClusterView clusterImageForText:countStr withFont:self.clusterFont];
        marker.groundAnchor = CGPointMake(0.5, 0.5);
    }
    
//    marker.icon = [FBCircleClusterView clusterImageForText:@"1"];
//    marker.groundAnchor = CGPointMake(0.5, 0.5);
    
    marker.position = annotation.position;
    
    return marker;

}

- (void)mapView:(FBGMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position;
{
    
        MKMapRect rect = [mapView MKMapRect];
        double scale = self.mapView.bounds.size.width / rect.size.width;
    
        NSArray *annotations = [self.clusteringManager clusteredAnnotationsWithinMapRect:rect withZoomScale:scale];

        [self.clusteringManager displayAnnotations:annotations onMapView:mapView];
    

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
    FBHotel *ann;
    
    
    for (NSString * line in lines) {
        components = [line componentsSeparatedByString:@", "];
        
        ann = [[FBHotel alloc] init];
        
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
    return 1.0;
}

#pragma mark - Add annotations button action handler

- (IBAction)addNewAnnotations:(id)sender
{
//    NSMutableArray *array = [self randomLocationsWithCount:kNUMBER_OF_LOCATIONS];
//    [self.clusteringManager addAnnotations:array];
//    
//    self.numberOfLocations += kNUMBER_OF_LOCATIONS;
//    [self updateLabelText];
//    
//    // Update annotations on the map
//    [self mapView:self.mapView regionDidChangeAnimated:NO];
}

#pragma mark - Utility

//- (NSMutableArray *)randomLocationsWithCount:(NSUInteger)count
//{
//    NSMutableArray *array = [NSMutableArray array];
//    for (int i = 0; i < count; i++) {
//        FBAnnotation *a = [[FBAnnotation alloc] init];
//        a.coordinate = CLLocationCoordinate2DMake(drand48() * 40 - 20, drand48() * 80 - 40);
//        
//        [array addObject:a];
//    }
//    return array;
//}

- (void)updateLabelText
{
    self.numberOfAnnotationsLabel.text = [NSString stringWithFormat:@"Sum of all annotations: %lu", (unsigned long)self.numberOfLocations];
}

@end
