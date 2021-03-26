//
//  MovieMainDetailsTableCell.swift
//  MovieList
//
//  Created by Nato Egnatashvili on 3/26/21.
//

import UIKit

class MovieMainDetailsTableCell: UITableViewCell , MovieListConfigurable {
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var raterCount: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet var animators: [AnimatorView]!
    @IBOutlet weak var errorView: UIView!
    
    func configure(with model: CellProtocol) {
        if let model = model as?  MovieDetailsCellModel {
                movieImage.isHidden = model.errorHappend
                errorView.isHidden = !model.errorHappend
            model.animate ? animate(model: model) : loadModel(model: model)
        }
    }

    
    func animate(model: MovieDetailsCellModel) {
        animators.forEach { (v) in
            v.animateOpacity(
                beginTime: CACurrentMediaTime() + 0.5,
                toValue: 0.2,
                reversed: true)
        }
        self.rate.text = "Movie Rating: " + model.movieRating
        self.raterCount.text = "Vote Number: " + model.raterCount
        self.movieTitle.text = model.movieName
    }
    
    func loadModel(model: MovieDetailsCellModel) {
        animators.forEach { (v) in
            v.isHidden = true
        }
        self.movieImage.image = model.image
        self.rate.text = "Movie Rating: " + model.movieRating
        self.raterCount.text = "Vote Number: " + model.raterCount
        self.movieTitle.text = model.movieName
    }
    
}
