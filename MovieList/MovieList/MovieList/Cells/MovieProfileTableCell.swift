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
//        view.layer.borderWidth = 1
//        view.layer.borderColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        img.layer.cornerRadius = 20
    }
    
    //There are two options , animate or not.
    
    func animate(){
        animators.forEach { (v) in
            v.animateOpacity(
                beginTime: CACurrentMediaTime() + 0.5,
                toValue: 0.2,
                reversed: true)
        }
        view.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    //also This cell can be 3 type. has note , has inverted and be normal :)
    func loadModel(with model: MovieCellModel) {
        view.layer.borderColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        animators.forEach { (v) in
            v.isHidden = true
        }
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
