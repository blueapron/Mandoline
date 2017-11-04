# Mandoline

[![Version](https://img.shields.io/cocoapods/v/Mandoline.svg?style=flat)](http://cocoapods.org/pods/Mandoline)
[![License](https://img.shields.io/cocoapods/l/Mandoline.svg?style=flat)](http://cocoapods.org/pods/Mandoline)
[![Platform](https://img.shields.io/cocoapods/p/Mandoline.svg?style=flat)](http://cocoapods.org/pods/Mandoline)

The `PickerView` is a `UICollectionView` that provides a smooth "picking" interface. In order to get the most out of it, a consuming view controller should support the `Selectable` protocol in the intended `UICollectionViewCell`s that dictates whether a cell `isSelectable`.

## Why would I want to use this library?

If you want to have a _boss_ scrolling experience like this:

![Blue Apron Meal Rescheduler](Mandoline/Assets/rescheduler.gif)

It also has responsive haptic feedback that is generated upon selection and moving across cells.

Note: this view is optimized to display a medium-sized collection, given that its primary offering is allowing a user to scroll to a given cell that may be off the screen. One way to offset this natural requirement is to consider the intended size of the `UICollectionViewCell` that will be used.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

PickerView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Mandoline'
```

## Usage

In the ViewController of use, you can initialize the `PickerView` like a `UIView` like so:

``` swift
let pickerView: PickerView = {
    let view = PickerView()
    view.cellSize = ScrollableCell.cellSize
    return view
}()
```

You'll also want to set the `PickerView`'s `dataSource` and `delegate` to `self`. Similar to a UICollectionView, be sure to `register` `YourCellClass` before the view will appear.

``` swift
override func viewDidLoad() {
    super.viewDidLoad()

    pickerView.register(cellType: YourCellClass.self)
    pickerView.delegate = self
    pickerView.dataSource = self
}
```

### `PickerViewDataSource`

 The `Selectable` protocol dictates whether an item is available (`isSelectable`), as observed by the size of the Overlay's dot.

``` swift
public protocol Selectable {
    var isSelectable: Bool { get set }
}
```

The `DataSource` is an array of `Selectable`'s.
``` swift
public protocol PickerViewDataSource: class {
    var selectableCells: [Selectable] { get }
}
```

### `PickerViewDelegate`

The `PickerView` has a number of `UIScrollView` and `UICollectionView` delegate functions that can be called on the view. These are all optional.

``` swift
func collectionView(_ view: PickerView, didSelectItemAt indexPath: IndexPath) {

}

func scrollViewWillBeginDragging(_ view: PickerView) {

}

func scrollViewWillEndDragging(_ view: PickerView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

}

func scrollViewDidScroll(_ scrollView: UIScrollView) {

}
```

There is also a `configure` function that is called in `collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell` for customization of `UICollectionViewCell`s.

``` swift
func configure(cell: UICollectionViewCell, for: IndexPath) {

}
```

### Mutable Properties

There are a number of settable properties on the PickerView:

#### Required
* `cellSize`: Set the size of the cell

If the `cellSize` is not set, the default `cellSize` from the `PickerViewCell` is used.

#### Optional
* `selectedOverlayColor`: Change the color of the overlay's border
* `dotColor`: Change the color of the dot
* `triangleSize`: Change the size of the picker triangle
* `dotSize`: Change the size of the dot
* `dotDistanceFromTop`: Change the distance of the dot from the top of the `UICollectionView`
* `backgroundColor`: Change the background color of the `UICollectionView`

## Requirements

* iOS 8+
* Xcode 8+

## License

Mandoline is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

### Contributing

Interested in contributing or learning more about the project? Check out our [engineering site](http://blueapron.io/) for more information.
