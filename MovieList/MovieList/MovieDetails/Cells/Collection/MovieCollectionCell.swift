//
//  MovieCollectionCell.swift
//  MovieList
//
//  Created by Nato Egnatashvili on 3/26/21.
//

import UIKit

class MovieCollectionCell: UICollectionViewCell , MovieCollectionConfigurable {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet var animators: [AnimatorView]!
    
    func configure(with model: CollectionCellProtocol) {
        if let model = model as? CollectionMovieCellModel {
            model.animate ? animate() : loadModel(model: model)
        }
    }
    
    func animate() {
        animators.forEach { (v) in
            v.animateOpacity(
                beginTime: CACurrentMediaTime() + 0.5,
                toValue: 0.2,
                reversed: true)
        }
    }
    
    func loadModel(model: CollectionMovieCellModel) {
        animators.forEach { (v) in
            v.isHidden = true
        }
        self.img.image = model.image
        self.name.text = model.movieName
        self.rate.text = model.movieRating
    }

}
