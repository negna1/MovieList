//
//  CollectionTableCell.swift
//  MovieList
//
//  Created by Nato Egnatashvili on 3/26/21.
//

import UIKit


//There's only one cell type so i only register one cell. Also there are only cells  , not sections.
class CollectionTableCell: UITableViewCell  , UICollectionViewDataSource , MovieListConfigurable{
    var collections: [MovieInfo] = []
    var cellModels: [CollectionCellProtocol] = []
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var dots: UIPageControl!
    var size: CGSize?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dots.pageIndicatorTintColor = .systemGray5
        dots.currentPageIndicatorTintColor = .yellow
        
//        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
//        lpgr.minimumPressDuration = 0.5
//        lpgr.delegate = self
//        lpgr.delaysTouchesBegan = true
//        self.collectionView?.addGestureRecognizer(lpgr)
        self.backgroundView?.backgroundColor = .clear
        self.backgroundColor = .clear
    }
    
    func configure(with model: CellProtocol) {
        if let model = model as? CollectionModel {
            registerNibs()
            cellModels = model.similarMovies
            dots.numberOfPages = self.cellModels.count
            if model.animate {
                animationModels() 
            }
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.reloadData()
            
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
    
//    @objc func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer){
//        if (gestureRecognizer.state != UIGestureRecognizer.State.ended){
//            return
//        }
//        let p = gestureRecognizer.location(in: self.collectionView)
//        if let index = self.collectionView?.indexPathForItem(at: p) {
//            gestureDelegate?.didLongTappedItem(at: index.row)
//        }
//    }
}

extension CollectionTableCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = cellModels[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionCell", for: indexPath) as? MovieCollectionConfigurable
        cell?.configure(with: model)
        return cell ?? UICollectionViewCell()
    }
    
}

extension CollectionTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = cellModels[indexPath.row]
        return model.size
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        dots.currentPage = self.indexOfMajorCell(collectionView: collectionView)
    }
    
    private func indexOfMajorCell(collectionView: UICollectionView) -> Int {
        let itemWidth = cellModels.first?.size.width ?? 1
           let proportionalOffset = collectionView.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(self.cellModels.count - 1, index))
           return safeIndex
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let indexOfMajorCell = self.indexOfMajorCell(collectionView: collectionView)
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        if indexOfMajorCell != 0 {
            if let leftCell = self.collectionView.cellForItem(at: IndexPath.init(row: indexOfMajorCell - 1, section: 0)) as? MovieCollectionCell {
                leftCell.transform = .identity
            }
        }
        if indexOfMajorCell != self.collections.count - 1 {
            if let leftCell = self.collectionView.cellForItem(at: IndexPath.init(row: indexOfMajorCell + 1, section: 0)) as? MovieCollectionCell {
                leftCell.transform = .identity
            }
        }
        let centerCell = self.collectionView.cellForItem(at: indexPath) as! MovieCollectionCell
        collectionView.bringSubviewToFront(centerCell)
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 0, options: [], animations: {
            centerCell.transform = CGAffineTransform(scaleX: 1.3, y: 1.5)
        })
    }
}
