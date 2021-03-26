//
//  MovieOverviewTableCell.swift
//  MovieList
//
//  Created by Nato Egnatashvili on 3/26/21.
//

import UIKit

class MovieOverviewTableCell: UITableViewCell ,   MovieListConfigurable {
    @IBOutlet weak var overView: UILabel!
    
    func configure(with model: CellProtocol) {
        if let model = model as?  MovieOverViewModel {
            self.overView.text = model.overView
        }
    }
    
}
