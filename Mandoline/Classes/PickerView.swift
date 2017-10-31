//
//  PickerView.swift
//  Mandoline
//
//  Created by Anat Gilboa on 10/18/2017.
//  Copyright (c) 2017 ag. All rights reserved.
//

public class PickerView: UIView {

    /// The dataSource that, upon providing a set of `Selectable` items, reloads the UICollectionView
    public weak var dataSource: PickerViewDataSource? {
        didSet {
            reloadData()
        }
    }

    /// The object that acts as a delegate
    public weak var delegate: PickerViewDelegate?

    /// Change the color of the overlay's border
    public var selectedOverlayColor: UIColor = UIColor.blue {
        didSet {
            selectedItemOverlay.borderColor = selectedOverlayColor
        }
    }

    /// Change the color of the dot
    public var dotColor: UIColor = UIColor.green {
        didSet {
            selectedItemOverlay.dotColor = dotColor
        }
    }

    /// Change the size of the picker triangle
    public var triangleSize: CGSize? {
        didSet {
            guard let size = triangleSize else { return }
            selectedItemOverlay.triangleSize = size
        }
    }

    /// Change the size of the dot
    public var dotSize: CGSize? {
        didSet {
            guard let size = dotSize else { return }
            selectedItemOverlay.dotSize = size
        }
    }

    /// Change the distance of the dot from the top of the UICollectionView
    public var dotDistanceFromTop: CGFloat? {
        didSet {
            guard let distance = dotDistanceFromTop else { return }
            selectedItemOverlay.dotDistanceFromTop = distance
        }
    }

    private var selectedItemOverlaySizeConstraints: SizeConstraints?
    private var collectionViewHeightConstraint: NSLayoutConstraint?
    
    /// Set the size of the cell
    public var cellSize: CGSize? {
        didSet {
            guard let size = cellSize else { return }
            selectedItemOverlaySizeConstraints?.updateSize(to: size)
            collectionViewHeightConstraint?.constant = size.height
            setNeedsLayout()
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

    fileprivate var viewModel: PickerViewModel?
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
    
    let selectedItemOverlay: PickerViewOverlay = {
        let view = PickerViewOverlay()
        view.isUserInteractionEnabled = false
        return view
    }()

    fileprivate func setupSubviews() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .lightGray

        addSubview(collectionView)
        collectionView.register(PickerViewCell.self, forCellWithReuseIdentifier: "DayCell")
        collectionView.equal(.left, to: self)
        collectionView.equal(.right, to: self)
        collectionView.equal(.top, to: self)
        collectionViewHeightConstraint = collectionView.equal(.height, to: cellSize?.height ?? PickerViewCell.cellSize.height)

        addSubview(selectedItemOverlay)
        selectedItemOverlay.equal(.top, to: collectionView)
        selectedItemOverlaySizeConstraints = selectedItemOverlay.equalSize(to: cellSize ?? PickerViewCell.cellSize)
        selectedItemOverlay.equal(.centerX, to: self)
    }

    func reloadData() {
        guard let dataSource = self.dataSource else { return }
        viewModel = PickerViewModel(cells: dataSource.selectableCells)
        collectionView.reloadData()
    }

    /// Register a `UICollectionViewCell` subclass
    public func register<T: UICollectionViewCell>(cellType: T.Type) {
        collectionView.register(cellType, forCellWithReuseIdentifier: "DayCell")
    }

    /// Scroll to a cell at a given indexPath
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
        let inset = center.x - ((cellSize ?? PickerViewCell.cellSize).width / 2)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
}

public protocol PickerViewDataSource: class {
    /// The cells that are `Selectable` and set by the implementing ViewController
    var selectableCells: [Selectable] { get }
}

@objc public protocol PickerViewDelegate: class {
    /// UICollectionViewDelegate function that allows the consumer to respond to any selection events
    @objc optional func collectionView(_ view: PickerView, didSelectItemAt indexPath: IndexPath)
    /// UIScrollView function that allows the consumer to respond to scrolling events beginning
    @objc optional func scrollViewWillBeginDragging(_ view: PickerView)
    /// UIScrollView function that allows the consumer to respond to scrolling events ending
    @objc optional func scrollViewWillEndDragging(_ view: PickerView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    /// UIScrollView function that allows the consumer to respond to `scrollViewDidScroll`
    @objc optional func scrollViewDidScroll(_ scrollView: UIScrollView)
    /// Configuration function to be called with consumer's implemented custom UICollectionViewCell.
    @objc optional func configure(cell: UICollectionViewCell, for: IndexPath)
}

extension PickerViewDelegate {

    func collectionView(_ view: PickerView, didSelectItemAt indexPath: IndexPath) {

    }

    func scrollViewWillBeginDragging(_ view: PickerView) {

    }

    func scrollViewWillEndDragging(_ view: PickerView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }

    func configure(cell: UICollectionViewCell, for: IndexPath) {

    }
}

extension PickerView: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.cells.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath)
        delegate?.configure?(cell: cell, for: indexPath)
        return cell
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        delegate?.collectionView?(self, didSelectItemAt: indexPath)
    }
}

extension PickerView: UICollectionViewDelegateFlowLayout {

    /// This delegate function determines the size of the cell to return. If the cellSize is not set, then it returns the size of the PickerViewCell
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize ?? PickerViewCell.cellSize
    }
}
extension PickerView : UIScrollViewDelegate {

    /// This delegate function calculates the "snapping" for the overlay over the CollectionView (calendar view) cells
    /// The main purpose of this function is to calculate the size of the selected overlay's imageView,
    /// that is whether it scales from 0 to 1.5x
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetXOffset = targetContentOffset.pointee.x
        let rect = CGRect(origin: targetContentOffset.pointee, size: collectionView.bounds.size)
        guard let attributes = collectionView.collectionViewLayout.layoutAttributesForElements(in: rect) else { return }
        let xOffsets = attributes.map { $0.frame.origin.x }
        let distanceToOverlayLeftEdge = selectedItemOverlay.frame.origin.x - collectionView.frame.origin.x
        let targetCellLeftEdge = targetXOffset + distanceToOverlayLeftEdge
        let differences = xOffsets.map { fabs(Double($0 - targetCellLeftEdge)) }
        guard let min = differences.min(), let position = differences.index(of: min) else { return }
        let actualOffset = xOffsets[position] - distanceToOverlayLeftEdge
        targetContentOffset.pointee.x = actualOffset
        delegate?.scrollViewWillEndDragging?(self, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }

    /// This delegate function calculates how much the overlay imageView should transform depending on
    /// whether the left and right cells are "selectable"
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let vm = viewModel else { return }
        let scrollProgress = CGFloat(collectionView.contentOffset.x / (cellSize ?? PickerViewCell.cellSize).width)
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
        selectedItemOverlay.imageView.transform = CGAffineTransform(scaleX: dotScale, y: dotScale)

        guard ((lastScrollProgress.integerBelow != scrollProgress.integerBelow) && !lastScrollProgress.isIntegral)
            || (scrollProgress.isIntegral && !lastScrollProgress.isIntegral) else { return }
        self.generateFeedback()
        var convertedCenter = collectionView.convert(selectedItemOverlay.center, to: collectionView)
        convertedCenter.x += collectionView.contentOffset.x
        guard let indexPath = collectionView.indexPathForItem(at: convertedCenter) else { return }
        vm.select(cell: vm.cells[indexPath.row])
        self.generateFeedback()
        delegate?.scrollViewDidScroll?(scrollView)
    }
}

extension PickerView {

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
