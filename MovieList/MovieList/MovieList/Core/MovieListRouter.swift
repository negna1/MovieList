//
//  MovieListRouter.swift
//  MovieList
//
//  Created by Nato Egnatashvili on 3/25/21.
//

import Foundation

protocol MovieListRouter: AnyObject {
    func didTapMovie(movieInfo: MovieInfo)
}

class MovieListRouterImpl: MovieListRouter {
    private weak var controller: MovieListController?
    
    init(controller: MovieListController) {
        self.controller = controller
    }
    
    func didTapMovie(movieInfo: MovieInfo) {
        let vc = MovieDetailsController.xibInstance(movieDetails: movieInfo)
        self.controller?.navigationItem.backButtonTitle = ""
        self.controller?.navigationController?.pushViewController(vc, animated: true)
    }
}
