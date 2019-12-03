# LNICoverFlowLayout
Swift-only implementation of YRCoverFlowLayout. Also supports CocoaPods.
Only Swift 3 is supported.

# Description

This custom layout provides cover flow effect for UICollectionView. This project is a port of [YRCoverFlowLayout](https://github.com/solomidSF/YRCoverFlowLayout) to Swift, with CocoaPods support added.

From YRCoverFlowLayout description: *You don’t need to worry about items(cells) positions, spaces between them, etc. because it’s already done in YRCoverFlowLayout! You simply design your cell and return them as usual in datasource methods and YRCoverFlowLayout handles the rest.*

# Demo

![Portrait flow](/PortraitCoverLayout.gif)
![Lanscape flow](/LandscapeCoverLayout.gif)

# Installation

1. Add the following line to Podfile:
        `pod 'LNICoverFlowLayout'`
        and run `pod install`
2. Set custom layout class in your collection view to LNICoverFlowLayout. Make sure you change the Module to LNICoverFlowLayout as well.
![Change Both Class and Module](/ChangeModule.png)
3. Add an outlet from the cover flow layout into your UICollectionView dataSource class. You can customize the cover flow layout using the outlet, as shown below.
![Customize Layout](/CustomizingLayout.png)
3. Design your cell in collection view.
4. Return your cell in datasource methods.
5. Scroll and enjoy.

See included demo for more information.

# Customization

There are 4 properties that can be customized:

Max degree of rotation for items. Default to 45. This means that item on a left side of screen will be rotated 45 degrees around y and item on a right side will be rotated -45 degrees around y. *In Swift implementation, this ranges between -360 and 360.*

	public var maxCoverDegree:CGFloat

This property means how neighbour items are placed to in relation to currently displayed item. Default to 1/4. This means that item on left will cover 1/4 of current displayed item and item from right will also cover 1/4 of current item. Value should be in 0..1 range. *In Swift implementation, the range is enforced.*

	public var coverDensity:CGFloat

Min opacity that can be applied to individual item.
Default to 1.0 (alpha 100%). *In Swift implementation, the range is enforced.*

	public var minCoverOpacity:CGFloat

Min scale that can be applied to individual item.
Default to 1.0 (no scale).

	public var minCoverScale:CGFloat

If you’re changing them at runtime - don’t forget to call `collectionView.reloadData()`

# Notes

Currently only horizontal scroll direction is supported.
In future releases vertical scrolling will be added too.

# Keywords

Cover flow, custom layout, collection view, swift

# Version

v1.0.1
