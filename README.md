# Mandoline

[![Version](https://img.shields.io/cocoapods/v/Mandoline.svg?style=flat)](http://cocoapods.org/pods/Mandoline)
[![License](https://img.shields.io/cocoapods/l/Mandoline.svg?style=flat)](http://cocoapods.org/pods/Mandoline)
[![Platform](https://img.shields.io/cocoapods/p/Mandoline.svg?style=flat)](http://cocoapods.org/pods/Mandoline)

The `HorizontalScrollingPickerView` is a `UICollectionView` that provides a smooth "picking". In order to get the most out of it, a consuming view controller should support the `Selectable` protocol in the intended `UICollectionViewCell`s that dictates whether a cell `isSelectable`.

## Why would I want to use this library?

If you want to have a _boss_ scrolling experience like this:

![Blue Apron Meal Rescheduler](https://imgur.com/a/4i8PA)

Note: this view is optimized to display a medium-sized collection, given that its primary offering is allowing a user to scroll to a given cell that may be off the screen. One way to offset this natural requirement is to consider the intended size of the cell.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

HorizontalScrollingPickerView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Mandoline'
```

## Usage

In the ViewController of use, you'll want to set the `HorizontalScrollingPickerView`'s `dataSource` and `delegate` to `self`. Similar to a UICollectionView, be sure to `register` `YourCellClass` before the view will appear.

```
override func viewDidLoad() {
    super.viewDidLoad()

    calendarView.register(cellType: YourCellClass.self)
    calendarView.delegate = self
    calendarView.dataSource = self
}
```

### `HorizontalScrollingPickerViewDataSource`

 The `Selectable` protocol dictates whether an item is available (`isSelectable`), as observed by the size of the Overlay's dot.

```
public protocol Selectable {
    var isSelectable: Bool { get set }
}
```

The `DataSource` is an array of `Selectable`'s.
```
public protocol Selectable: class {
  var selectableCells: [Selectable] { get }
}
```

### `HorizontalScrollingPickerViewDelegate`

The `HorizontalScrollingPickerView` has a number of `UIScrollView` and `UICollectionView` delegate functions that can be called on the view.

```
func collectionView(_ view: HorizontalScrollingPickerView, didSelectItemAt indexPath: IndexPath) {

}

func scrollViewWillBeginDragging(_ view: HorizontalScrollingPickerView) {

}

func scrollViewWillEndDragging(_ view: HorizontalScrollingPickerView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

}

func scrollViewDidScroll(_ scrollView: UIScrollView) {

}
```

The last delegate function that can be used by a consumer of this view is the `configure` function that is called in `collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell` for customization.

```
func configure(cell: UICollectionViewCell, for: IndexPath) {

}
```

### Mutable Properties

There are a number of settable properties on the HorizontalScrollingPickerView:

#### Required
* `cellSize`: Set the size of the cell

If the `cellSize` is not set, the default cellSize used in the `HorizontalScrollingPickerViewCell` is used.

#### Optional
* `selectedOverlayColor`: Change the color of the overlay's border
* `dotColor`: Change the color of the dot
* `triangleSize`: Change the size of the picker triangle
* `sizeOfDot`: Change the size of the dot
* `dotDistanceFromTop`: Change the distance of the dot from the top of the `UICollectionView`
* `backgroundColor`: Change the background color of the `UICollectionView`

## Requirements

* iOS 8+
* Xcode 8+

## Author

Anat Gilboa, anat.gilboa@blueapron.com

## License

Mandoline is available under the MIT license. See the LICENSE file for more info.

## Third-Party Licenses

### SnapKit
Copyright (c) 2011-Present SnapKit Team - https://github.com/SnapKit

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
