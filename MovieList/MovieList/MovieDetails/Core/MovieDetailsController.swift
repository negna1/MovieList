//
//  MovieDetailsController.swift
//  MovieList
//
//  Created by Nato Egnatashvili on 3/26/21.
//

import UIKit

class MovieDetailsController: UIViewController , MovieDetailsView{
    @IBOutlet weak var tableView: UITableView!
    var detailPresenter: MovieDetailsPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        registerNibs()
        rightNavigationButton()
        self.detailPresenter.viewDidLoad()
        
    }
    
    func rightNavigationButton() {
        let navItem = self.navigationItem
        navItem.rightBarButtonItem = UIBarButtonItem.init(title: "HOME", style: .done, target: self, action: #selector(addTapped))
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }

    @objc func addTapped() {
        detailPresenter.didTapHomePage()
    }
    
    func registerNibs() {
        let cells = MovieDetailsConstants.Cells
        cells.forEach({  self.tableView.register(UINib.init(nibName: $0, bundle: nil), forCellReuseIdentifier: $0)})
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    static func xibInstance(movieDetails: MovieInfo ) -> MovieDetailsController {
        let vc = MovieDetailsController.init()
        let configurator = MovieDetailsConfiguratorImpl()
        configurator.configure(vc: vc, movieInfo: movieDetails)
        return vc
    }
}

extension MovieDetailsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        detailPresenter.getHeightForRow(indexPath: indexPath)
    }
}

extension MovieDetailsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailPresenter.numberOfRows(numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: detailPresenter.getNibName(indexPath: indexPath)) as? MovieListConfigurable else {return UITableViewCell()}
        detailPresenter.configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
}
