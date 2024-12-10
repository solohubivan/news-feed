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
        comingSoonLabel.accessibilityIdentifier = AppConstants.ObjectsIdentifiers.mockLabelId
        comingSoonLabel.text = AppConstants.NotificationsVC.comingSoonLabelText
        comingSoonLabel.textColor = .newsTextColor
        comingSoonLabel.font = .customFont(name: AppConstants.Fonts.poppinsSemiBold, size: 24, textStyle: .title1)
        comingSoonLabel.adjustsFontForContentSizeCategory = true
        comingSoonLabel.textAlignment = .center
        view.addSubview(comingSoonLabel)
    }
    
    private func setupWrenchImageView() {
        wrenchImageView.image = UIImage(systemName: AppConstants.ImagesNames.wrenchFill)
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
