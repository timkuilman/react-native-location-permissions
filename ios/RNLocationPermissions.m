#import "RNLocationPermissions.h"

#import <CoreLocation/CoreLocation.h>
#import <React/RCTLog.h>
#import <React/RCTConvert.h>

NSString* RNLocationPermissionsDidChangeEvent = @"RNLocationPermissionsDidChangeEvent";
NSString* RNLocationPermissionsErrorDomain = @"RNLocationPermissionsErrorDomain";

@implementation RCTConvert (LocationPermissions)
RCT_ENUM_CONVERTER(CLAuthorizationStatus, (@{ @"notDetermined" : @(kCLAuthorizationStatusNotDetermined),
                                             @"restricted" : @(kCLAuthorizationStatusRestricted),
                                             @"denied" : @(kCLAuthorizationStatusDenied),
                                              @"authorizedAlways" : @(kCLAuthorizationStatusAuthorizedAlways),
                                              @"authorizedWhenInUse": @(kCLAuthorizationStatusAuthorizedWhenInUse)}),
                   kCLAuthorizationStatusNotDetermined, intValue)
@end

@implementation RNLocationPermissions

@synthesize locationManager;


RCT_EXPORT_MODULE()

- (void) dealloc {
    locationManager.delegate = nil;
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

- (NSArray<NSString *> *)supportedEvents
{
    return @[RNLocationPermissionsDidChangeEvent];
}

- (NSDictionary *)constantsToExport
{
    return @{
        @"locationPermissionsDidChange": RNLocationPermissionsDidChangeEvent,
        @"notDetermined" : @(kCLAuthorizationStatusNotDetermined),
        @"restricted" : @(kCLAuthorizationStatusRestricted),
        @"denied" : @(kCLAuthorizationStatusDenied),
        @"authorizedAlways" : @(kCLAuthorizationStatusAuthorizedAlways),
        @"authorizedWhenInUse": @(kCLAuthorizationStatusAuthorizedWhenInUse)
    };
}

- (instancetype) init {
    self = [super init];

    if (self) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
    }

    return self;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    __block NSString *statusString = @"notDetermined";
    [[self constantsToExport] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        if ([obj intValue] == status) {
            statusString = key;
            *stop = true;
        }
    }];
    
    RCTLogInfo(@"Auth is %d", statusString);
    
    [self sendEventWithName:RNLocationPermissionsDidChangeEvent body:@{@"status":statusString}];
}

@end
