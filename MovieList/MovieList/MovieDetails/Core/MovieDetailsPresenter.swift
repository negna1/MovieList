//
//  MovieDetailsPresenter.swift
//  MovieList
//
//  Created by Nato Egnatashvili on 3/26/21.
//

import UIKit

protocol MovieDetailsPresenter {
    func viewDidLoad()
    func numberOfSections() -> Int
    func numberOfRows(numberOfRowsInSection section: Int) -> Int
    func getNibName(indexPath: IndexPath) -> String
    func configureCell(cell: MovieListConfigurable , indexPath: IndexPath)
    func getHeightForRow(indexPath: IndexPath) -> CGFloat
    func didTapHomePage()
}

protocol MovieDetailsView : AnyObject{
    func reloadData()
}


class MovieDetailsPresenterImpl: MovieDetailsPresenter  {
    private var router: MovieDetailsRouter?
    private weak var view: MovieDetailsView?
    private var movieInfo: MovieInfo
    private var cellModels = [CellProtocol]() {
        didSet {
            self.reloadData()
        }
    }
    private var mainImage: UIImage!
    private var imageDispatchGroup = DispatchGroup()
    private var similarMovies: [MovieInfo] = [MovieInfo]()
    private var moviewIconDictionary = [Int64: UIImage]()
    private let movieFactory = MovieDetailFactory()
    
    init(view: MovieDetailsView ,
         router: MovieDetailsRouter ,
         movieInfo: MovieInfo) {
        self.view = view
        self.router = router
        self.movieInfo = movieInfo
    }
    
    func viewDidLoad() {
        animationModels()
        getImages (url: imageUrlByPoster(posterUrl: self.movieInfo.imageName))
        self.getMoviePageWithList()
    }
    
    func animationModels() {
        cellModels.append(movieFactory.getMovieDetailModelWithType(type: .detailsAnimate, info: movieInfo ))
        cellModels.append(movieFactory.getMovieDetailModelWithType(type: .overview, info: movieInfo, image: mainImage))
        cellModels.append(movieFactory.getMovieDetailModelWithType(type: .similarMoviesWithAnimation ))
    }
    
    func reloadLoadedPoster() {
        cellModels[MovieDetailFactory.movieDetailType.details.rawValue] = MovieDetailFactory().getMovieDetailModelWithType(type: .details, info: movieInfo, image: mainImage)
      
    }
    
    func imageUrlByPoster(posterUrl: String)-> URL? {
        let prefix = MovieDetailsConstants.posterPrefix
        return URL(string: prefix + posterUrl)
    }
    
    func notLoadedMainPoster() {
        self.cellModels[MovieDetailFactory.movieDetailType.details.rawValue] = MovieDetailFactory().getMovieDetailModelWithType(type: .detailsImageErrored)
    }
    
    func getImages( url: URL?) {
        guard let url = url else {return}
        Service().getImages(url: url) {result in
            guard let result = result else{
                self.notLoadedMainPoster()
                return
            }
            self.mainImage =  UIImage(data: result) ?? UIImage()
            self.reloadLoadedPoster()
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.view?.reloadData()
        }
    }
    
    func getMoviePageWithList() {
        let net = Service.init()
        DispatchQueue.global(qos: .userInitiated).async{
            net.get(serviceMethod: .similarMoviesRequest(movieId: self.movieInfo.id, pageNum: 1),
                    respType: MoviePageResponse.self) { (response : Status) in
                switch response{
                case let .success(movieList):
                    guard let movieList = movieList as? MoviePageResponse else{ return}
                    self.fetchSimilarMoviesSuccess(movieList: movieList)
                case let  .fail(err):
                    self.errorHandle(error: err)
                }
            }
        }
    }
    
    func errorHandle(error: ErrorType) {
        switch error {
        case .internetConnection:
            cellModels[MovieDetailFactory.movieDetailType.similarMovies.rawValue]  = ErrorCellModel.init(errorText: MovieDetailsConstants.Messages.internetLost)
        case .notHaveData:
            cellModels[MovieDetailFactory.movieDetailType.similarMovies.rawValue]   = ErrorCellModel.init(errorText: MovieDetailsConstants.Messages.notHaveData)
        }
    }
    
    func fetchSimilarMoviesSuccess(movieList: MoviePageResponse) {
        self.similarMovies = movieList.getMoviewInfos()
        self.fetchMoviePosters(currMovieInfo:  self.similarMovies)
        self.imageDispatchGroup.notify(queue: .global()) {
            self.fetchCellModels()
        }
    }
    
    func fetchMoviePosters(currMovieInfo: [MovieInfo]) {
        currMovieInfo.forEach({getImages(id: $0.id , url: imageUrlByPoster(posterUrl: $0.imageName) )})
    }

    func notLoadedSimilarMovies() {
        self.cellModels[MovieDetailFactory.movieDetailType.similarMovies.rawValue] = MovieDetailFactory().getMovieDetailModelWithType(type: .similarMoviesImagesErrored,  movies: [])
    }
    
    func getImages(id: Int64 , url: URL?) {
        guard let url = url else {return}
        imageDispatchGroup.enter()
        Service().getImages(url: url) {result in
            guard let result = result else{
                self.notLoadedSimilarMovies()
                return
            }
            let reduced =  (UIImage(data: result) ?? UIImage()).compress(to: 100)
            self.moviewIconDictionary[id] = UIImage(data: reduced)
            self.imageDispatchGroup.leave()
        }
    }
    
    func getImageFromDictionaryIfCan(id: Int64) -> UIImage {
        if self.moviewIconDictionary.keys.contains(id) {
            return self.moviewIconDictionary[id] ?? UIImage()
        }
        return UIImage()
    }
    
    func fetchCellModels() {
        let collectionCellModels = similarMovies.map({$0.getCollectionCellModel(image: self.getImageFromDictionaryIfCan(id: $0.id)) })
        cellModels[MovieDetailFactory.movieDetailType.similarMovies.rawValue] = MovieDetailFactory().getMovieDetailModelWithType(type: .similarMovies, delegate: self, movies: collectionCellModels)
    }
}
/**
**Table View Methods**
 */
extension MovieDetailsPresenterImpl{
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows(numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    func getNibName(indexPath: IndexPath) -> String {
        return cellModels[indexPath.row].nibIdentifier
    }
    
    func getHeightForRow(indexPath: IndexPath) -> CGFloat {
        return cellModels[indexPath.row].height
    }
    
    func configureCell(cell: MovieListConfigurable, indexPath: IndexPath) {
        cell.configure(with: cellModels[indexPath.row])
    }
}
/**
**Collection item is tapped**
 */

extension MovieDetailsPresenterImpl: CollectionGestureDelegate {
    func didTapIdex(at index: Int) {
        router?.didTapMovie(movieInfo: similarMovies[index])
    }
    
    func didTapHomePage() {
        router?.moveToHomePage()
    }
}
