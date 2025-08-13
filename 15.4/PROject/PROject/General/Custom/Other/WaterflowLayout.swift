//
//  WaterflowLayout.swift
//  PROject
//
//  Created by ${USER_NAME} on TODAYS_DATE.
//

import UIKit

public protocol WaterflowLayoutDelegate: NSObjectProtocol {
    func collectionView(_ collectionView: UICollectionView, layout waterflowLayout: WaterflowLayout, heightForItemAt index: Int, itemWidth: CGFloat) -> CGFloat
}
public class WaterflowLayout: UICollectionViewLayout {
    public var edgeInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    public var rowSpacing: CGFloat = 10
    public var columnSpacing: CGFloat = 10
    public var columnWidthRatios: [CGFloat] = [1, 1]
    public var headerReferenceSize: CGSize?
    public var footerReferenceSize: CGSize?
    
    public unowned var delegate: WaterflowLayoutDelegate!
     
    private var contentHeight: CGFloat = 0
    private var columnHeights: [CGFloat] = []
    private var layoutAttrs: [UICollectionViewLayoutAttributes] = []
    private var itemWs: [CGFloat] = []
    private var itemLefts: [CGFloat] = []
     
    public override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        let count = collectionView.numberOfItems(inSection: 0)
        guard count > 0 else { return }
        
        let sum = columnWidthRatios.reduce(0, +)
        
        let collectionWidth = collectionView.bounds.size.width
        let columnCount = columnWidthRatios.count
        let totoalW = (collectionWidth - edgeInset.left - edgeInset.right - CGFloat(columnCount - 1) * columnSpacing)
        itemWs = columnWidthRatios.map { totoalW * ($0 / sum) }
        var i = 0
        itemLefts = sequence(first: edgeInset.left, next: {
            let v = $0 + self.itemWs[i] + self.columnSpacing
            i += 1
            return i < columnCount ? v : nil
        }).compactMap { $0 }
        
        contentHeight = edgeInset.top
        columnHeights = .init(repeating: contentHeight, count: columnCount)
        layoutAttrs.removeAll()
        
        if let size = headerReferenceSize,
           size.height > 0 {
            let attr = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: 0))
            attr.frame = CGRect(origin: .zero, size: CGSize(width: collectionWidth, height: size.height))
            layoutAttrs.append(attr)
            contentHeight += size.height
            columnHeights = columnHeights.map { _ in contentHeight }
        }
        
        for i in 0..<count {
            let indexPath = IndexPath(item: i, section: 0)
            if let attr = layoutAttributesForItem(at: indexPath) {
                layoutAttrs.append(attr)
            }
        }
        contentHeight += edgeInset.bottom
        if let size = footerReferenceSize,
           size.height > 0 {
            let attr = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: IndexPath(item: 0, section: 0))
            attr.frame = CGRect(x: 0, y: contentHeight, width: collectionWidth, height: size.height)
            layoutAttrs.append(attr)
            contentHeight += size.height
            columnHeights = columnHeights.map { _ in contentHeight }
        }
    }
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        layoutAttrs
    }
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        guard let (i, height) = columnHeights.enumerated().min(by: { $0.element < $1.element
        }) else { return nil }
        let w = itemWs[i]
        let h = delegate.collectionView(collectionView!, layout: self, heightForItemAt: indexPath.item, itemWidth: w)
        let x = itemLefts[i]
        let y = height == edgeInset.top ? height : (height + rowSpacing)
        
        let rect = CGRect(x: x, y: y, width: w, height: h)
        attr.frame = rect
        
        columnHeights[i] = rect.maxY
        contentHeight = max(columnHeights[i], contentHeight)
        
        return attr
    }
    
    public override var collectionViewContentSize: CGSize {
        CGSize(width: 0, height: contentHeight)
    }
}



class CoverFlowLayout: UICollectionViewFlowLayout {
    private(set) var selectedIndex = -1
    var onSelectedIndexChange: ((Int, Int) -> Void)?
    
    override func prepare() {
        super.prepare()
        scrollDirection = .horizontal
        
        minimumInteritemSpacing = h16
        minimumLineSpacing = h16
        
        guard let collectionView = self.collectionView else { return }
        collectionView.isPagingEnabled = false
        collectionView.decelerationRate = .fast
        let inset = (collectionView.frame.size.width - itemSize.width) * 0.5
        sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // 1.获取该范围内的布局数组
        guard let attributes = super.layoutAttributesForElements(in: rect),
              let collectionView = self.collectionView else {
            return nil
        }

        // 2.计算出整体中心点的 x 坐标
        let centerX = collectionView.contentOffset.x + collectionView.bounds.width * 0.5
        
        // 3.根据当前的滚动，对每个 cell 进行相应的缩放
        for attr in attributes {
            // 获取每个 cell 的中心点，并计算这俩个中心点的偏移值
            let pad = abs(centerX - attr.center.x)
            
            // 缩放因子
            let factor = 0.00008
            // 计算缩放比
            let scale = 1 / (1 + pad * CGFloat(factor))
            attr.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        // 4.返回修改后的 attributes 数组
        return attributes
    }
        
    /// 滚动时停下的偏移量
    /// - Parameters:
    ///   - proposedContentOffset: 将要停止的点
    ///   - velocity: 滚动速度
    /// - Returns: 滚动停止的点
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView else {
            return proposedContentOffset
        }
        let colSize = collectionView.bounds.size
        // 1.获取这个点可视范围内的布局属性
        guard let attrs = self.layoutAttributesForElements(in: CGRect(origin: proposedContentOffset, size: colSize)) else { return proposedContentOffset }
        
        // 2.计算中心点的 x 值
        let centerX = proposedContentOffset.x + colSize.width * 0.5
        var targetPoint = proposedContentOffset
        // 3. 需要移动的最小距离
        var moveDistance: CGFloat = CGFloat(MAXFLOAT)
        var minAttr: UICollectionViewLayoutAttributes?
        // 4.遍历数组找出最小距离
        for attr in attrs {
            if abs(moveDistance) > abs(attr.center.x - centerX) {
                moveDistance = attr.center.x - centerX
                minAttr = attr
            }
        }
        // 5.返回一个新的偏移点
        if targetPoint.x > 0 && targetPoint.x < collectionViewContentSize.width - colSize.width {
            targetPoint.x += moveDistance
        }
        if let attr = minAttr, attr.indexPath.item != selectedIndex {
            onSelectedIndexChange?(selectedIndex, attr.indexPath.item)
            selectedIndex = attr.indexPath.item
        }
        return targetPoint
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
//    override var collectionViewContentSize: CGSize {
//        let inset = sectionInset
//        return CGSize(width: inset.left + inset.right + (CGFloat(collectionView!.numberOfItems(inSection: 0)) * (itemSize.width + minimumLineSpacing)) - minimumLineSpacing, height: 0)
//    }
}
