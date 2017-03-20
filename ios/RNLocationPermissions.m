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


RCT_EXPORT_MODULE()

- (void) dealloc {
    self.locationManager.delegate = nil;
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
        
    }

    return self;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    [self sendEventWithName:RNLocationPermissionsDidChangeEvent body:@{@"status":@(status)}];
}

RCT_EXPORT_METHOD(startListening) {
    
    if (!self.locationManager) {
        self.locationManager = [CLLocationManager new];
        self.locationManager.delegate = self;
    }
}

RCT_EXPORT_METHOD(stopListening) {
    
    if (self.locationManager) {
        self.locationManager.delegate = nil;
        self.locationManager = nil;
    }
}


@end
