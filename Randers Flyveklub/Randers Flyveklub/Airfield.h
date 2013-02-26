//
//  Airfield.h
//  Randers Flyveklub
//
//  Created by Mercantec on 2/20/13.
//  Copyright (c) 2013 Nestea & Bo Fucking Jensen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Airfield : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icao;
@property (nonatomic, copy) NSString *country;
@property (nonatomic) double lat;
@property (nonatomic) double lng;

@end
