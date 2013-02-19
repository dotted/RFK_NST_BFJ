//
//  MapViewController.h
//  Randers Flyveklub
//
//  Created by Mercantec on 2/19/13.
//  Copyright (c) 2013 Nestea & Bo Fucking Jensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController
    <MKMapViewDelegate>
    {
        MKMapView *mapView;
    }
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@end
