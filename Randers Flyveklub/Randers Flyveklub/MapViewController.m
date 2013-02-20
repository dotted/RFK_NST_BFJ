//
//  MapViewController.m
//  Randers Flyveklub
//
//  Created by Mercantec on 2/19/13.
//  Copyright (c) 2013 Nestea & Bo Fucking Jensen. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController
@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.mapView = [[MKMapView alloc]
                    initWithFrame:self.view.bounds];
    
    //self.mapView.mapType = MKMapTypeSatellite;
    
    self.mapView.delegate = self;
    
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:self.mapView];
    
    CLLocationCoordinate2D coords;
    coords.latitude = 56.4667;
    coords.longitude = 10.05;
    MKCoordinateRegion region;
    //region.center = [mapView userLocation].location.coordinate;
    region.center = coords;
    region.span.latitudeDelta = 3.75;
    region.span.longitudeDelta = 3.75;
    [mapView setRegion:region animated:YES];
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    _dbPath = [[NSString alloc]
               initWithString: [docsDir stringByAppendingPathComponent:
                                @"contacts.db"]];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    if ([fileMgr fileExistsAtPath: _dbPath] == NO)
    {
        const char *dbpath = [_dbPath UTF8String];
        
        if (sqlite3_open(dbpath, &_dbHandler) == SQLITE_OK) {
            char *errMsg;
            const char *sql_stmt =
                "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)";
            
            if (sqlite3_exec(_dbHandler, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table");
            }
            sqlite3_close(_dbHandler);
        }
        else
        {
            NSLog(@"Failed to open/create database");
        }
    }
}

- (void) saveData:(id)sender
{
    sqlite3_stmt *statement;
    const char *dbpath = [_dbPath UTF8String];
    
    if (sqlite3_open(dbpath, &_dbHandler) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO CONTACTS (name, address, phone) VALUES (\"%@\", \"%@\", \"%@\")", self.name.text, self.address.text, self.phone.text];
        
        const char * insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare(<#sqlite3 *db#>, <#const char *zSql#>, <#int nByte#>, <#sqlite3_stmt **ppStmt#>, <#const char **pzTail#>)
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    
}

@end
