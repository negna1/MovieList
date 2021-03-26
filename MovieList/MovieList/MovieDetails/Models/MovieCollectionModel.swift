//
//  MovieCollectionModel.swift
//  MovieList
//
//  Created by Nato Egnatashvili on 3/26/21.
//

import UIKit


protocol CollectionCellProtocol {
    var nibIdentifier: String {get}
    var size: CGSize {get}
}

protocol MovieCollectionConfigurable: UICollectionViewCell {
    func configure(with model: CollectionCellProtocol)
}

struct CollectionMovieCellModel: CollectionCellProtocol {
    var nibIdentifier: String {return "MovieCollectionCell"}
    var size: CGSize {return animate ?  CGSize.init(width: 100,height: 70) :
                                        CGSize.init(width: 140,   height: 100)
    }
    let image: UIImage?
    let movieName: String
    let movieRating: String
    let animate: Bool
    
}
