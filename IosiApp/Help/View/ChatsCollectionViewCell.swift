//
//  ChatsCollectionViewCell.swift
//  IosiApp
//
//  Created by aluno001 on 14/03/21.
//

import UIKit

class ChatsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var timeOfLastMessage: UILabel!
    @IBOutlet weak var lastMessages: UILabel!
    @IBOutlet weak var name: UILabel!
    func setup() {
        photo.layer.cornerRadius = photo.frame.height / 2
    }
    override func prepareForReuse() {
        photo.layer.cornerRadius = photo.frame.height / 2
    }
}
