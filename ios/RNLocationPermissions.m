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

@interface RNLocationPermissions ()

@property (nonatomic, strong) NSMutableArray <NSDictionary *> *completionBlocks;

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
        self.completionBlocks = [NSMutableArray new];
    }

    return self;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    [self sendEventWithName:RNLocationPermissionsDidChangeEvent body:@{@"status":@(status)}];
    
    [self.completionBlocks enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj[@"resolve"]) {
            ((RCTPromiseResolveBlock)obj[@"resolve"])(@(status));
        }
    }];
    
    self.completionBlocks = nil;
}

RCT_EXPORT_METHOD(startListening) {
    
    if (!self.locationManager) {
        self.locationManager = [CLLocationManager new];
        self.locationManager.delegate = self;
    } else {
        self.locationManager.delegate = self;
    }
}

RCT_EXPORT_METHOD(stopListening) {
    
    if (self.locationManager) {
        self.locationManager.delegate = nil;
        self.locationManager = nil;
    }
}

RCT_EXPORT_METHOD(requestWhenInUsePermissions:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    
    if (!self.locationManager) {
        self.locationManager = [CLLocationManager new];
    }
    
    [self.completionBlocks addObject:@{
        @"resolve": resolve,
        @"reject": reject
    }];
    
    [self.locationManager requestWhenInUseAuthorization];
}

RCT_EXPORT_METHOD(requestAlwaysPermissions:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    
    if (!self.locationManager) {
        self.locationManager = [CLLocationManager new];
    }
    
    [self.completionBlocks addObject:@{
        @"resolve": resolve,
        @"reject": reject
    }];
    
    [self.locationManager requestAlwaysAuthorization];
}

@end
