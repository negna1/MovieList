//
//  MovieListConfigurator.swift
//  MovieList
//
//  Created by Nato Egnatashvili on 3/25/21.
//

import Foundation


//I prefer to use CONTROLLER > Presenter > Configurator > Router . because it is very easy to find something. Also controller must not have its model its only job is to update view. Presenter has every work , like servers and tell core data to save. router is for navigation
protocol MovieListConfigurator {
    func configure(vc: MovieListController)
}

class MovieListConfiguratorImpl: MovieListConfigurator {
    func configure(vc: MovieListController) {
        let router = MovieListRouterImpl(controller: vc)
        let presenter = MovieListPresenterImpl(view: vc, router: router)
        vc.moviePresenter = presenter
    }
}
