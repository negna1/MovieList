//
//  MovieDetailsRouter.swift
//  MovieList
//
//  Created by Nato Egnatashvili on 3/26/21.
//

import Foundation


protocol MovieDetailsRouter: AnyObject {
    func didTapMovie(movieInfo: MovieInfo)
    func moveToHomePage()
}

class MovieDetailsRouterImpl: MovieDetailsRouter {
    private weak var controller: MovieDetailsController?
    
    init(controller: MovieDetailsController) {
        self.controller = controller
    }
    
    func didTapMovie(movieInfo: MovieInfo) {
        let vc = MovieDetailsController.xibInstance(movieDetails: movieInfo)
        self.controller?.navigationItem.backButtonTitle = ""
        self.controller?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func moveToHomePage() {
        controller?.navigationController?.popToRootViewController(animated: true)
    }
}
