//
//  MapViewController.h
//  Randers Flyveklub
//
//  Created by Mercantec on 2/19/13.
//  Copyright (c) 2013 Nestea & Bo Fucking Jensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <sqlite3.h>

@interface MapViewController : UIViewController
    <MKMapViewDelegate>
    /*{
        MKMapView *mapView;
    }*/

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSString *dbPath;
@property (nonatomic) sqlite3 *dbHandler;
@end

@interface Pinpointing_the_Location_of_a_DeviceViewController : UIViewController <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *myLocationManager;
@end