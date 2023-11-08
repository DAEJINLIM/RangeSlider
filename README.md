# RangeSlider
A simple range slider made in Swift
The default value is similar to the swift slider.

![Simulator Screen Recording - iPhone 15 Pro - 2023-11-08 at 22 52 57](https://github.com/DAEJINLIM/RangeSlider/assets/115560272/86e79212-c9f3-4de5-89f6-2d4c940afd43)

## Use

This control was created in an environment without a storyboard.
If the thumb value changes, use the value with reference to.
```swift
let rangeSlider = RangeSlider()
view.addSubView(rangeSlider)
rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged(_:)), for: .valueChanged)
```

## Configuration

Customizes the slider with the following values, and the properties provide access to information.
- minValue : Current value of minimum thumb
- maxValue : Current value of maximum thumb
- minRange : Minimum range value for slider
- maxRange : Maximum range value for slider
- thumbTintColor : Change the color of your thumbColor
- trackTintColor : Change the color of your trackColor
- trackHighlightTintColor : Change track color between ranges
- roundness : Adjust the value between the circle and the rectangle from 1.0 to 0.0 (default 1.0 is a circle)

## Installation

In the xcode, go to File -> Add Package Dependencies and go to the URL 
Create https://github.com/DAEJINLIM/RangeSlider .

## Creator

[DAEJIN LIM](https://github.com/DAEJINLIM)

## License

RangeSlider is available under the MIT License
