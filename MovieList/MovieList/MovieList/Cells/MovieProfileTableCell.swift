//
//  MovieProfileTableCell.swift
//  MovieList
//
//  Created by Nato Egnatashvili on 3/25/21.
//

import UIKit

class MovieProfileTableCell: UITableViewCell , MovieListConfigurable {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet var animators: [AnimatorView]!
    
    override func awakeFromNib() {
        img.layer.cornerRadius = 20
    }
    
    //There are two options , animate or not.
    
    func hideOrUnhideViews(hide: Bool) {
        self.img.isHidden = hide
        self.username.isHidden = hide
        self.detail.isHidden = hide
    }
    
    func animate(){
        hideOrUnhideViews(hide: true)
        animators.forEach { (v) in
            v.isHidden = false
            v.animateOpacity(
                beginTime: CACurrentMediaTime() + 0.5,
                toValue: 0.2,
                reversed: true)
        }
    }
    
    //also This cell can be 3 type. has note , has inverted and be normal :)
    func loadModel(with model: MovieCellModel) {
        animators.forEach { (v) in
            v.isHidden = true
        }
        hideOrUnhideViews(hide: false)
        self.img.image = model.image
        self.username.text = model.movieName
        self.detail.text = "Raiting: " + model.movieRating
    }
    
    func configure(with model: CellProtocol) {
        if let model = model as? MovieCellModel {
            model.animate ? animate() : loadModel(with: model)
        }
    }
    
}
