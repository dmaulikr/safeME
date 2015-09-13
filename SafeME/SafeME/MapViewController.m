//
//  MapViewController.m
//  Kaizen
//
//  Created by Ponnie Rohith on 28/03/15.
//  Copyright (c) 2015 PR. All rights reserved.
//

#import "MapViewController.h"
#import <Parse/Parse.h>

#import "ServiceChatsViewController.h"
#define METERS_PER_MILE 1609.344

NSMutableArray *locations;
NSMutableArray *names;
#define subtitleS @"Hey! I'm here. Don't worry "

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *shoutButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"shout"] style:UIBarButtonItemStyleDone target:self action:@selector(shoutTapped)];
    self.navigationItem.rightBarButtonItem = shoutButton;
}
-(void)shoutTapped
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Shout for Help"
                                                    message:@"Message sent to everyone"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}
-(void)fetchPassengers
{
    PFQuery *query = [PFQuery queryWithClassName:@"Locations"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Got data");
            
            locations = [[NSMutableArray alloc]init];
            names = [[NSMutableArray alloc]init];
            for (NSInteger i = 0 ;i < objects.count ; i++) {
                PFObject *object = objects[i];
                double latitude = [object[@"latitude"] doubleValue];
                double longitude = [object[@"longitude"] doubleValue];
                CLLocation *carLocation = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
                NSString *name = object[@"name"];
                [locations insertObject:carLocation atIndex:i];
                [names insertObject:name atIndex:i];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {

    [self fetchPassengers];
    CLLocation *carLocation = [locations objectAtIndex:0];
    
    CLLocationCoordinate2D loc = [carLocation coordinate];

    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(loc, 25*METERS_PER_MILE, 25*METERS_PER_MILE);
    self.mapView.delegate = self;
    
    // 3
    [self.mapView setRegion:viewRegion animated:YES];
    
    for (int i =0 ; i < locations.count; i++) {
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        CLLocationCoordinate2D loc = [locations[i] coordinate];
        point.coordinate = loc;
        point.title = names[i];
        point.subtitle = [NSString stringWithFormat:@"%@",@"Hey! I'm here. Don't worry "];
        [self.mapView addAnnotation:point];

    }
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *identifier = @"MyLocation";
        MKAnnotationView *annotationView = (MKAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"cab"];//here we use a nice image instead of the default pins
            UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
            [detailButton addTarget:self action:@selector(annotationDetailButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            annotationView.rightCalloutAccessoryView = detailButton;

        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
}
- (void)annotationDetailButtonPressed:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ask for Help"
                                                    message:@"Message sent to the selected passenger"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    

//    MKPointAnnotation *view = (MKPointAnnotation*)[sender superview];
//    [self.delegate didConfirm:view.title];
    [self.delegate didConfirm];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
