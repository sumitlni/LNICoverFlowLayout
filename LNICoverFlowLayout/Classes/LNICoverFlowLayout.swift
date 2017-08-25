//    LNICoverFlowLayout.swift
//
//    The MIT License (MIT)
//
//    Copyright (c) 2017 Loud Noise Inc.
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.

import UIKit

/**
    Collection Flow Layout in Swift 3.

    Adds cover flow effect to collection view scrolling.

    Currently supports only horizontal flow direction.
 */
open class LNICoverFlowLayout:UICollectionViewFlowLayout {
    /**
     *  Maximum degree that can be applied to individual item.

     *  Default to 45 degrees.
     */
    open var maxCoverDegree:CGFloat = 45 {
        didSet {
            if maxCoverDegree < -360 {
                maxCoverDegree = -360
            } else if maxCoverDegree > 360 {
                maxCoverDegree = 360
            }
        }
    }

    /**
     *  Determines how elements covers each other.
     *  Should be in range 0..1.
     *  Default to 0.25.
     *  Examples:
     *  0 means that items are placed within a continuous line.
     *  0.5 means that half of 3rd and 1st item will be behind 2nd.
     */
    open var coverDensity:CGFloat = 0.25 {
        didSet {
            if coverDensity < 0 {
                coverDensity = 0
            } else if coverDensity > 1 {
                coverDensity = 1
            }
        }
    }

    /**
     *  Min opacity that can be applied to individual item.
     *  Default to 1.0 (alpha 100%).
     */
    open var minCoverOpacity:CGFloat = 1.0 {
        didSet {
            if minCoverOpacity < 0 {
                minCoverOpacity = 0
            } else if minCoverOpacity > 1 {
                minCoverOpacity = 1
            }
        }
    }

    /**
     *  Min scale that can be applied to individual item.
     *  Default to 1.0 (no scale).
     */
    open var minCoverScale:CGFloat = 1.0  {
        didSet {
            if minCoverScale < 0 {
                minCoverScale = 0
            } else if minCoverScale > 1 {
                minCoverScale = 1
            }
        }
    }

    // Private Constant. Not a good naming convention but keeping as close to inspiration as possible
    fileprivate let kDistanceToProjectionPlane:CGFloat = 500.0


    // MARK: Overrides

    // Thanks to property initializations we do not need to override init(*)

    override open func prepare() {
        super.prepare()

        assert(self.collectionView?.numberOfSections == 1, "[LNICoverFlowLayout]: Multiple sections are not supported")
        assert(self.scrollDirection == .horizontal, "[LNICoverFlowLayout]: Vertical scrolling is not supported")
    }

    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let idxPaths = indexPathsContainedInRect(rect)

        var resultingAttributes = [UICollectionViewLayoutAttributes]()

        for path in idxPaths {
            resultingAttributes.append(layoutAttributesForItem(at: path))
        }

        return resultingAttributes
    }

    override open func layoutAttributesForItem(at indexPath:IndexPath)->UICollectionViewLayoutAttributes {
        let attributes = UICollectionViewLayoutAttributes(forCellWith:indexPath)

        attributes.size = self.itemSize
        attributes.center = CGPoint(x: collectionViewWidth()*CGFloat(indexPath.row) + collectionViewWidth(),
                                    y: collectionViewHeight()/2)

        let contentOffsetX = collectionView?.contentOffset.x ?? 0

        return interpolateAttributes(attributes, forOffset: contentOffsetX)
    }

    override open var collectionViewContentSize : CGSize {
        if let collectionView = collectionView {
            return CGSize(width: collectionView.bounds.size.width * CGFloat(collectionView.numberOfItems(inSection: 0)),
                          height: collectionView.bounds.size.height)
        }
        return CGSize.zero
    }

    // MARK: Accessors
    fileprivate func collectionViewHeight() -> CGFloat {
        let height = collectionView?.bounds.size.height ?? 0
        return height
    }

    fileprivate func collectionViewWidth() -> CGFloat {
        let width = collectionView?.bounds.size.width ?? 0
        return width
    }

    // MARK: Private

    fileprivate func itemCenterForRow(_ row:Int)->CGPoint {
        let collectionViewSize = collectionView?.bounds.size ?? CGSize.zero
        return CGPoint(x: CGFloat(row) * collectionViewSize.width + collectionViewSize.width / 2,
                       y: collectionViewSize.height/2)
    }

    fileprivate func minXForRow(_ row:Int)->CGFloat {
        return itemCenterForRow(row - 1).x + (1.0 / 2 - self.coverDensity) * self.itemSize.width
    }

    fileprivate func maxXForRow(_ row:Int)->CGFloat {
        return itemCenterForRow(row + 1).x - (1.0 / 2 - self.coverDensity) * self.itemSize.width
    }

    fileprivate func minXCenterForRow(_ row:Int)->CGFloat {
        let halfWidth = self.itemSize.width / 2
        let maxRads = degreesToRad(self.maxCoverDegree)

        let center = itemCenterForRow(row - 1).x
        let prevItemRightEdge = center + halfWidth
        let projectedLeftEdgeLocal = halfWidth * cos(maxRads) * kDistanceToProjectionPlane / (kDistanceToProjectionPlane + halfWidth * sin(maxRads))

        return prevItemRightEdge - (self.coverDensity * self.itemSize.width) + projectedLeftEdgeLocal
    }

    fileprivate func maxXCenterForRow(_ row:Int)->CGFloat {
        let halfWidth = self.itemSize.width / 2
        let maxRads = degreesToRad(self.maxCoverDegree)

        let center = itemCenterForRow(row + 1).x
        let nextItemLeftEdge = center - halfWidth
        let projectedRightEdgeLocal = fabs(halfWidth * cos(maxRads) * kDistanceToProjectionPlane / (-halfWidth * sin(maxRads) - kDistanceToProjectionPlane))

        return nextItemLeftEdge + (self.coverDensity * self.itemSize.width) - projectedRightEdgeLocal
    }

    fileprivate func degreesToRad(_ degrees:CGFloat)->CGFloat {
        return CGFloat(Double(degrees) * .pi / 180)
    }

    fileprivate func indexPathsContainedInRect(_ rect:CGRect)->[IndexPath] {
        let noI = collectionView?.numberOfItems(inSection: 0) ?? 0
        if noI == 0 {
            return []
        }

        let cvW = collectionViewWidth()

        // Find min and max rows that can be determined for sure
        var minRow = Int(max(rect.origin.x/cvW, 0))
        var maxRow = 0
        if cvW != 0 {
            maxRow = Int(rect.maxX / cvW)
        }

        // Additional check for rows that also can be included (our rows are moving depending on content size)
        let candidateMinRow = max(minRow-1, 0)

        if maxXForRow(candidateMinRow) >= rect.origin.x {
            minRow = candidateMinRow
        }

        let candidateMaxRow = min(maxRow + 1, noI - 1)
        if minXForRow(candidateMaxRow) <= rect.maxX {
            maxRow = candidateMaxRow
        }

        // Simply add index paths between min and max.
        var resultingIdxPaths = [IndexPath]()

        // Fix for issue #8 - Thanks gstrobl17
        if maxRow > 0 && (minRow < maxRow || noI == 1) {
            for i in minRow...maxRow {
                resultingIdxPaths.append(IndexPath(row: i, section: 0))
            }
        }

        return resultingIdxPaths
    }

    fileprivate func interpolateAttributes(_ attributes:UICollectionViewLayoutAttributes, forOffset offset:CGFloat)->UICollectionViewLayoutAttributes {

        let attributesPath = attributes.indexPath

        let minInterval = CGFloat(attributesPath.row - 1) * collectionViewWidth()
        let maxInterval = CGFloat(attributesPath.row + 1) * collectionViewWidth()

        let minX = minXCenterForRow(attributesPath.row)
        let maxX = maxXCenterForRow(attributesPath.row)
        let spanX = maxX - minX

        // Interpolate by formula
        let interpolatedX = min(max(minX + ((spanX / (maxInterval - minInterval)) * (offset - minInterval)), minX), maxX)

        attributes.center = CGPoint(x: interpolatedX, y: attributes.center.y)

        var transform = CATransform3DIdentity

        // Add perspective
        transform.m34 = -1.0 / kDistanceToProjectionPlane

        // Then rotate.
        let angle = -self.maxCoverDegree + (interpolatedX - minX) * 2 * self.maxCoverDegree / spanX
        transform = CATransform3DRotate(transform, degreesToRad(angle), 0, 1, 0)

        // Then scale: 1 - abs(1 - Q - 2 * x * (1 - Q))
        let scale = 1.0 - abs(1 - self.minCoverScale - (interpolatedX - minX) * 2 * (1.0 - self.minCoverScale) / spanX)
        transform = CATransform3DScale(transform, scale, scale, scale)

        // Apply transform
        attributes.transform3D = transform

        // Add opacity: 1 - abs(1 - Q - 2 * x * (1 - Q))
        let opacity = 1.0 - abs(1 - self.minCoverOpacity - (interpolatedX - minX) * 2 * (1 - self.minCoverOpacity) / spanX)

        attributes.alpha = opacity

//        print(String(format:"IDX: %d. MinX: %.2f. MaxX: %.2f. Interpolated: %.2f. Interpolated angle: %.2f",
//               attributesPath.row,
//               minX,
//               maxX,
//               interpolatedX,
//               angle));


        return attributes
    }
}
