//
//  MovieDetailsConfigurator.swift
//  MovieList
//
//  Created by Nato Egnatashvili on 3/26/21.
//

import Foundation

protocol MovieDetailsConfigurator {
    func configure(vc: MovieDetailsController , movieInfo: MovieInfo )
}

class MovieDetailsConfiguratorImpl: MovieDetailsConfigurator {
    func configure(vc: MovieDetailsController , movieInfo: MovieInfo ) {
        let router = MovieDetailsRouterImpl(controller: vc)
        let presenter = MovieDetailsPresenterImpl(view: vc, router: router, movieInfo: movieInfo )
        vc.detailPresenter = presenter
    }
}
