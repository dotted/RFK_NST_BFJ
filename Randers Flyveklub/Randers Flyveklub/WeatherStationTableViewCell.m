//
//  WeatherStationTableViewCell.m
//  Randers Flyveklub
//
//  Created by Mercantec on 2/27/13.
//  Copyright (c) 2013 Nestea & Bo Fucking Jensen. All rights reserved.
//

#import "WeatherStationTableViewCell.h"

@implementation WeatherStationTableViewCell

@synthesize descriptionLabel = _descriptionLabel;
@synthesize dataLabel = _dataLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
