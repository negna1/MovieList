//
//  CollectionTableCell.swift
//  MovieList
//
//  Created by Nato Egnatashvili on 3/26/21.
//

import UIKit

protocol CollectionGestureDelegate {
    func didTapIdex(at index: Int)
}

protocol DotChangeDelegate {
    func dotChange(row: Int)
}

//There's only one cell type so i only register one cell. Also there are only cells  , not sections.
class CollectionTableCell: UITableViewCell  , UICollectionViewDataSource , MovieListConfigurable , DotChangeDelegate{
   
    var collections: [MovieInfo] = []
    var cellModels: [CollectionCellProtocol] = [] {
        didSet{
            self.collectionView.reloadData()
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var dots: UIPageControl!
    @IBOutlet var errorView: UIView!
    var size: CGSize?
    private  var gestureDelegate: CollectionGestureDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        styleUIForPageControl()
        styleUIForView()
        setFlowLayoutForCollectionView()
        registerNibs()
        setDelegateAndDatasource()
    }
    
    func setDelegateAndDatasource() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func styleUIForPageControl() {
        dots.pageIndicatorTintColor = .systemGray5
    }
    
    func styleUIForView() {
        self.backgroundView?.backgroundColor = .clear
        self.backgroundColor = .clear
    }
    
    func setFlowLayoutForCollectionView() {
        let flowLayout = ZoomAndSnapFlowLayout()
        flowLayout.dotdelegate = self
        collectionView.collectionViewLayout = flowLayout
    }
    
    func hideOrUnhideViews(model: CollectionModel ) {
        errorView.isHidden = !model.errorHappend
        collectionView.isHidden = model.errorHappend
        if model.animate {
            animationModels()
        }
    }
    
    func setValuesWithModel(with model: CollectionModel) {
        cellModels = model.similarMovies
        gestureDelegate = model.delegate
        dots.numberOfPages = self.cellModels.count
    }
    
    func configure(with model: CellProtocol) {
        if let model = model as? CollectionModel {
            setValuesWithModel(with: model)
            hideOrUnhideViews(model: model)
        }
    }
    
    func animationModels() {
        for _ in 0...2 {
            self.cellModels .append(CollectionMovieCellModel(image: nil, movieName:  "", movieRating: "",  animate: true))
        }
    }
    
    func registerNibs() {
            collectionView.register(
                UINib.init(nibName: "MovieCollectionCell", bundle: nil),
                forCellWithReuseIdentifier: "MovieCollectionCell")
    }
    
    @IBAction func pageControlSelectionAction(_ sender: UIPageControl) {
        let page: Int? = sender.currentPage
        var frame: CGRect = self.collectionView.frame
        frame.origin.x = frame.size.width * CGFloat(page ?? 0)
        frame.origin.y = 0
        self.collectionView.scrollRectToVisible(frame, animated: true)
    }
    
    func dotChange(row: Int) {
        dots.currentPage = row
    }
    
}

extension CollectionTableCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = cellModels[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellModels[indexPath.row].nibIdentifier,
                                                      for: indexPath) as? MovieCollectionConfigurable
        cell?.configure(with: model)
        return cell ?? UICollectionViewCell()
    }
    
}

extension CollectionTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = cellModels[indexPath.row]
        return model.size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        gestureDelegate?.didTapIdex(at: indexPath.row)
    }
}
