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
@synthesize dcDelegateMap;
@synthesize labelAirfield;
@synthesize labelICAO;
@synthesize labelTemperature;
@synthesize labelHumidity;
@synthesize labelClouds;
@synthesize labelWindDirection;
@synthesize labelWindSpeed;
@synthesize labelCountryCode;
@synthesize switchStatus;

NSURLConnection *conn;
NSMutableData *urlData;

NSString *selectedPin;
NSThread* myThread;

double centerLat;
double centerLong;
double spanLat;
double spanLong;
int i;

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
	// Do any additional setup after loading the view.
    /*self.view.backgroundColor = [UIColor whiteColor];
    */
    [super viewDidLoad];
    self.dcDelegateMap = [[DBDataController alloc] init];
    mapView.delegate = self;
    [self loadMap];

 }

-(void)loadMap {
    //NSLog(@"Loading map");
    self.mapView.mapType = MKMapTypeSatellite;
    
    MKCoordinateRegion myregion;
    myregion.center.latitude = 56.4667;
    myregion.center.longitude = 10.05;
    myregion.span.latitudeDelta = 3.765263;
    myregion.span.longitudeDelta = 8.437499;
    
   // NSLog(@"%f %f %f %f", myregion.center.latitude, myregion.center.longitude, myregion.span.longitudeDelta, myregion.span.latitudeDelta);

    [self.mapView setRegion:myregion animated:YES];

    //NSLog(@"Done loading map");
}

-(void)viewDidAppear:(BOOL)animated
{
    //myThread = [[NSThread alloc] initWithTarget:self selector:@selector(loadMapPins:) object:self.mapView];
    //[myThread start];
    [self loadMapPins:self.mapView];
}

-(void)loadMapPins:(MKMapView *)mapView
{
    NSMutableArray *myAnnotations = [[NSMutableArray alloc] init];
    NSArray *airfieldList = [self.dcDelegateMap getAll:self];

    for (Airfield *airfield in airfieldList)
    {
        CLLocationCoordinate2D airfieldCoords;
        airfieldCoords.latitude = airfield.lat;
        airfieldCoords.longitude = airfield.lng;
        MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
        [myAnnotation setCoordinate:airfieldCoords];
        [myAnnotation setTitle:airfield.name];
        [myAnnotation setSubtitle:airfield.icao];
        [myAnnotations addObject:myAnnotation];
    }
    [self.mapView addAnnotations:myAnnotations];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKPinAnnotationView *)view
{
    id<MKAnnotation> selectedAnnotation = [mapView selectedAnnotations][0];

    view.pinColor = MKPinAnnotationColorPurple;
    selectedPin = selectedAnnotation.title;
    labelAirfield.text = selectedPin;
    labelICAO.text = selectedAnnotation.subtitle;
    [self getIcaoWeather:selectedAnnotation.subtitle];

    NSLog(@"Selecting pin: %@", selectedPin);
}


- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKPinAnnotationView *)view
{
    view.pinColor = MKPinAnnotationColorRed;    
    NSLog(@"De-Selecting pin: %@", selectedPin);
    [self clearWeatherInformation];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    //Load all Markers for airfields.
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //NSLog(@"Region changed");
    // Update markers on the map when the position changes... not implemented
}

-(void)getIcaoWeather:(NSString *)icao
{
    NSString *icaoUrl = [NSString stringWithFormat:@"http://api.geonames.org/weatherIcaoJSON?formatted=true&ICAO=%@&username=nstios&style=full", icao];
    NSLog(@"Requesting on URL: %@#", icaoUrl);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:icaoUrl]];
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response
{
    urlData = [[NSMutableData alloc] init];
}

-(void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    NSLog(@"Test");
    [urlData appendData:data];
}

-(void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    NSLog(@"Connection failed: %@", [error localizedDescription]);
    NSLog(@"Error code: %d" , [error code]);
    if (-1009 == [error code])
    {
        NSString *no_internet = @"No Internet";
        labelCountryCode.text = no_internet;
        labelTemperature.text = no_internet;
        labelHumidity.text = no_internet;
        labelClouds.text = no_internet;
        labelWindDirection.text = no_internet;
        labelWindSpeed.text = no_internet;
    }
    
}

-(void)loadWeatherInformation:(NSDictionary *)dict
{
    //NSLog(@"%@", dict);
    if ([dict objectForKey:@"temperature"])
        labelTemperature.text = [NSString stringWithFormat:@"%@°C",dict[@"temperature"]];
    if ([dict objectForKey:@"humidity"])
        labelHumidity.text = [NSString stringWithFormat:@"%@" , dict[@"humidity"]];
    if ([dict objectForKey:@"clouds"])
        labelClouds.text = dict[@"clouds"];
    if ([dict objectForKey:@"windDirection"])
        labelWindDirection.text = [NSString stringWithFormat:@"%@", dict[@"windDirection"]];
    if ([dict objectForKey:@"windSpeed"])
        labelWindSpeed.text = [NSString stringWithFormat:@"%@", dict[@"windSpeed"]];
    if ([dict objectForKey:@"countryCode"])
        labelCountryCode.text = dict[@"countryCode"];
}

-(void)clearWeatherInformation
{
    NSLog(@"Clearing weather information");
    labelAirfield.text = @"";
    labelICAO.text = @"";
    labelTemperature.text = @"";
    labelHumidity.text = @"";
    labelClouds.text = @"";
    labelWindDirection.text = @"";
    labelWindSpeed.text = @"";
    labelCountryCode.text = @"";
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *jsonParsingError = nil;
    if (conn) {
        id object = [NSJSONSerialization JSONObjectWithData:urlData options:0 error:&jsonParsingError];
        
        if (jsonParsingError)
        {
            NSLog(@"JSON ERROR: %@", [jsonParsingError localizedDescription]);
        }
        else
        {
            //NSLog(@"OBJECT TYPE: %@", [object class]);
            [self loadWeatherInformation:object[@"weatherObservation"]];
        }
    }
}

- (IBAction)switchAction:(UISwitch *)sender
{
    NSArray *annotations = [self.mapView annotations];
    for (i=0; i<[annotations count]; i++)
    {
        id<MKAnnotation> ann = [annotations objectAtIndex:i];
        if (switchStatus.isOn)
        {
            [[mapView viewForAnnotation:ann] setHidden:NO];
            //NSLog(@"Is On");
        }
        else if (!(switchStatus.isOn))
        {
            //NSLog(@"Is Off");
            [[self.mapView viewForAnnotation:ann] setHidden:YES];
        }
        
    }
}
@end
