//
//  ErrorViewCell.swift
//  MovieList
//
//  Created by Nato Egnatashvili on 3/26/21.
//

import UIKit

class ErrorViewCell: UITableViewCell, MovieListConfigurable {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var errorText: UILabel!
    
    
    func configure(with model: CellProtocol) {
        if let model = model as? ErrorCellModel {
            img.image = #imageLiteral(resourceName: "ic_error").withTintColor(#colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1))
            errorText.text = model.errorText
        }
    }
    
}
