//
//  MonitorCollectionViewCell.swift
//  IosiApp
//
//  Created by aluno001 on 10/03/21.
//

import UIKit

class MonitorCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    func setup() {
        photo.layer.cornerRadius = photo.frame.height / 2
    }
    override func prepareForReuse() {
        photo.layer.cornerRadius = photo.frame.height / 2
    }
}
