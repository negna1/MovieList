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
    func didSelectRow(at indexPath: IndexPath)
}

protocol MovieDetailsView : AnyObject{
    func registerNibs(cells: [String])
    func reloadData()
}
//presenter must have view as weak , because not happend retain cycle. profile models and allModels are for search and everything if i want model
// but cellModel are for every cell. I prefer not to have 3 types of cell , because in second controller i used this protocol . it is better that one cell can some manipulations.
class MovieDetailsPresenterImpl: MovieDetailsPresenter  {
    private var router: MovieDetailsRouter?
    private weak var view: MovieDetailsView?
    private var movieInfo: MovieInfo
    private var cellModels = [CellProtocol]()
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
        view?.registerNibs(cells: ["MovieOverviewTableCell" ,
                                   "MovieMainDetailsTableCell" ,
                                   "MovieProfileTableCell" ,
                                   "CollectionTableCell" ])
        animationModels()
        getImages (url: imageUrlByPoster(posterUrl: self.movieInfo.imageName))
        self.imageDispatchGroup.notify(queue: .global()) {
            self.getMoviePageWithList()
        }
    }
    
    func animationModels() {
        cellModels.append(movieFactory.getMovieDetailModelWithType(type: .detailsAnimate, info: movieInfo ))
        
        cellModels.append(movieFactory.getMovieDetailModelWithType(type: .overview, info: movieInfo, image: mainImage))
        cellModels.append(movieFactory.getMovieDetailModelWithType(type: .similarMoviesWithAnimation, info: movieInfo ))
       // self.cellModels = animateModels
        reloadData()
    }
    
    func makeModels() {
        cellModels[MovieDetailFactory.movieDetailType.details.rawValue] = MovieDetailFactory().getMovieDetailModelWithType(type: .details, info: movieInfo, image: mainImage)
        self.reloadData()
      
    }
    
    func imageUrlByPoster(posterUrl: String)-> URL? {
        let prefix = "https://image.tmdb.org/t/p/original"
        return URL(string: prefix + posterUrl)
    }

    func getImages( url: URL?) {
        guard let url = url else {return}
        let lock = NSLock()
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url){
                self.mainImage =  UIImage(data: data) ?? UIImage()
                self.makeModels()
            }
        }
        lock.unlock()
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
                print(movieList.page ?? -1)
                self.similarMovies = movieList.getMoviewInfos()
                self.fetchMoviePosters(currMovieInfo:  self.similarMovies)
                self.imageDispatchGroup.notify(queue: .global()) {
                    self.fetchCellModels(lazyLoader: false)
                }
            case let  .fail(err):
                print(err)
            }
        }
        }
    }
    
    func fetchMoviePosters(currMovieInfo: [MovieInfo]) {
        currMovieInfo.forEach({getImages(id: $0.id , url: imageUrlByPoster(posterUrl: $0.imageName) )})
    }

    func getImages(id: Int64 , url: URL?) {
        guard let url = url else {return}
        let lock = NSLock()
        imageDispatchGroup.enter()
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url){
                let reduced =  (UIImage(data: data) ?? UIImage()).compress(to: 100)
                self.moviewIconDictionary[id] = UIImage(data: reduced)
                self.imageDispatchGroup.leave()
            }
        }
        lock.unlock()
    }

    
    //I prefered to save all icons in dictionary and than get when it need.
    func getImageFromDictionaryIfCan(id: Int64) -> UIImage {
        if self.moviewIconDictionary.keys.contains(id) {
            return self.moviewIconDictionary[id] ?? UIImage()
        }
        return UIImage()
    }
    
    func fetchCellModels(lazyLoader: Bool = false) {
        let collectionCellModels = similarMovies.map({$0.getCollectionCellModel(image: self.getImageFromDictionaryIfCan(id: $0.id)) })
        cellModels[MovieDetailFactory.movieDetailType.similarMovies.rawValue] = MovieDetailFactory().getMovieDetailModelWithType(type: .similarMovies, info: movieInfo ,movies: collectionCellModels)
         self.reloadData()
 
    }
    
}

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
    
    func didSelectRow(at indexPath: IndexPath) {
        
    }
    
    func getHeightForRow(indexPath: IndexPath) -> CGFloat {
        return cellModels[indexPath.row].height
    }
    
    func configureCell(cell: MovieListConfigurable, indexPath: IndexPath) {
        cell.configure(with: cellModels[indexPath.row])
    }
}

