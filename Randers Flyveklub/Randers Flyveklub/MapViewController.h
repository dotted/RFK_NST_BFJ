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
#import "DataControllerDelegate.h"
#import "DBDataController.h"
#import "Airfield.h"
//#import <Foundation/NSThread.h>

@interface MapViewController : UIViewController

@property (atomic, strong) id <DataControllerDelegate> dcDelegateMap;
@property (strong, atomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSString *dbPath;

@property (weak, nonatomic) IBOutlet UIView *informationBox;
//@property (strong, atomic) NSThread *myThread;

@property (weak, nonatomic) IBOutlet UILabel *labelICAO;
@property (weak, nonatomic) IBOutlet UILabel *airfieldText;
@property (weak, nonatomic) IBOutlet UILabel *temperatureText;
@property (weak, nonatomic) IBOutlet UILabel *labelHumidity;
@property (weak, nonatomic) IBOutlet UILabel *labelClouds;
@property (weak, nonatomic) IBOutlet UILabel *labelWindDirection;
@property (weak, nonatomic) IBOutlet UILabel *labelWindSpeed;
@property (weak, nonatomic) IBOutlet UILabel *labelCountryCode;

@end

@interface Pinpointing_the_Location_of_a_DeviceViewController : UIViewController <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *myLocationManager;


@end