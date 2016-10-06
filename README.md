# CircularSpinner
A Beautiful fullscreen Circular Spinner, very useful for determinate or indeterminate task. You can use it as activity indicator during loading.

# Demo

![Spinner demo](https://raw.githubusercontent.com/taglia3/CircularSpinner/master/Gif/demo.gif)

# Installation

CircularSpinner is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

Swift 3:

```ruby
pod 'CircularSpinner'
```

Swift 2.2:

```ruby
pod 'CircularSpinner' ', '~> 0.2'
```

# Usage
You can present the circular spinner from anywhere by calling the `show()` class method.

The default presentation mode is fullscreen, if you want present the spinner in a custom container view use this code before presenting it:

```swift
CircularSpinner.useContainerView(containerView)
```

## Determinate Mode Example:

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

## Indeterminate Mode Example:

Presentation:

```swift
CircularSpinner.show("Loading...", animated: true, type: .indeterminate)
```
Dismiss by calling:

```swift
CircularSpinner.hide()
```

## Delegate
There's one method in the CircularSpinnerDelegate that you can use to customize the appearance of the percentual Label:

```swift
@objc optional func circularSpinnerTitleForValue(_ value: Float) -> NSAttributedString
```

## Author

taglia3, matteo.tagliafico@gmail.com

[LinkedIn](https://www.linkedin.com/in/matteo-tagliafico-ba6985a3), Matteo Tagliafico

## License

CircularSpinner is available under the MIT license. See the LICENSE file for more info.
