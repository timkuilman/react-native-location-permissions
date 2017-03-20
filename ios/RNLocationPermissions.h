#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <CoreLocation/CoreLocation.h>

@interface RNLocationPermissions : RCTEventEmitter <RCTBridgeModule, CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager* locationManager;

@end
