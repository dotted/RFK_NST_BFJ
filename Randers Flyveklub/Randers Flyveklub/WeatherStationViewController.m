//
//  WeatherStationViewController.m
//  Randers Flyveklub
//
//  Created by Mercantec on 2/19/13.
//  Copyright (c) 2013 Nestea & Bo Fucking Jensen. All rights reserved.
//

#import "WeatherStationViewController.h"
#import "WeatherStationTableViewCell.h"

//@interface WeatherStationViewController ()

//@end

@implementation WeatherStationViewController

@synthesize time = _time;
@synthesize wind = _wind;
@synthesize temperature = _temperature;
@synthesize rain = _rain;
@synthesize misc = _misc;

@synthesize sections = _sections;

- (void)getRandersWeather
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.randersflyveklub.dk/vejr/clientraw.txt"]];
    AFCSVRequestOperation *operation = [AFCSVRequestOperation CSVRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id value)
    {
        self.time = [[NSArray alloc] initWithObjects:
                     [NSArray arrayWithObjects:value[0][29], @"Hour", nil],
                     [NSArray arrayWithObjects:value[0][30], @"Minute", nil],
                     [NSArray arrayWithObjects:value[0][31], @"Seconds", nil],
                     [NSArray arrayWithObjects:value[0][74], @"Date", nil],
                     //[NSArray arrayWithObjects:value[0][35], @"Day", nil],
                     //[NSArray arrayWithObjects:value[0][36], @"Month", nil],
                     nil];
        self.wind = [[NSArray alloc] initWithObjects:
                     [NSArray arrayWithObjects:value[0][1], @"Average wind speed", nil],
                     [NSArray arrayWithObjects:value[0][2], @"Gusts", nil],
                     [NSArray arrayWithObjects:value[0][3], @"Wind direction", nil],
                     [NSArray arrayWithObjects:value[0][113], @"Maximum average wind speed", nil],
                     [NSArray arrayWithObjects:value[0][117], @"Average wind direction", nil],
                     [NSArray arrayWithObjects:value[0][71], @"Maximum wind gust", nil],
                     nil];
        self.temperature = [[NSArray alloc] initWithObjects:
                            [NSArray arrayWithObjects:value[0][4], @"Temperature", nil],
                            [NSArray arrayWithObjects:value[0][5], @"Outdoor humidity", nil],
                            [NSArray arrayWithObjects:value[0][12], @"Indoor temperature", nil],
                            [NSArray arrayWithObjects:value[0][13], @"Indoor humidity", nil],
                            [NSArray arrayWithObjects:value[0][14], @"Soil temperature", nil],
                            [NSArray arrayWithObjects:value[0][45], @"Humidity index", nil],
                            [NSArray arrayWithObjects:value[0][44], @"Windchill factor", nil],
                            [NSArray arrayWithObjects:value[0][46], @"Maximum temperature today", nil],
                            [NSArray arrayWithObjects:value[0][47], @"Minimum temperature today", nil],
                            [NSArray arrayWithObjects:value[0][72], @"Dew point temperature", nil],
                            [NSArray arrayWithObjects:value[0][75], @"Maximum humidity index", nil],
                            [NSArray arrayWithObjects:value[0][76], @"Minimum humidity index", nil],
                            [NSArray arrayWithObjects:value[0][77], @"Maximum windchill factor", nil],
                            [NSArray arrayWithObjects:value[0][78], @"Minimum windchill factor", nil],
                            [NSArray arrayWithObjects:value[0][110], @"Maximum heat index", nil],
                            [NSArray arrayWithObjects:value[0][111], @"Minimum heat index", nil],
                            [NSArray arrayWithObjects:value[0][112], @"Heat index", nil],
                            [NSArray arrayWithObjects:value[0][128], @"Maximum indoor temperature", nil],
                            [NSArray arrayWithObjects:value[0][129], @"Minimum indoor temperature", nil],
                            nil];
        self.rain = [[NSArray alloc] initWithObjects:
                     [NSArray arrayWithObjects:value[0][7], @"Daily rain", nil],
                     [NSArray arrayWithObjects:value[0][8], @"Monthly rain", nil],
                     [NSArray arrayWithObjects:value[0][9], @"Yearly rain", nil],
                     [NSArray arrayWithObjects:value[0][10], @"Rain rate", nil],
                     [NSArray arrayWithObjects:value[0][11], @"Maximum rain rate", nil],
                     [NSArray arrayWithObjects:value[0][19], @"Amount of rain yesterday", nil],
                     nil];
        self.misc = [[NSArray alloc] initWithObjects:
                     [NSArray arrayWithObjects:value[0][6], @"Atmospheric pressure", nil],
                     [NSArray arrayWithObjects:value[0][49], @"Weather description", nil],
                     [NSArray arrayWithObjects:value[0][50], @"Barometer trend", nil],
                     [NSArray arrayWithObjects:value[0][73], @"Cloud height", nil],
                     [NSArray arrayWithObjects:value[0][114], @"Lightning count since last Min", nil],
                     [NSArray arrayWithObjects:value[0][115], @"Time of last lightning strike", nil],
                     [NSArray arrayWithObjects:value[0][116], @"Date of last lightning strike", nil],
                     //[NSArray arrayWithObjects:value[0][0], @"Header", nil],
                     //[NSArray arrayWithObjects:value[0][15], @"forecastIcon", nil],
                     //[NSArray arrayWithObjects:value[0][16], @"wmr968ExtraTemp", nil],
                     //[NSArray arrayWithObjects:value[0][17], @"wmr968ExtraHum", nil],
                     //[NSArray arrayWithObjects:value[0][18], @"wmr968ExtraSensor", nil],
                     //[NSArray arrayWithObjects:value[0][20], @"extraTempSensor1", nil],
                     //[NSArray arrayWithObjects:value[0][21], @"extraTempSensor2", nil],
                     //[NSArray arrayWithObjects:value[0][22], @"extraTempSensor3", nil],
                     //[NSArray arrayWithObjects:value[0][23], @"extraTempSensor4", nil],
                     //[NSArray arrayWithObjects:value[0][24], @"extraTempSensor5", nil],
                     //[NSArray arrayWithObjects:value[0][25], @"extraTempSensor6", nil],
                     //[NSArray arrayWithObjects:value[0][26], @"extraHumSensor1", nil],
                     //[NSArray arrayWithObjects:value[0][27], @"extraHumSensor2", nil],
                     //[NSArray arrayWithObjects:value[0][28], @"extraHumSensor3", nil],
                     //[NSArray arrayWithObjects:value[0][32], @"stationName", nil],
                     //[NSArray arrayWithObjects:value[0][33], @"dallasLightningCount", nil],
                     //[NSArray arrayWithObjects:value[0][34], @"solarReading", nil],
                     //[NSArray arrayWithObjects:value[0][37], @"wmr968Battery1", nil],
                     //[NSArray arrayWithObjects:value[0][38], @"wmr968Battery2", nil],
                     //[NSArray arrayWithObjects:value[0][39], @"wmr968Battery3", nil],
                     //[NSArray arrayWithObjects:value[0][40], @"wmr968Battery4", nil],
                     //[NSArray arrayWithObjects:value[0][41], @"wmr968Battery5", nil],
                     //[NSArray arrayWithObjects:value[0][42], @"wmr968Battery6", nil],
                     //[NSArray arrayWithObjects:value[0][43], @"wmr968Battery7", nil],
                     //[NSArray arrayWithObjects:value[0][48], @"iconType", nil],
                     //[NSArray arrayWithObjects:value[0][51], @"windspeedHour01", nil],
                     //[NSArray arrayWithObjects:value[0][52], @"windspeedHour02", nil],
                     //[NSArray arrayWithObjects:value[0][53], @"windspeedHour03", nil],
                     //[NSArray arrayWithObjects:value[0][54], @"windspeedHour04", nil],
                     //[NSArray arrayWithObjects:value[0][55], @"windspeedHour05", nil],
                     //[NSArray arrayWithObjects:value[0][56], @"windspeedHour06", nil],
                     //[NSArray arrayWithObjects:value[0][57], @"windspeedHour07", nil],
                     //[NSArray arrayWithObjects:value[0][58], @"windspeedHour08", nil],
                     //[NSArray arrayWithObjects:value[0][59], @"windspeedHour09", nil],
                     //[NSArray arrayWithObjects:value[0][60], @"windspeedHour10", nil],
                     //[NSArray arrayWithObjects:value[0][61], @"windspeedHour11", nil],
                     //[NSArray arrayWithObjects:value[0][62], @"windspeedHour12", nil],
                     //[NSArray arrayWithObjects:value[0][63], @"windspeedHour13", nil],
                     //[NSArray arrayWithObjects:value[0][64], @"windspeedHour14", nil],
                     //[NSArray arrayWithObjects:value[0][65], @"windspeedHour15", nil],
                     //[NSArray arrayWithObjects:value[0][66], @"windspeedHour16", nil],
                     //[NSArray arrayWithObjects:value[0][67], @"windspeedHour17", nil],
                     //[NSArray arrayWithObjects:value[0][68], @"windspeedHour18", nil],
                     //[NSArray arrayWithObjects:value[0][69], @"windspeedHour19", nil],
                     //[NSArray arrayWithObjects:value[0][70], @"windspeedHour20", nil],
                     //[NSArray arrayWithObjects:value[0][79], @"davisVPUV", nil],
                     //[NSArray arrayWithObjects:value[0][80], @"hrWindspeed01", nil],
                     //[NSArray arrayWithObjects:value[0][81], @"hrWindspeed02", nil],
                     //[NSArray arrayWithObjects:value[0][82], @"hrWindspeed03", nil],
                     //[NSArray arrayWithObjects:value[0][83], @"hrWindspeed04", nil],
                     //[NSArray arrayWithObjects:value[0][84], @"hrWindspeed05", nil],
                     //[NSArray arrayWithObjects:value[0][85], @"hrWindspeed06", nil],
                     //[NSArray arrayWithObjects:value[0][86], @"hrWindspeed07", nil],
                     //[NSArray arrayWithObjects:value[0][87], @"hrWindspeed08", nil],
                     //[NSArray arrayWithObjects:value[0][88], @"hrWindspeed09", nil],
                     //[NSArray arrayWithObjects:value[0][89], @"hrWindspeed10", nil],
                     //[NSArray arrayWithObjects:value[0][90], @"hrTemp01", nil],
                     //[NSArray arrayWithObjects:value[0][91], @"hrTemp02", nil],
                     //[NSArray arrayWithObjects:value[0][92], @"hrTemp03", nil],
                     //[NSArray arrayWithObjects:value[0][93], @"hrTemp04", nil],
                     //[NSArray arrayWithObjects:value[0][94], @"hrTemp05", nil],
                     //[NSArray arrayWithObjects:value[0][95], @"hrTemp06", nil],
                     //[NSArray arrayWithObjects:value[0][96], @"hrTemp07", nil],
                     //[NSArray arrayWithObjects:value[0][97], @"hrTemp08", nil],
                     //[NSArray arrayWithObjects:value[0][98], @"hrTemp09", nil],
                     //[NSArray arrayWithObjects:value[0][99], @"hrTemp10", nil],
                     //[NSArray arrayWithObjects:value[0][100], @"hrRain01", nil],
                     //[NSArray arrayWithObjects:value[0][101], @"hrRain02", nil],
                     //[NSArray arrayWithObjects:value[0][102], @"hrRain03", nil],
                     //[NSArray arrayWithObjects:value[0][103], @"hrRain04", nil],
                     //[NSArray arrayWithObjects:value[0][104], @"hrRain05", nil],
                     //[NSArray arrayWithObjects:value[0][105], @"hrRain06", nil],
                     //[NSArray arrayWithObjects:value[0][106], @"hrRain07", nil],
                     //[NSArray arrayWithObjects:value[0][107], @"hrRain08", nil],
                     //[NSArray arrayWithObjects:value[0][108], @"hrRain09", nil],
                     //[NSArray arrayWithObjects:value[0][109], @"hrRain10", nil],
                     //[NSArray arrayWithObjects:value[0][118], @"nexstormDist", nil],
                     //[NSArray arrayWithObjects:value[0][119], @"nexStormBearing", nil],
                     //[NSArray arrayWithObjects:value[0][120], @"extraTempSensor7", nil],
                     //[NSArray arrayWithObjects:value[0][121], @"extraTempSensor8", nil],
                     //[NSArray arrayWithObjects:value[0][122], @"extraHumSensor4", nil],
                     //[NSArray arrayWithObjects:value[0][123], @"extraHumSensor5", nil],
                     //[NSArray arrayWithObjects:value[0][124], @"extraHumSensor6", nil],
                     //[NSArray arrayWithObjects:value[0][125], @"extraHumSensor7", nil],
                     //[NSArray arrayWithObjects:value[0][126], @"extraHumSensor8", nil],
                     //[NSArray arrayWithObjects:value[0][127], @"vpSolarwm", nil],
                     //[NSArray arrayWithObjects:value[0][130], @"apparentTemp", nil],
                     //[NSArray arrayWithObjects:value[0][131], @"maxBaro", nil],
                     //[NSArray arrayWithObjects:value[0][132], @"minBaro", nil],
                     //[NSArray arrayWithObjects:value[0][133], @"maxGust", nil],
                     //[NSArray arrayWithObjects:value[0][134], @"maxGustLastHourTime", nil],
                     //[NSArray arrayWithObjects:value[0][135], @"maxGustToday", nil],
                     //[NSArray arrayWithObjects:value[0][136], @"maxApparentTemp", nil],
                     //[NSArray arrayWithObjects:value[0][137], @"minApparentTemp", nil],
                     //[NSArray arrayWithObjects:value[0][138], @"maxDewpt", nil],
                     //[NSArray arrayWithObjects:value[0][139], @"minDewpt", nil],
                     //[NSArray arrayWithObjects:value[0][140], @"maxGustInLstMin", nil],
                     //[NSArray arrayWithObjects:value[0][141], @"currentYear", nil],
                     //[NSArray arrayWithObjects:value[0][142], @"THSWS", nil],
                     //[NSArray arrayWithObjects:value[0][143], @"tempTrend_Logic", nil],
                     //[NSArray arrayWithObjects:value[0][144], @"humidityTrend_Logic", nil],
                     //[NSArray arrayWithObjects:value[0][145], @"humidexTrend_Logic", nil],
                     //[NSArray arrayWithObjects:value[0][146], @"hrWindDir01", nil],
                     //[NSArray arrayWithObjects:value[0][147], @"hrWindDir02", nil],
                     //[NSArray arrayWithObjects:value[0][148], @"hrWindDir03", nil],
                     //[NSArray arrayWithObjects:value[0][149], @"hrWindDir04", nil],
                     //[NSArray arrayWithObjects:value[0][150], @"hrWindDir05", nil],
                     //[NSArray arrayWithObjects:value[0][151], @"hrWindDir06", nil],
                     //[NSArray arrayWithObjects:value[0][152], @"hrWindDir07", nil],
                     //[NSArray arrayWithObjects:value[0][153], @"hrWindDir08", nil],
                     //[NSArray arrayWithObjects:value[0][154], @"hrWindDir09", nil],
                     //[NSArray arrayWithObjects:value[0][155], @"hrWindDir10", nil],
                     //[NSArray arrayWithObjects:value[0][156], @"leafWetness", nil],
                     //[NSArray arrayWithObjects:value[0][157], @"soilmoisture", nil],
                     //[NSArray arrayWithObjects:value[0][158], @"10MinAvgWindSpeed", nil],
                     //[NSArray arrayWithObjects:value[0][159], @"wetbulbtemperature", nil],
                     //[NSArray arrayWithObjects:value[0][160], @"latitude_SHemispher", nil],
                     //[NSArray arrayWithObjects:value[0][161], @"longitude_EASTofGMT", nil],
                     //[NSArray arrayWithObjects:value[0][162], @"9amresetraintotal", nil],
                     //[NSArray arrayWithObjects:value[0][163], @"midnightresetraintotal", nil],
                     //[NSArray arrayWithObjects:value[0][164], @"recordEnd_WDVer", nil],
                     nil];
        
        self.sections = [[NSMutableArray alloc] initWithObjects:self.time, self.wind, self.temperature, self.rain, self.misc, nil];
        
        [self.tableView reloadData];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id CSV) {
        NSLog(@"Failure!");
    }];
    
    [operation start];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(getRandersWeather) userInfo:nil repeats:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self getRandersWeather];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *sectionContents = [self.sections objectAtIndex:section];
    return [sectionContents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WeatherStationCell";
    
    WeatherStationTableViewCell *cell = [tableView
                              dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[WeatherStationTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSArray *sectionContents = [self.sections objectAtIndex:[indexPath section]];
    
    id elementInArray = [sectionContents objectAtIndex:[indexPath row]];
    id value = elementInArray[0];
    id key = elementInArray[1];
    cell.dataLabel.text = value;
    cell.descriptionLabel.text = key;

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    switch (section)
    {
        case 0:
            return NSLocalizedString(@"Time", @"");
        case 1:
            return NSLocalizedString(@"Wind", @"");
        case 2:
            return NSLocalizedString(@"Temperature", @"");
        case 3:
            return NSLocalizedString(@"Rain", @"");
        case 4:
            return NSLocalizedString(@"Miscellaneous", @"");
        default:
            return NSLocalizedString(@"Randers Weather Station", @"");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
