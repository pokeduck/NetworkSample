//
// GitHubAuthTopView.swift
//
// Created by Ben for NetworkSample on 2021/1/27.
// Copyright © 2021 Alien. All rights reserved.
//

import SnapKit
import UIKit

class GitHubAuthTopView: UIView {
    private(set) lazy var cancelBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Cancel", for: .normal)
        addSubview(btn)
        btn.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
        }
        return btn
    }()

    private(set) lazy var titleLabel: UILabel = {
        let l = UILabel()
        addSubview(l)
        l.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.centerX.equalToSuperview()
//            make.top.equalTo(safeAreaLayoutGuide.snp.top)
//            make.bottom.equalToSuperview()
        }
        l.backgroundColor = .blue
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .green
        _ = titleLabel
        _ = cancelBtn
        titleLabel.text = "A"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
