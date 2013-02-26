//
//  DataControllerDelegate.h
//  Randers Flyveklub
//
//  Created by Mercantec on 2/20/13.
//  Copyright (c) 2013 Nestea & Bo Fucking Jensen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MapViewController;
@class Airfield;

@protocol DataControllerDelegate <NSObject>

- (NSMutableArray *) getAll:(MapViewController *)controller;
- (NSMutableArray *) getVisible:(MapViewController *)controller FromCoordinates:(NSDictionary *)coordinates;
@end
