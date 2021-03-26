//
//  ServiceTypes.swift
//  MovieList
//
//  Created by Nato Egnatashvili on 3/25/21.
//

import UIKit

struct MovieListResponse: Decodable {
    var id: Int64?
    var poster_path: String?
    var popularity: Double?
    var backdrop_path: String?
    var vote_average: Double?
    var overview: String?
    var first_air_date: String?
    var origin_country: [String]?
    var genre_ids: [Int]?
    var original_language: String?
    var vote_count: Int?
    var name: String?
    var original_name: String?
    var total_results: String?
    var total_pages: Int?
}

struct MoviePageResponse : Decodable{
    var page: Int?
    var results: [MovieListResponse]?
    var total_pages: Int?
    var total_results: Int?
}

struct MovieInfo {
    var id: Int64
    var imageName: String
    var movieName: String
    var avarageRate: Double
    var raterCount: Int
    var overview: String
}

extension MoviePageResponse {
    func getMoviewInfos() -> [MovieInfo] {
        guard let results = self.results else {return []}
        return results.map({MovieInfo.init(id: $0.id ?? -1 ,
                                           imageName: $0.poster_path ?? "",
                                    movieName: $0.name ?? "",
                                    avarageRate: $0.vote_average ?? 0.0,
                                    raterCount: $0.vote_count ?? 0,
                                    overview: $0.overview ?? "")})
    }
}

extension MovieInfo {
    func getMovieCellModel(image: UIImage?) -> MovieCellModel{
        MovieCellModel(image: image, movieName: self.movieName, movieRating: self.avarageRate.description, animate: false)
    }
    
    func getCollectionCellModel(image: UIImage?) -> CollectionMovieCellModel {
        CollectionMovieCellModel(image: image, movieName: self.movieName, movieRating: self.avarageRate.description, animate: false)
    }
}
