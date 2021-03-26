//
//  MovieDetailsModel.swift
//  MovieList
//
//  Created by Nato Egnatashvili on 3/26/21.
//

import UIKit

struct MovieDetailsCellModel: CellProtocol {
    var nibIdentifier: String {return "MovieMainDetailsTableCell"}
    var height: CGFloat {return 300 }
    let image: UIImage?
    let movieName: String
    let movieRating: String
    let raterCount: String
    let animate: Bool
}


struct MovieOverViewModel: CellProtocol {
    var nibIdentifier: String {return "MovieOverviewTableCell"}
    var height: CGFloat {return UITableView.automaticDimension}
    let overView: String
}

struct CollectionModel: CellProtocol {
    var nibIdentifier: String {return "CollectionTableCell"}
    var height: CGFloat {return 200}
    var similarMovies: [CollectionCellProtocol]
    var animate: Bool
}
