//
//  MovieListModels.swift
//  MovieList
//
//  Created by Nato Egnatashvili on 3/25/21.
//

import UIKit

protocol CellProtocol {
    var nibIdentifier: String {get}
    var height: CGFloat {get}
}

protocol MovieListConfigurable: UITableViewCell {
    func configure(with model: CellProtocol)
}

struct MovieCellModel: CellProtocol {
    var nibIdentifier: String {return "MovieProfileTableCell"}
    var height: CGFloat {return 100}
    let image: UIImage?
    let movieName: String
    let movieRating: String
    let animate: Bool
}
