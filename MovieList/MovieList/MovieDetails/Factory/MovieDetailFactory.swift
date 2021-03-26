//
//  MovieDetailFactory.swift
//  MovieList
//
//  Created by Nato Egnatashvili on 3/26/21.
//

import UIKit


struct MovieDetailFactory {
    enum movieDetailType: Int {
        case details = 0
        case overview
        case similarMovies
        case similarMoviesWithAnimation
        case detailsAnimate
    }
    
    func getMovieDetailModelWithType(type : movieDetailType ,
                                     info: MovieInfo ,
                                     image: UIImage? = nil ,
                                     movies: [CollectionCellProtocol] = []) -> CellProtocol{
        switch type {
        case .details:
            return MovieDetailsCellModel(image: image ?? UIImage() ,
                                         movieName: info.movieName,
                                         movieRating: info.avarageRate.description,
                                         raterCount: info.raterCount.description,
                                         animate: false)
        case .overview:
            return MovieOverViewModel(overView: info.overview)
        case .similarMovies:
            return CollectionModel(similarMovies: movies, animate: false)
        case .similarMoviesWithAnimation:
            return CollectionModel(similarMovies: movies, animate: true)
        case .detailsAnimate:
            return MovieDetailsCellModel(image: image ?? UIImage() ,
                                         movieName: info.movieName,
                                         movieRating: info.avarageRate.description,
                                         raterCount: info.raterCount.description,
                                         animate: true)
        }
    }
    
}
