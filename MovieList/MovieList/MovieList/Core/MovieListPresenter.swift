//
//  MovieListPresenter.swift
//  MovieList
//
//  Created by Nato Egnatashvili on 3/25/21.
//

import UIKit

protocol MovieListPresenter {
    func viewDidLoad()
    func numberOfSections() -> Int
    func numberOfRows(numberOfRowsInSection section: Int) -> Int
    func getNibName(indexPath: IndexPath) -> String
    func configureCell(cell: MovieListConfigurable , indexPath: IndexPath)
    func getHeightForRow(indexPath: IndexPath) -> CGFloat
    func didSelectRow(at indexPath: IndexPath)
    func willDisplayRow(at indexPath: IndexPath)
    func searchedWithText(text: String)
    func searchCanceled()
    func reachedScroll()
}

protocol MovieListView : AnyObject{
    func registerNibs(cells: [String])
    func reloadData()
}
//presenter must have view as weak , because not happend retain cycle. profile models and allModels are for search and everything if i want model
// but cellModel are for every cell. I prefer not to have 3 types of cell , because in second controller i used this protocol . it is better that one cell can some manipulations.
class MovieListPresenterImpl: MovieListPresenter  {
    private var router: MovieListRouter?
    private weak var view: MovieListView?
    private var imageDispatchGroup = DispatchGroup()
    private var moviewIconDictionary = [Int64: UIImage]()
    private var movieInfo = [MovieInfo]()
    private var cellModels = [CellProtocol]()
    private var moviesWithoutFilter = [MovieInfo]()
    private var lastPageNumber: Int = 1
    private var isLoading: Bool = true
    init(view: MovieListView ,
            router: MovieListRouter) {
           self.view = view
           self.router = router
       }
    
    func viewDidLoad() {
        animationModels()
        getMoviePageWithList()
        view?.registerNibs(cells: ["MovieProfileTableCell" ])
        view?.reloadData()
    }
    
    func animationModels() {
        var animateModels = [CellProtocol]()
        for _ in 0...10 {
            animateModels.append(MovieCellModel(image: nil, movieName:  "", movieRating: "",  animate: true))
        }
        isLoading = true
        self.cellModels = animateModels
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.view?.reloadData()
        }
    }
    
    func getMoviePageWithList() {
        let net = Service.init()
        DispatchQueue.global(qos: .userInitiated).async{
            net.get(serviceMethod: .movieListRequest(pageNum: self.lastPageNumber ),
                    respType: MoviePageResponse.self) { (response : Status) in
            switch response{
            case let .success(movieList):
                guard let movieList = movieList as? MoviePageResponse else{ return}
                self.lastPageNumber = (movieList.page ?? 1) + 1
                print(movieList.page ?? -1)
                let currentMovieList = movieList.getMoviewInfos()
                self.movieInfo += currentMovieList
                self.moviesWithoutFilter = self.movieInfo
                self.fetchMoviePosters(currMovieInfo: currentMovieList)
                self.imageDispatchGroup.notify(queue: .global()) {
                    self.isLoading = false
                    self.fetchCellModels(lazyLoader: self.lastPageNumber > 2)
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
    
    func imageUrlByPoster(posterUrl: String)-> URL? {
        let prefix = "https://image.tmdb.org/t/p/original"
        return URL(string: prefix + posterUrl)
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
        self.cellModels = self.movieInfo.map({$0.getMovieCellModel(image: self.getImageFromDictionaryIfCan(id: $0.id))})
         self.reloadData()
 
    }
}

extension MovieListPresenterImpl{
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
        router?.didTapMovie(movieInfo: movieInfo[indexPath.row])
    }
    
    func getHeightForRow(indexPath: IndexPath) -> CGFloat {
        return cellModels[indexPath.row].height
    }
    
    func configureCell(cell: MovieListConfigurable, indexPath: IndexPath) {
        cell.configure(with: cellModels[indexPath.row])
    }
    
    func willDisplayRow(at indexPath: IndexPath) {
        if indexPath.row + 1 == cellModels.count && !isLoading{
            isLoading = true
            getMoviePageWithList()
        }
    }
    
    func reachedScroll() {
        if !isLoading{
            isLoading = true
            getMoviePageWithList()
        }
    }
}

extension MovieListPresenterImpl{
    func searchedWithText(text: String) {
        isLoading = !text.isEmpty
        movieInfo = text.isEmpty ? self.moviesWithoutFilter : moviesWithoutFilter.filter({$0.movieName.lowercased().contains(text.lowercased())})
        fetchCellModels()
    }
    
    func searchCanceled() {
        movieInfo = self.moviesWithoutFilter
        isLoading = false
        fetchCellModels()
    }
}


extension UIImage {
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }

    func compress(to kb: Int, allowedMargin: CGFloat = 0.2) -> Data {
        let bytes = kb * 1024
        var compression: CGFloat = 1.0
        let step: CGFloat = 0.05
        var holderImage = self
        var complete = false
        while(!complete) {
            if let data = holderImage.jpegData(compressionQuality: 1.0) {
                let ratio = data.count / bytes
                if data.count < Int(CGFloat(bytes) * (1 + allowedMargin)) {
                    complete = true
                    return data
                } else {
                    let multiplier:CGFloat = CGFloat((ratio / 5) + 1)
                    compression -= (step * multiplier)
                }
            }
            
            guard let newImage = holderImage.resized(withPercentage: compression) else { break }
            holderImage = newImage
        }
        return Data()
    }
}
