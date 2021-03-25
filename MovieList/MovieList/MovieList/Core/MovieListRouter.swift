//
//  MovieListRouter.swift
//  MovieList
//
//  Created by Nato Egnatashvili on 3/25/21.
//

import Foundation

protocol MovieListRouter: AnyObject {
}

class MovieListRouterImpl: MovieListRouter {
    private weak var controller: MovieListController?
    
    init(controller: MovieListController) {
        self.controller = controller
    }
}
