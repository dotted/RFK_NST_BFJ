//
//  WeatherStationTableViewCell.h
//  Randers Flyveklub
//
//  Created by Mercantec on 2/27/13.
//  Copyright (c) 2013 Nestea & Bo Fucking Jensen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherStationTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, strong) IBOutlet UILabel *dataLabel;

@end
