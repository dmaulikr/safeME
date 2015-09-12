//
//  MapViewController.h
//  Kaizen
//
//  Created by Ponnie Rohith on 28/03/15.
//  Copyright (c) 2015 PR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@protocol MapViewDelegate <NSObject>
@optional
- (void)didConfirm:(NSString*)corider;
- (void)didConfirm;

@end

@interface MapViewController : UIViewController < MKMapViewDelegate >
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSString *destination;
@property (nonatomic,weak)id< MapViewDelegate > delegate;

@end
