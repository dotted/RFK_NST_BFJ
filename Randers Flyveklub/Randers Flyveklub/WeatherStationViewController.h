//
//  WeatherStationViewController.h
//  Randers Flyveklub
//
//  Created by Mercantec on 2/19/13.
//  Copyright (c) 2013 Nestea & Bo Fucking Jensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFCSVRequestOperation.h"

@interface WeatherStationViewController : UITableViewController

@property (nonatomic, strong) NSArray * time;
@property (nonatomic, strong) NSArray * wind;
@property (nonatomic, strong) NSArray * temperature;
@property (nonatomic, strong) NSArray * rain;
@property (nonatomic, strong) NSArray * misc;

@property (nonatomic, strong) NSMutableArray * sections;

@end
