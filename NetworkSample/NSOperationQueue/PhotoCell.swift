//
// PhotoCell.swift
//
// Created by Ben for NetworkSample on 2021/4/16.
// Copyright © 2021 Alien. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    var dobe: Int? = nil
    lazy var imageView: UIImageView = {
        let imageV = UIImageView(frame: .zero)
        contentView.addSubview(imageV)
        return imageV
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        imageView.frame = contentView.bounds
        dobe = .none
    }
}
