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
Currently we have two options:
* ```YATWSerializationOptionsScalarAutomaticConversion``` - automatically recognizes number or bool scalars and returns them with NSNumber type(by the way we don't support YAML type tags yet)
* ```YATWSerializationOptionsScalarAllowSameKeys``` - allows maps with same keys like this:
```yaml
spring:
    datasource:
        url: test
spring:
    main:
        headless: true
```
In this case this yaml will be represented as array of dictionaries, but not dictionary, in Objective C. If this flag is not specified then deserializer returns dictionary with arbitrary object from list of objects with the same keys.
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
