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

@synthesize mapView = _mapView;
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
    [self loadMap];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        //Initialize an mutable Array.
        NSMutableArray *myAnnotations = [[NSMutableArray alloc] init];
        //Get all airfields from database
        NSArray *airfieldList = [self.dcDelegateMap getAll:self];
        //Go through all airfields and add an Annotations object to the myAnnotations array
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mapView setAnnotations:myAnnotations];
        });
    });
    
 }

-(void)loadMap
//Load map and center on Randers showing while of Denmark.

{
    //NSLog(@"Loading map");
    self.mapView.mapType = MKMapTypeSatellite;
    
    MKCoordinateRegion myregion;
    myregion.center.latitude = 56.4667;
    myregion.center.longitude = 10.05;
    myregion.span.latitudeDelta = 3.765263;
    myregion.span.longitudeDelta = 8.437499;
    
   // NSLog(@"%f %f %f %f", myregion.center.latitude, myregion.center.longitude, myregion.span.longitudeDelta, myregion.span.latitudeDelta);
    //Apply the region
    [self.mapView setRegion:myregion animated:YES];

    //NSLog(@"Done loading map");
}

- (void)mapView:(ADClusterMapView *)mapView didSelectAnnotationView:(MKPinAnnotationView *)view
{
    //Get the selected annotations.
    id<MKAnnotation> selectedAnnotation = [mapView selectedAnnotations][0];
    //Change the color of selected annotation and set title and subtitle.
    view.pinColor = MKPinAnnotationColorPurple;
    selectedPin = selectedAnnotation.title;
    labelAirfield.text = selectedPin;
    labelICAO.text = selectedAnnotation.subtitle;
    //Get weather information from geonames if available for ICAO
    [self getIcaoWeather:selectedAnnotation.subtitle];

    NSLog(@"Selecting pin: %@", selectedPin);
}


- (void)mapView:(ADClusterMapView *)mapView didDeselectAnnotationView:(MKPinAnnotationView *)view
{
    //Reset state of pin when deselected
    view.pinColor = MKPinAnnotationColorRed;    
    NSLog(@"De-Selecting pin: %@", selectedPin);
    [self clearWeatherInformation];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(ADClusterMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //Deprecated used when loading current region pins only.
    //NSLog(@"Region changed");
    // Update markers on the map when the position changes... not implemented
}

-(void)getIcaoWeather:(NSString *)icao
//Get weather information for ICAO given as argument from geonames.org
{
    // Set string with URL
    NSString *icaoUrl = [NSString stringWithFormat:@"http://api.geonames.org/weatherIcaoJSON?formatted=true&ICAO=%@&username=nstios&style=full", icao];
    NSLog(@"Requesting on URL: %@#", icaoUrl);
    //Create URL request
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:icaoUrl]];
    //Call URLConnection with the request.
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response
{
    //Initialize urlData if a http response been received
    urlData = [[NSMutableData alloc] init];
}

-(void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    //Append received data to urlData
    [urlData appendData:data];
}

-(void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    //Log errors
    NSLog(@"Connection failed: %@", [error localizedDescription]);
    NSLog(@"Error code: %d" , [error code]);
    //If no internet connection inform the user by setting the labels.
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
//Update weather information labels with data.
{
    //Check if the dictionary has the wanted keys, if not dont add data.
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
//Reset all labels
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
//When the URL connection finishes loading, create dictionary from the JSON received.
{
    NSError *jsonParsingError = nil;
    if (conn)
    {
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
//Turn ON or OFF all map pins based on status on the switch controller.
{
    NSArray *annotations = [self.mapView annotations];
    //Run through all annotations on the mapview.
    for (i=0; i<[annotations count]; i++)
    {
        id<MKAnnotation> ann = [annotations objectAtIndex:i];
        if (switchStatus.isOn)
        {
            [[self.mapView viewForAnnotation:ann] setHidden:NO];
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
