//
//  NewsFeedCollectionCellCreator.swift
//  News feed
//
//  Created by Ivan Solohub on 18.10.2024.
//

import UIKit
import SnapKit

class NewsFeedCollectionCell: UICollectionViewCell {
    
    private var sourceInfoLabel = UILabel()
    private var saveButton = UIButton(type: .custom)
    private var titleLabel = UILabel()
    private var posterImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupCellUI() {
        self.backgroundColor = .clear
        setupSourceInfoLabel()
        setupSaveButton()
        setupTitleLabel()
        setupPosterImageView()
    }
    
    private func setupSourceInfoLabel() {
        sourceInfoLabel.textColor = .lightGreyColor
        sourceInfoLabel.font = UIFont(name: "Poppins-Light", size: 12)
        sourceInfoLabel.textAlignment = .left
        sourceInfoLabel.numberOfLines = 1
        sourceInfoLabel.text = "habr * 1 hours ago"
        self.addSubview(sourceInfoLabel)
        sourceInfoLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(20)
            maker.left.equalTo(self.safeAreaLayoutGuide.snp.left).offset(16)
        }
    }
    
    private func setupSaveButton() {
        let buttonImage = UIImage(systemName: "bookmark")
        saveButton.setImage(buttonImage, for: .normal)
        saveButton.imageView?.contentMode = .scaleAspectFit
        saveButton.tintColor = .lightGreyColor
        self.addSubview(saveButton)
        saveButton.snp.makeConstraints { maker in
            maker.centerY.equalTo(sourceInfoLabel)
            maker.right.equalTo(self.safeAreaLayoutGuide.snp.right).offset(-16)
        }
    }
    
    private func setupTitleLabel() {
        titleLabel.textColor = .newsTextColor
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.text = "FOSS News #72 - дайджест материалов о свободном и открітом ПО за 24-30 мая 2021 года"
        titleLabel.font = UIFont(name: "Poppins-SemiBold", size: 24)
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { maker in
            maker.top.equalTo(sourceInfoLabel).offset(20)
            maker.left.equalTo(self.safeAreaLayoutGuide.snp.left).offset(16)
            maker.right.equalTo(self.safeAreaLayoutGuide.snp.right).offset(-16)
            maker.height.equalTo(150)
        }
    }
    
    private func setupPosterImageView() {
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.image = UIImage(named: "poster")
        
        self.addSubview(posterImageView)
        posterImageView.snp.makeConstraints { maker in
            maker.top.equalTo(titleLabel.snp.bottom).offset(5)
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
    }
}
