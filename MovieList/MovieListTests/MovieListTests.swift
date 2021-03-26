//
//  MovieListTests.swift
//  MovieListTests
//
//  Created by Nato Egnatashvili on 3/26/21.
//

import XCTest
@testable import MovieList

class MovieListTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}

/**
**MovieListPresenter mock**
It is main presenter class for moovie list. it must have several methods in protocol. so I must check if every methods are calling and if they return something if they are right
 */

class MovieListPresenterMock: MovieListPresenter {
    private var cellmodels = [MovieCellModel(image: nil, movieName:  "", movieRating: "",  animate: true)]
    
    private(set) var viewLoadedCalled = false
    func viewDidLoad() {
        viewLoadedCalled = true
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows(numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    private(set) var nibNameCalled = false
    func getNibName(indexPath: IndexPath) -> String {
        nibNameCalled = true
        return "MovieProfileTableCell"
    }
    private(set) var configureCellCalled = false
    func configureCell(cell: MovieListConfigurable, indexPath: IndexPath) {
        configureCellCalled = true
    }
    
    func getHeightForRow(indexPath: IndexPath) -> CGFloat {
        return 100
    }
    private(set) var didSelectRowCalled = false
    func didSelectRow(at indexPath: IndexPath) {
        didSelectRowCalled = true
    }
    
    private(set) var searchedWithTextCalled = false
    func searchedWithText(text: String) {
        searchedWithTextCalled = true
    }
    private(set) var searchCanceledCalled = false
    func searchCanceled() {
        searchCanceledCalled = true
    }
    private(set) var reachedScrollCalled = false
    func reachedScroll() {
        reachedScrollCalled = true
    }
}

class MovieListControllerTests: XCTestCase {
    let presenter = MovieListPresenterMock()
    
    func makeSUT() -> MovieListController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sut = storyboard.instantiateViewController(identifier: "MovieListController") as! MovieListController
        
        sut.loadViewIfNeeded()
        return sut
    }
    
    func testViewDidLoadCallsPresenter() {
        let sut = makeSUT()
        sut.moviePresenter = presenter
        sut.viewDidLoad()
        XCTAssertTrue(presenter.viewLoadedCalled)
    }

    func testOnEditCallsPresenter() {
        let sut = makeSUT()
        sut.moviePresenter = presenter
        let num = sut.tableView(UITableView(), numberOfRowsInSection: 1)
        XCTAssertTrue(presenter.numberOfSections() == num)
    }

    func testOnGetNibName()  {
        let sut = makeSUT()
        sut.moviePresenter = presenter
        let _ = sut.tableView(UITableView(), cellForRowAt: .init())
        XCTAssertTrue(presenter.nibNameCalled)
    }

    func testOnConfigureCalled()  {
        let sut = makeSUT()
        sut.moviePresenter = presenter
         sut.tableView.register(UINib.init(nibName: "MovieProfileTableCell", bundle: nil), forCellReuseIdentifier: "MovieProfileTableCell")
        let _ = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertTrue(presenter.configureCellCalled )
    }

    func testOnHeightForRow()  {
        let sut = makeSUT()
        sut.moviePresenter = presenter
        let indPath = IndexPath(row: 0, section: 0)
        let height = sut.tableView(.init(), heightForRowAt: indPath)
        XCTAssertTrue(presenter.getHeightForRow(indexPath: indPath) == height)
    }
    func didSelectRow(at indexPath: IndexPath) {
        let sut = makeSUT()
        sut.moviePresenter = presenter
        let _ = sut.tableView(.init(), didSelectRowAt: .init())
        XCTAssertTrue(presenter.didSelectRowCalled)
    }

    func testOnsearchedWithText() {
        let sut = makeSUT()
        sut.moviePresenter = presenter
        let _ = sut.searchBar(.init(), textDidChange: .init())
        XCTAssertTrue(presenter.searchedWithTextCalled)
    }

    func testOnsearchCanceled() {
        let sut = makeSUT()
        sut.moviePresenter = presenter
        let _ = sut.searchBarCancelButtonClicked(.init())
        XCTAssertTrue(presenter.searchCanceledCalled)
    }

    func onTestReachedScroll() {
        let sut = makeSUT()
        sut.moviePresenter = presenter
        let _ = sut.scrollViewDidScroll(.init())
        XCTAssertTrue(presenter.reachedScrollCalled)
    }
}

class MovieDetailsMock: MovieDetailsPresenter {
   
    
    private var cellmodels = [MovieCellModel(image: nil, movieName:  "", movieRating: "",  animate: true)]
    
    private(set) var viewLoadedCalled = false
    func viewDidLoad() {
        viewLoadedCalled = true
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows(numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    private(set) var nibNameCalled = false
    func getNibName(indexPath: IndexPath) -> String {
        nibNameCalled = true
        return "MovieProfileTableCell"
    }
    private(set) var configureCellCalled = false
    func configureCell(cell: MovieListConfigurable, indexPath: IndexPath) {
        configureCellCalled = true
    }
    
    func getHeightForRow(indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    private(set) var homeIsCalled = false
    func didTapHomePage() {
        homeIsCalled = true
    }
}

class MovieDetailsControllerTests: XCTestCase {
    let presenter = MovieDetailsMock()
    
    func makeSUT() -> MovieDetailsController {
        let sut = MovieDetailsController.xibInstance(movieDetails: MovieInfo.init(id: 1, imageName: "", movieName: "", avarageRate: 1, raterCount: 1, overview: ""))
        sut.detailPresenter = presenter
        sut.loadViewIfNeeded()
        return sut
    }
    
    func testViewDidLoadCallsPresenter() {
        let sut = makeSUT()
        sut.viewDidLoad()
        XCTAssertTrue(presenter.viewLoadedCalled)
    }

    func testOnEditCallsPresenter() {
        let sut = makeSUT()
        let num = sut.tableView(UITableView(), numberOfRowsInSection: 1)
        XCTAssertTrue(presenter.numberOfSections() == num)
    }

    func testOnGetNibName()  {
        let sut = makeSUT()
        let _ = sut.tableView(UITableView(), cellForRowAt: .init())
        XCTAssertTrue(presenter.nibNameCalled)
    }

    func testOnConfigureCalled()  {
        let sut = makeSUT()
         sut.tableView.register(UINib.init(nibName: "MovieProfileTableCell", bundle: nil), forCellReuseIdentifier: "MovieProfileTableCell")
        let _ = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertTrue(presenter.configureCellCalled )
    }

    func testOnHeightForRow()  {
        let sut = makeSUT()
        let indPath = IndexPath(row: 0, section: 0)
        let height = sut.tableView(.init(), heightForRowAt: indPath)
        XCTAssertTrue(presenter.getHeightForRow(indexPath: indPath) == height)
    }
    
    func testDidTapHome() {
        let sut = makeSUT()
        sut.addTapped()
        XCTAssertTrue(presenter.homeIsCalled)
    }
}

