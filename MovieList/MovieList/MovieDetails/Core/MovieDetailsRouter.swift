//
//  MovieDetailsRouter.swift
//  MovieList
//
//  Created by Nato Egnatashvili on 3/26/21.
//

import Foundation


protocol MovieDetailsRouter: AnyObject {
    
}

class MovieDetailsRouterImpl: MovieDetailsRouter {
    private weak var controller: MovieDetailsController?
    
    init(controller: MovieDetailsController) {
        self.controller = controller
    }
}
