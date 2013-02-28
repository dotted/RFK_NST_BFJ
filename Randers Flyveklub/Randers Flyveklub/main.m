//
//  main.m
//  Randers Flyveklub
//
//  Created by Mercantec on 2/19/13.
//  Copyright (c) 2013 Nestea & Bo Fucking Jensen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        @try {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
        @catch (NSException *exception) {
            NSLog(@"%@", [exception callStackSymbols]);
        }
    }
}
