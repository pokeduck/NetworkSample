//
// PhotosVC.swift
//
// Created by Ben for NetworkSample on 2021/4/16.
// Copyright © 2021 Alien. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher


class PhotosVC: UIViewController {
    
    var urls = [String]()
    
    lazy var cv : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let v = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.addSubview(v)
        v.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
        v.delegate = self
        v.dataSource = self
        v.register(cellWithClass: PhotoCell.self)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        urls = (0...10000).map { (index) -> String in
            randomPlcaholder(with: "Text:\(index)")
        }
        urls.forEach { (url) in
            ImageCache.default.removeImage(forKey: url)
        }
        
        print(urls)
        
        cv.reloadData()
        cv.setContentOffset(CGPoint(x: 0, y: cv.contentSize.height), animated: true)
    }
    
    
    
}

extension PhotosVC: UICollectionViewDelegate {
    
}

extension PhotosVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: PhotoCell.self, for: indexPath)
        cell.backgroundColor = .white
        let url = urls[indexPath.row]
        
        cell.imageView.kf.setImage(with: URL(string: url),options: [.forceRefresh])
        return cell
    }
    
    
}

extension PhotosVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor(UIScreen.main.bounds.width / 3) - 10
        return CGSize(width: width, height: width)
    }
}

fileprivate func randomPlcaholder(with text: String) -> String {
    //https://via.placeholder.com/150/0CC000/FFFFCC/?text=IPaddress.net
    let txtColor = UIColor.random.hexString.dropFirst(1)
    let bgColor = UIColor.random.hexString.dropFirst(1)
    return "https://via.placeholder.com/999/\(bgColor)/\(txtColor)/?text=\(text)"
}


