//
//  MovieListController.swift
//  MovieList
//
//  Created by Nato Egnatashvili on 3/25/21.
//

import UIKit


class MovieListController: UIViewController , MovieListView{
    var moviePresenter: MovieListPresenter!
    @IBOutlet weak var tableView: UITableView!
    lazy var searchBar = UISearchBar(frame: .zero)
    private var needConfigure = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleSearchBar()
        configurationIfNeeded()
        setTableViewDataSourceAndDelegate()
        moviePresenter.viewDidLoad()
        
    }
    
    func styleSearchBar() {
        searchBar.placeholder = "Search"
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }
    
    func configurationIfNeeded() {
        if needConfigure {
            configureVc()
            needConfigure = false
        }
    }

    func setTableViewDataSourceAndDelegate() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func registerNibs(cells: [String]) {
        cells.forEach({  self.tableView.register(UINib.init(nibName: $0, bundle: nil), forCellReuseIdentifier: $0)})
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func configureVc() {
        let configurator = MovieListConfiguratorImpl()
        configurator.configure(vc: self)
    }
    
}
//I dont need section so not override it func.
extension MovieListController: UITableViewDelegate {
    
}

extension MovieListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviePresenter.numberOfRows(numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: moviePresenter.getNibName(indexPath: indexPath)) as? MovieListConfigurable else {return UITableViewCell()}
        moviePresenter.configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        moviePresenter.getHeightForRow(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        moviePresenter.didSelectRow(at: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            moviePresenter.reachedScroll()
        }
    }
}

extension MovieListController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        moviePresenter.searchedWithText(text: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        moviePresenter.searchCanceled()
    }
}
