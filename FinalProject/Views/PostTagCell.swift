//
//  PostTagCell.swift
//  FinalProject
//
//  Created by salha asyri on 22/05/1443 AH.
//

import UIKit

class PostTagCell: UICollectionViewCell {
    
    @IBOutlet weak var tagNameLabel: UILabel!
    @IBOutlet weak var backView: UIView!{
        didSet{
            backView.layer.cornerRadius = 8
        }
    }
}
