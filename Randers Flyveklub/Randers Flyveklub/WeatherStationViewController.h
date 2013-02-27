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

@property (nonatomic, strong) NSMutableArray * clientRawData;
@property (nonatomic, strong) NSMutableArray * descriptions;

@end
