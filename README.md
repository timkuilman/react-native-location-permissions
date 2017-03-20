# react-native-location-permissions

A simple and easy to use library for listening to location permission changes. This only works for iOS.

## Getting started

```
$ npm install react-native-location-permissions --save
$ react-native link
```

## Usage

## API Documentation

#### `locationPermissions#onPermissionsChange(callback)`
- `callback` `Function` The callback to invoke when the user's location permissions change

Registers a callback to be invoked whenever the user's location permissions change. The callback is invoked with an `event` argument which contains a string representation of the current permission under the `status` key.

This method returns a function which you should invoke when you want to unregister the callback, for example, in your app's `componentWillUnmount`.

#### Example
```js
const off = locationPermissions.onPermissionsChange((event) => {
	const { status } = event;

	if (status === locationPermissions.notDetermined) {
		console.log(`Location permissions not yet determined`);
	}
	else if (status === locationPermissions.authorizedAlways || status === locationPermissions.authorizedWhenInUse) {
		console.log(`Location permissions granted`);
	} else {
		console.log(`Location permissions denied`);
	}
});

// Whenever you want to unregister.
off();
```
