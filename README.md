# CircularSpinner


## [GIF] Threedimensional & Normal mode

![Spinner demo](https://raw.githubusercontent.com/taglia3/CircularSpinner/master/Gif/demo.gif)

## Installation

CircularSpinner will be available through [CocoaPods](http://cocoapods.org) soon.

## Usage
You can present the circular spinner from anywhere by calling the `show()` class method.

# Determinate Mode Example:

Presentation:

```swift
CircularSpinner.show(animated: true, showDismissButton: false, delegate: self)
```
Update the value by calling:

```swift
CircularSpinner.setValue(0.2, animated: true)
```

The spinner will automatically dismiss when it reaches the 100%, alternatively you can dismiss it manually by calling:

```swift
CircularSpinner.hide()
```

# Ineterminate Mode Example:

Presentation:

```swift
CircularSpinner.show("Loading...", animated: true, type: .indeterminate)
```
Dismiss by calling:

```swift
CircularSpinner.hide()
```

# Delegate
There's one method in the CircularSpinnerDelegate that you can use to customize the appearance of the percentual Label:

```swift
optional func circularSpinnerTitleForValue(value: Float) -> NSAttributedString
```

## Author

taglia3, matteo.tagliafico@gmail.com

[LinkedIn](https://www.linkedin.com/in/matteo-tagliafico-ba6985a3), Matteo Tagliafico

## License

CircularSpinner is available under the MIT license. See the LICENSE file for more info.