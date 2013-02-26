//
//  DBDataController.m
//  Randers Flyveklub
//
//  Created by Mercantec on 2/20/13.
//  Copyright (c) 2013 Nestea & Bo Fucking Jensen. All rights reserved.
//

#import "DBDataController.h"
#import "sqlite3.h"
#import "Airfield.h"


@implementation DBDataController
{
    NSString            *db;
    NSMutableArray      *data;
    sqlite3             *dbhandle;
    sqlite3_stmt        *sql_query;
}

//Copy a named resource from bundle to Documents/Data

- (NSString *)copyResource:(NSString *)resource ofType:(NSString *)type
{
    NSString *dstDb = nil;
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *srcDb = [[NSBundle mainBundle] pathForResource:resource ofType:type];
    
    NSString *dstDir = [docDir stringByAppendingPathComponent:@"Data"];
    
    NSString *dstBase = [dstDir stringByAppendingPathComponent:resource];
    
    dstDb = [dstBase stringByAppendingPathExtension:type];
    
    NSError *error = nil;
    BOOL isDirectory = false;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dstDir isDirectory:&isDirectory])
    {
    
        if (![[NSFileManager defaultManager] createDirectoryAtPath:dstDir withIntermediateDirectories:YES attributes:nil error:&error])
            NSLog(@"Error Creating Directory:%@ \n", [error localizedDescription]);
    
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dstDb])
    {
        if (![[NSFileManager defaultManager] copyItemAtPath:srcDb toPath:dstDb error:&error])
            NSLog(@"Error: copying resource:%@\n", [error localizedDescription]);
    }
    return dstDb;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        db = [self copyResource:@"airfields" ofType:@"rdb"];
        
        if (sqlite3_open_v2([db UTF8String], &dbhandle, SQLITE_OPEN_READONLY,NULL) != SQLITE_OK)
        {
            NSLog(@"Error:open");
        }
        
        sql_query = nil;
        
        data = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    // Cleanup statement handles
    sqlite3_finalize(sql_query);
    //sqlite3_finalize(stmt_delete);
    //sqlite3_finalize(stmt_insert);
    
    // Close database
    sqlite3_close(dbhandle);
}

// Fetch airfield objects from data storage
// Return array with airfield objects, selected according to SQL statement

- (NSMutableArray *) getAll:(MapViewController *)controller
{
    if (!sql_query)
    {
        // Prepare SQL select statement
        NSString *sql = @"SELECT name, icao, country, lat, long FROM airfields";// WHERE country = 'Denmark'";
        if (sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &sql_query, nil) != SQLITE_OK)
        {
            NSLog(@"Error preparing SQL query");
            return data;
        }
    }
    
    // Reset state of query statement
    sqlite3_reset(sql_query);
    // Fetch selected rows in airfields table and populate data array
    while (sqlite3_step(sql_query) == SQLITE_ROW)
    {
        Airfield *airfield = [[Airfield alloc] init];
        
        // Assign name property with id column in result
        airfield.name = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(sql_query, 0)];
        // Assign icao property with id column in result
        airfield.icao = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(sql_query, 1)];
        // Assign country property with id column in result
        airfield.country = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(sql_query, 2)];
        
        airfield.lat = [[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(sql_query, 3)]doubleValue];
        airfield.lng = [[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(sql_query, 4)]doubleValue];
        
        // Append Airfield object to data array
        [data addObject:airfield];
        //NSLog(@"===> Added Airfield: country: %@, lat: %.2f, long: %.2f", airfield.country, airfield.lat, airfield.lng);
        //NSLog(@"===> Added Airfield: name: %@, icao: %@, country: %@, lat: %f, long: %f", airfield.name, airfield.icao, airfield.country, airfield.lat, airfield.lng);
    }
    
    return data;
}

// Fetch airfield objects from data storage
// Return array with airfield objects, selected according to SQL statement
-(NSMutableArray *) getVisible:(MapViewController *)controller FromCoordinates:(NSDictionary *)coordinates
{
    NSNumber *minLong = coordinates[@"minLong"];
    NSNumber *minLat = coordinates[@"minLat"];
    NSNumber *maxLong = coordinates[@"maxLong"];
    NSNumber *maxLat = coordinates[@"maxLat"];
    NSLog(@"minLong: %@ ,minLat: %@ ,maxLong: %@ ,maxLat: %@", minLong, minLat, maxLong, maxLat);
    

        NSString *sql = @"SELECT name, icao, country, lat, long FROM airfields WHERE lat >= ";
        sql = [sql stringByAppendingString: [NSString stringWithFormat:@"'%@' ", minLat]];
        sql = [sql stringByAppendingString: [NSString stringWithFormat:@"AND lat <= "]];
        sql = [sql stringByAppendingString: [NSString stringWithFormat:@"'%@' ", maxLat]];
        sql = [sql stringByAppendingString: [NSString stringWithFormat:@"and long >= "]];
        sql = [sql stringByAppendingString: [NSString stringWithFormat:@"'%@' ", minLong]];
        sql = [sql stringByAppendingString: [NSString stringWithFormat:@"and long <= "]];
        sql = [sql stringByAppendingString: [NSString stringWithFormat:@"'%@' ", maxLong]];
        NSLog(@"Sql query: %@", sql);
        if (sqlite3_prepare_v2(dbhandle, [sql UTF8String], -1, &sql_query, nil) != SQLITE_OK)
        {
            NSLog(@"Error preparing SQL Query");
            return data;
        }
    
    sqlite3_reset(sql_query);
    while (sqlite3_step(sql_query) == SQLITE_ROW)
    {
        Airfield *airfield = [[Airfield alloc] init];
        airfield.name = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(sql_query, 0)];
        airfield.icao = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(sql_query, 1)];
        airfield.country = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(sql_query, 2)];
        airfield.lat = [[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(sql_query, 3)]doubleValue];
        airfield.lng = [[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(sql_query, 4)]doubleValue];
        //NSLog(@"===> Added Airfield: country: %@, lat: %.2f, long: %.2f", airfield.country, airfield.lat, airfield.lng);
        //NSLog(@"===> Added Airfield: name: %@, icao: %@, country: %@, lat: %f, long: %f", airfield.name, airfield.icao, airfield.country, airfield.lat, airfield.lng);
        [data addObject:airfield];
    }
    
    NSLog(@"Returning Data");
    return data;
}

@end
