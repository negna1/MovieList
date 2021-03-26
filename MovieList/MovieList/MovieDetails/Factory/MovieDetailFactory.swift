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
        case detailsImageErrored
        case similarMoviesImagesErrored
    }
    
    func getMovieDetailModelWithType(type : movieDetailType ,
                                     info: MovieInfo = MovieInfo(id: 0, imageName: "",
                                                                 movieName: "", avarageRate: 0,
                                                                 raterCount: 0, overview: ""),
                                     image: UIImage? = nil ,
                                     delegate: CollectionGestureDelegate?  = nil ,
                                     movies: [CollectionCellProtocol] = []) -> CellProtocol{
        switch type {
        case .details:
            return MovieDetailsCellModel(image: image ?? UIImage() ,
                                         movieName: info.movieName,
                                         movieRating: info.avarageRate.description,
                                         raterCount: info.raterCount.description,
                                         animate: false, errorHappend: false)
        case .overview:
            return MovieOverViewModel(overView: info.overview)
        case .similarMovies:
            return CollectionModel(similarMovies: movies, animate: false , delegate: delegate, errorHappend: false)
        case .similarMoviesWithAnimation:
            return CollectionModel(similarMovies: movies, animate: true, errorHappend: false)
        case .detailsAnimate:
            return MovieDetailsCellModel(image: image ?? UIImage() ,
                                         movieName: info.movieName,
                                         movieRating: info.avarageRate.description,
                                         raterCount: info.raterCount.description,
                                         animate: true, errorHappend: false)
        case .detailsImageErrored:
            return MovieDetailsCellModel(image: image ?? UIImage() ,
                                         movieName: info.movieName,
                                         movieRating: info.avarageRate.description,
                                         raterCount: info.raterCount.description,
                                         animate: false, errorHappend: true)
        case .similarMoviesImagesErrored:
            return CollectionModel(similarMovies: movies, animate: true, errorHappend: true)
        }
    }
    
}
