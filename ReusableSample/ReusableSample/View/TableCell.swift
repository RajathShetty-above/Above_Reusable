//
//  TableCell.swift
//  UnitTestSample
//
//  Created by Rajath Shetty on 25/02/16.
//  Copyright © 2016 Above Solution. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
    }
    
    func configureCellWithNews(news: News) {
        titleLabel.text = news.title
        contentsLabel.text = news.content
    }
    
    
}
