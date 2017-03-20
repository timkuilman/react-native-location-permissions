import { NativeModules, NativeEventEmitter } from 'react-native';

const { RNLocationPermissions } = NativeModules;
const LocationPermissionsEventEmitter = new NativeEventEmitter(RNLocationPermissions);

export default {
	onPermissionsChange: (callback) => {

		const subscription = LocationPermissionsEventEmitter.addListener(RNLocationPermissions.locationPermissionsDidChange, callback);
		RNLocationPermissions.startListening();

		return function off() {
			subscription.remove();
			RNLocationPermissions.stopListening();
		};
	},
	...RNLocationPermissions
}
