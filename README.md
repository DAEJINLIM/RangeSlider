# RangeSlider
Default range slider made in Swift  
The default value is similar to the swift slider.

![Simulator Screen Recording - iPhone 15 Pro - 2023-11-09 at 00 40 48](https://github.com/DAEJINLIM/RangeSlider/assets/115560272/c0c15ba2-12ad-470c-81c1-3dada5b5176b)

## Use

This control was created in an environment without a storyboard.
If the thumb value changes, use the value with reference to.
```swift
import DJRangeSlider
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
