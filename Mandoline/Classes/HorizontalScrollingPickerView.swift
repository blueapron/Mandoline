//
//  HorizontalScrollingPickerView.swift
//  Mandoline
//
//  Created by Anat Gilboa on 10/18/2017.
//  Copyright (c) 2017 ag. All rights reserved.
//

import SnapKit

public class HorizontalScrollingPickerView: UIView {

    /// The dataSource that, upon providing a set of `Selectable` items, reloads the UICollectionView
    public weak var dataSource: HorizontalScrollingPickerViewDataSource? {
        didSet {
            reloadData()
        }
    }

    /// The delegate that, upon conforming to all of the
    public weak var delegate: HorizontalScrollingPickerViewDelegate?

    /// Change the color of the overlay's border
    public var selectedOverlayColor: UIColor = UIColor.blue {
        didSet {
            selectedDayOverlay.setFill(color: selectedOverlayColor)
        }
    }

    /// Change the color of the dot
    public var dotColor: UIColor = UIColor.green {
        didSet {
            selectedDayOverlay.dotColor = dotColor
        }
    }

    /// Change the size of the picker triangle
    public var triangleSize: CGSize? {
        didSet {
            guard let size = triangleSize else { return }
            selectedDayOverlay.triangleSize = size
        }
    }

    /// Change the size of the dot
    public var sizeOfDot: CGSize? {
        didSet {
            guard let size = sizeOfDot else { return }
            selectedDayOverlay.sizeOfDot = size
        }
    }

    /// Change the distance of the dot from the top of the UICollectionView
    public var dotDistanceFromTop: CGFloat? {
        didSet {
            guard let distance = dotDistanceFromTop else { return }
            selectedDayOverlay.dotDistanceFromTop = distance
        }
    }

    /// Set the size of the cell
    public var cellSize: CGSize? {
        didSet {
            guard let size = cellSize else { return }
            selectedDayOverlay.snp.updateConstraints { make in
                make.size.equalTo(size)
            }
            collectionView.snp.updateConstraints { make in
                make.height.equalTo(size.height)
            }
            updateConstraintsIfNeeded()
        }
    }

    /// Change the background color of the UICollectionView
    override public var backgroundColor: UIColor? {
        didSet {
            collectionView.backgroundColor = backgroundColor
        }
    }

    /// Initializers
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSubviews()
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        self.setupSubviews()
    }

    fileprivate var viewModel: HorizontalScrollingPickerViewModel?
    fileprivate var lastScrollProgress = CGFloat()
    fileprivate var lastIndexPath: IndexPath?

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        collectionView.clipsToBounds = false
        return collectionView
    }()

    let selectedDayOverlay: HorizontalScrollingPickerViewOverlay = {
        let view = HorizontalScrollingPickerViewOverlay()
        view.isUserInteractionEnabled = false
        return view
    }()

    func setupSubviews() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .lightGray

        addSubview(collectionView)
        collectionView.register(HorizontalScrollingPickerViewCell.self, forCellWithReuseIdentifier: "DayCell")
        collectionView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(cellSize ?? HorizontalScrollingPickerViewCell.cellSize.height)
        }

        addSubview(selectedDayOverlay)
        selectedDayOverlay.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.top)
            make.size.equalTo(cellSize ?? HorizontalScrollingPickerViewCell.cellSize)
            make.centerX.equalToSuperview()
        }
    }

    func reloadData() {
        guard let dataSource = self.dataSource else { return }
        viewModel = HorizontalScrollingPickerViewModel(cells: dataSource.selectableCells)
        collectionView.reloadData()
    }

    public func register<T: UICollectionViewCell>(cellType: T.Type) {
        collectionView.register(cellType, forCellWithReuseIdentifier: "DayCell")
    }

    public func scrollToCell(at indexPath: IndexPath) {
        guard let cellViewModelsCount = viewModel?.cells.count else { return }
        if indexPath.row < cellViewModelsCount / 2 {
            let lastIndexPath = IndexPath(row: cellViewModelsCount - 1, section: 0)
            collectionView.scrollToItem(at: lastIndexPath, at: .centeredHorizontally, animated: false)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        } else {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let inset = center.x - ((cellSize ?? HorizontalScrollingPickerViewCell.cellSize).width / 2)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
}

public protocol HorizontalScrollingPickerViewDataSource: class {
    /// The cells that are `Selectable` and set by the implementing ViewController
    var selectableCells: [Selectable] { get }
}

public protocol HorizontalScrollingPickerViewDelegate: class {
    /// UICollectionViewDelegate function that allows the consumer to respond to any selection events
    func collectionView(_ view: HorizontalScrollingPickerView, didSelectItemAt indexPath: IndexPath)
    /// UIScrollView function that allows the consumer to respond to scrolling events beginning
    func scrollViewWillBeginDragging(_ view: HorizontalScrollingPickerView)
    /// UIScrollView function that allows the consumer to respond to scrolling events ending
    func scrollViewWillEndDragging(_ view: HorizontalScrollingPickerView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    /// UIScrollView function that allows the consumer to respond to `scrollViewDidScroll`
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    /// Configuration function to be called with consumer's implemented custom UICollectionViewCell.
    func configure(cell: UICollectionViewCell, for: IndexPath)
}

extension HorizontalScrollingPickerViewDelegate {

    func collectionView(_ view: HorizontalScrollingPickerView, didSelectItemAt indexPath: IndexPath) {

    }

    func scrollViewWillBeginDragging(_ view: HorizontalScrollingPickerView) {

    }

    func scrollViewWillEndDragging(_ view: HorizontalScrollingPickerView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }

    func configure(cell: UICollectionViewCell, for: IndexPath) {

    }
}

extension HorizontalScrollingPickerView: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.cells.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath)
        delegate?.configure(cell: cell, for: indexPath)
        return cell
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        delegate?.collectionView(self, didSelectItemAt: indexPath)
    }
}

extension HorizontalScrollingPickerView: UICollectionViewDelegateFlowLayout {

    /// This delegate function determines the size of the cell to return. If the cellSize is not set, then it returns the size of the HorizontalScrollingPickerViewCell
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize ?? HorizontalScrollingPickerViewCell.cellSize
    }
}
extension HorizontalScrollingPickerView : UIScrollViewDelegate {

    /// This delegate function calculates the "snapping" for the overlay over the CollectionView (calendar view) cells
    /// The main purpose of this function is two-fold:
    ///      - to calculate the size of the selected overlay's imageView, that is whether it scales from 0 to 1.5x
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetXOffset = targetContentOffset.pointee.x
        let rect = CGRect(origin: targetContentOffset.pointee, size: collectionView.bounds.size)
        guard let attributes = collectionView.collectionViewLayout.layoutAttributesForElements(in: rect) else { return }
        let xOffsets = attributes.map { $0.frame.origin.x }
        let distanceToOverlayLeftEdge = selectedDayOverlay.frame.origin.x - collectionView.frame.origin.x
        let targetCellLeftEdge = targetXOffset + distanceToOverlayLeftEdge
        let differences = xOffsets.map { fabs(Double($0 - targetCellLeftEdge)) }
        guard let min = differences.min(), let position = differences.index(of: min) else { return }
        let actualOffset = xOffsets[position] - distanceToOverlayLeftEdge
        targetContentOffset.pointee.x = actualOffset
        delegate?.scrollViewWillEndDragging(self, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }

    /// This delegate function calculates how much the overlay imageView should transform depending on
    /// whether the left and right cells are "selectable"
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let vm = viewModel else { return }
        let scrollProgress = CGFloat(collectionView.contentOffset.x / (cellSize ?? HorizontalScrollingPickerViewCell.cellSize).width)
        defer { lastScrollProgress = scrollProgress }
        let leftIndex = Int(floor(scrollProgress))
        let rightIndex = Int(ceil(scrollProgress))
        let interCellProgress = scrollProgress - CGFloat(leftIndex)
        let deltaFromMiddle = fabs(0.5 - interCellProgress)
        let (this, next) = (vm.cells[safe: leftIndex]?.isSelectable ?? false,
                            vm.cells[safe: rightIndex]?.isSelectable ?? false)
        let dotScale: CGFloat
        switch (this, next) {
        case (true, true):
            dotScale = 1.5 - (deltaFromMiddle)
        case (true, false):
            dotScale = 1 - interCellProgress
        case (false, true):
            dotScale = interCellProgress
        case (false, false):
            dotScale = 0
        }
        selectedDayOverlay.imageView.transform = CGAffineTransform(scaleX: dotScale, y: dotScale)

        guard ((lastScrollProgress.integerBelow != scrollProgress.integerBelow) && !lastScrollProgress.isIntegral)
            || (scrollProgress.isIntegral && !lastScrollProgress.isIntegral) else { return }
        self.generateFeedback()
        var convertedCenter = collectionView.convert(selectedDayOverlay.center, to: collectionView)
        convertedCenter.x += collectionView.contentOffset.x
        guard let indexPath = collectionView.indexPathForItem(at: convertedCenter) else { return }
        vm.select(cell: vm.cells[indexPath.row])
        self.generateFeedback()
        delegate?.scrollViewDidScroll(scrollView)
    }
}

extension HorizontalScrollingPickerView {

    /// Generates feedback "selectionChanged" feedback
    fileprivate func generateFeedback() {
        if #available(iOS 10.0, *) {
            let feedbackGenerator = UISelectionFeedbackGenerator()
            feedbackGenerator.prepare()
            feedbackGenerator.selectionChanged()
            feedbackGenerator.prepare()
        }
    }
}
