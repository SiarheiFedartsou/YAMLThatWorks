# YAMLThatWorks

[![CI Status](http://img.shields.io/travis/SiarheiFedartsou/YAMLThatWorks.svg?style=flat)](https://travis-ci.org/SiarheiFedartsou/YAMLThatWorks)
[![Version](https://img.shields.io/cocoapods/v/YAMLThatWorks.svg?style=flat)](http://cocoapods.org/pods/YAMLThatWorks)
[![License](https://img.shields.io/cocoapods/l/YAMLThatWorks.svg?style=flat)](http://cocoapods.org/pods/YAMLThatWorks)
[![Platform](https://img.shields.io/cocoapods/p/YAMLThatWorks.svg?style=flat)](http://cocoapods.org/pods/YAMLThatWorks)

## Usage

Usage is very similar to ```NSJSONSerialization```:
```objectivec
id object = [YATWSerialization YAMLObjectWithData:data options:0 error:nil]
```
Currently we have only one option:
* ```YATWSerializationOptionsScalarDisableAutomaticConversion``` - disables automatic conversions of scalars to NSNumber if possible, but supported tags(!!bool, !!float etc) will still work.
## Requirements

## Installation

YAMLThatWorks is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "YAMLThatWorks"
```

## Author

Siarhei Fiedartsou, siarhei.fedartsou@gmail.com

## License

YAMLThatWorks is available under the MIT license. See the LICENSE file for more info.
