//
//  NotificationsVC.swift
//  News feed
//
//  Created by Ivan Solohub on 02.12.2024.
//

import UIKit
import SnapKit

class NotificationsVC: UIViewController {
    
    private let comingSoonLabel = UILabel()
    private let wrenchImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .greyBackGroundColor
        setupComingSoonLabel()
        setupWrenchImageView()
        setupConstraints()
    }
    
    private func setupComingSoonLabel() {
        comingSoonLabel.text = "Coming soon"
        comingSoonLabel.textColor = .newsTextColor
        comingSoonLabel.font = UIFont(name: "Poppins-SemiBold", size: 24)
        comingSoonLabel.textAlignment = .center
        view.addSubview(comingSoonLabel)
    }
    
    private func setupWrenchImageView() {
        wrenchImageView.image = UIImage(systemName: "wrench.fill")
        wrenchImageView.tintColor = .newsTextColor
        view.addSubview(wrenchImageView)
    }
        
    private func setupConstraints() {
        comingSoonLabel.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }
        
        wrenchImageView.snp.makeConstraints { maker in
            maker.centerY.equalTo(comingSoonLabel.snp.centerY)
            maker.left.equalTo(comingSoonLabel.snp.right).offset(8)
        }
    }
}
