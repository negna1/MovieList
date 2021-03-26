//
//  MovieDetailsConstants.swift
//  MovieList
//
//  Created by Nato Egnatashvili on 3/26/21.
//

import Foundation

struct MovieDetailsConstants {
    static let Cells: [String] = ["MovieOverviewTableCell" ,
                                  "MovieMainDetailsTableCell" ,
                                  "MovieProfileTableCell" ,
                                  "CollectionTableCell" ]
    struct Messages {
        static let internetLost = "Your Internet Connection is lost"
        static let notHaveData = "Sorry , there is no data"
    }
    static let posterPrefix: String = "https://image.tmdb.org/t/p/original"
}
