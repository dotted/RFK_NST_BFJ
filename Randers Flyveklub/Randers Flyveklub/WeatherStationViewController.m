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

@synthesize clientRawData = _clientRawData;
@synthesize descriptions = _descriptions;

- (void)getRandersWeather
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.randersflyveklub.dk/vejr/clientraw.txt"]];
    AFCSVRequestOperation *operation = [AFCSVRequestOperation CSVRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id CSV)
    {
        self.clientRawData = CSV[0];
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
    self.descriptions = [ NSArray arrayWithObjects:@"header",@"avgSpeed",@"gusts",@"windDir",@"temp",@"outsideHumidity",@"barometer",@"dailyRain",@"monthlyRain",@"yearlyRain",@"rainRate",@"maxRainRate",@"indoorTemp",@"indoorHum",@"soilTemp",@"forecastIcon",@"wmr968ExtraTemp",@"wmr968ExtraHum",@"wmr968ExtraSensor",@"yesterdayRain",@"extraTempSensor1",@"extraTempSensor2",@"extraTempSensor3",@"extraTempSensor4",@"extraTempSensor5",@"extraTempSensor6",@"extraHumSensor1",@"extraHumSensor2",@"extraHumSensor3",@"hour",@"minute",@"seconds",@"stationName",@"dallasLightningCount",@"solarReading",@"day",@"month",@"wmr968Battery1",@"wmr968Battery2",@"wmr968Battery3",@"wmr968Battery4",@"wmr968Battery5",@"wmr968Battery6",@"wmr968Battery7",@"windChill",@"humidex",@"maxDayTemp",@"minDayTemp",@"iconType",@"weatherDesc",@"baroTrend",@"windspeedHour01",@"windspeedHour02",@"windspeedHour03",@"windspeedHour04",@"windspeedHour05",@"windspeedHour06",@"windspeedHour07",@"windspeedHour08",@"windspeedHour09",@"windspeedHour10",@"windspeedHour11",@"windspeedHour12",@"windspeedHour13",@"windspeedHour14",@"windspeedHour15",@"windspeedHour16",@"windspeedHour17",@"windspeedHour18",@"windspeedHour19",@"windspeedHour20",@"maxWindGust",@"dewPointTemp",@"cloudHeight",@"date",@"maxHumidex",@"minHumidex",@"maxWindchill",@"minWindchill",@"davisVPUV",@"hrWindspeed01",@"hrWindspeed02",@"hrWindspeed03",@"hrWindspeed04",@"hrWindspeed05",@"hrWindspeed06",@"hrWindspeed07",@"hrWindspeed08",@"hrWindspeed09",@"hrWindspeed10",@"hrTemp01",@"hrTemp02",@"hrTemp03",@"hrTemp04",@"hrTemp05",@"hrTemp06",@"hrTemp07",@"hrTemp08",@"hrTemp09",@"hrTemp10",@"hrRain01",@"hrRain02",@"hrRain03",@"hrRain04",@"hrRain05",@"hrRain06",@"hrRain07",@"hrRain08",@"hrRain09",@"hrRain10",@"maxHeatIndex",@"minHeatIndex",@"heatIndex",@"maxAvgSpeed",@"lightningCountsinceLastMin",@"timeofLastLightningStrike",@"dateofLastLightningStrike",@"windAvgDir",@"nexstormDist",@"nexStormBearing",@"extraTempSensor7",@"extraTempSensor8",@"extraHumSensor4",@"extraHumSensor5",@"extraHumSensor6",@"extraHumSensor7",@"extraHumSensor8",@"vpSolarwm",@"maxIndoorTemp",@"minIndoorTemp",@"apparentTemp",@"maxBaro",@"minBaro",@"maxGust",@"maxGustLastHourTime",@"maxGustToday",@"maxApparentTemp",@"minApparentTemp",@"maxDewpt",@"minDewpt",@"maxGustInLstMin",@"currentYear",@"THSWS",@"tempTrend_Logic",@"humidityTrend_Logic",@"humidexTrend_Logic",@"hrWindDir01",@"hrWindDir02",@"hrWindDir03",@"hrWindDir04",@"hrWindDir05",@"hrWindDir06",@"hrWindDir07",@"hrWindDir08",@"hrWindDir09",@"hrWindDir10",@"leafWetness",@"soilmoisture",@"10MinAvgWindSpeed",@"wetbulbtemperature",@"latitude_SHemispher",@"longitude_EASTofGMT",@"9amresetraintotal",@"midnightresetraintotal",@"recordEnd_WDVer", nil];
    [self getRandersWeather];
    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(getRandersWeather) userInfo:nil repeats:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.clientRawData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WeatherStationCell";
    
    WeatherStationTableViewCell *cell = [tableView
                              dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[WeatherStationTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.dataLabel.text = [self.clientRawData objectAtIndex:[indexPath row]];
    cell.descriptionLabel.text = [self.descriptions objectAtIndex:[indexPath row]];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
