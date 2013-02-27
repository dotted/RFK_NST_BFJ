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
@synthesize airfieldText;
@synthesize labelICAO;
@synthesize temperatureText;
@synthesize labelHumidity;
@synthesize labelClouds;
@synthesize labelWindDirection;
@synthesize labelWindSpeed;
@synthesize labelCountryCode;


NSURLConnection *conn;
NSMutableData *urlData;

NSString *selectedPin;
NSMutableArray *existingIcao;
NSThread* myThread;

double centerLat;
double centerLong;
double spanLat;
double spanLong;

bool firstLoad = true;


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
    NSLog(@"Loading map");
    self.mapView.mapType = MKMapTypeSatellite;
    
    MKCoordinateRegion myregion;
    myregion.center.latitude = 56.4667;
    myregion.center.longitude = 10.05;
    myregion.span.latitudeDelta = 3.765263;
    myregion.span.longitudeDelta = 8.437499;
    
   // NSLog(@"%f %f %f %f", myregion.center.latitude, myregion.center.longitude, myregion.span.longitudeDelta, myregion.span.latitudeDelta);

    [self.mapView setRegion:myregion animated:YES];
    NSLog(@"Done loading map");
}

-(void)loadMapPins:(MKMapView *)mapView
{
    NSMutableArray *myAnnotations = [[NSMutableArray alloc] init];

    MKCoordinateRegion region;
    region.center = mapView.region.center;
    region.span = mapView.region.span;
    NSLog(@"Center cordinates: Latitude: %f, Longitude: %f", region.center.latitude, region.center.longitude);
    NSLog(@"Span: Latitude: %f, Longitude: %f", region.span.latitudeDelta, region.span.longitudeDelta);
    NSDictionary *coordinates = [self getCurrentMinMaxFromRegion:region];
    NSLog(@"test %d", [coordinates count]);
    NSArray *airfieldList = [self.dcDelegateMap getVisible:self FromCoordinates:coordinates];

    existingIcao = [[NSMutableArray alloc] init];
    int counter = 0;
    //[self.mapView removeAnnotations:self.mapView.annotations];
    NSArray *existingPins = mapView.annotations;
    NSLog(@"For Loop Start");
    for (id annotation in existingPins) {
        id<MKAnnotation> ann = annotation;
//        NSLog(@"%@", ann.subtitle);
        [existingIcao addObject:ann.subtitle];
    }
    NSLog(@"For Loop End");
    NSLog(@"For Loop Start");
    for (Airfield *airfield in airfieldList)
    {
        if ([existingIcao containsObject:airfield.icao])
        {
            continue;
        }
        CLLocationCoordinate2D airfieldCoords;
        airfieldCoords.latitude = airfield.lat;
        airfieldCoords.longitude = airfield.lng;
        MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
        [myAnnotation setCoordinate:airfieldCoords];
        [myAnnotation setTitle:airfield.name];
        [myAnnotation setSubtitle:airfield.icao];
        [myAnnotations addObject:myAnnotation];
        //NSLog(@"Counter: %d", counter++);
    }
    [self.mapView addAnnotations:myAnnotations];
    NSLog(@"For Loop End");
    NSLog(@"Existing pins: %d", [existingPins count]);
    NSLog(@"Drawing Starts");
    NSLog(@"Drawing done");
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKPinAnnotationView *)view
{
    id<MKAnnotation> selectedAnnotation = [mapView selectedAnnotations][0];

    view.pinColor = MKPinAnnotationColorPurple;
    selectedPin = selectedAnnotation.title;
    airfieldText.text = selectedPin;
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
    //Load all Markers for airfields.
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (!firstLoad) {
        NSLog(@"Region changed");
        // Update markers on the map when the position changes... not implemented
        [self loadMapPins:mapView];
    }
    firstLoad = false;
}


-(NSMutableDictionary *) getCurrentMinMaxFromRegion:(MKCoordinateRegion)region
{
    NSMutableDictionary *coordinates = [[NSMutableDictionary alloc] init];
    centerLat = region.center.latitude;
    centerLong = region.center.longitude;
    spanLat = region.span.latitudeDelta;
    spanLong = region.span.longitudeDelta;
    
    coordinates[@"minLong"] = [NSNumber numberWithDouble:centerLong - (spanLong / 1.8)];
    coordinates[@"minLat"] = [NSNumber numberWithDouble:centerLat - (spanLat / 1.9)];
    coordinates[@"maxLong"] = [NSNumber numberWithDouble:centerLong + (spanLong / 1.8)];
    coordinates[@"maxLat"] = [NSNumber numberWithDouble:centerLat + (spanLat / 1.8)];
    return coordinates;
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
    [urlData appendData:data];
}

-(void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    NSLog(@"Connection failed: %@", [error localizedDescription]);
}

-(void)loadWeatherInformation:(NSDictionary *)dict
{
    //NSLog(@"%@", dict);
    if ([dict objectForKey:@"temperature"])
        temperatureText.text = [NSString stringWithFormat:@"%@°C",dict[@"temperature"]];
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
    airfieldText.text = @"";
    labelICAO.text = @"";
    temperatureText.text = @"";
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

@end
