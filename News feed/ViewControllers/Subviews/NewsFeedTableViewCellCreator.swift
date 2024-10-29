//
//  NewsFeedTableViewCellCreator.swift
//  News feed
//
//  Created by Ivan Solohub on 27.10.2024.

import UIKit
import SnapKit

class NewsFeedTableViewCellCreator: UITableViewCell {
    
    private var sourceInfoLabel = UILabel()
    private var saveButton = UIButton(type: .custom)
    private var titleLabel = UILabel()
    private var posterImageView = UIImageView()
    
    private var posterImageViewHeightConstraint: Constraint?
    private var isSaved = false
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func toggleSaveState() {
        isSaved.toggle()
        updateSaveButtonUI()
    }
    
    // MARK: - Public Methods
    
    func configure(with newsItem: NewsItem) {
        let timeLeft = getTimeAgo(from: newsItem.datePublished)
        sourceInfoLabel.text = "\(newsItem.sourceName) • \(timeLeft)"
        
        isSaved = newsItem.isSaved
        updateSaveButtonUI()
        
        titleLabel.text = newsItem.title
        
        if let imageUrl = URL(string: newsItem.imageUrl), !newsItem.imageUrl.isEmpty {
            loadImage(from: imageUrl)
            setPosterImageViewVisibility(isVisible: true)
        } else {
            setPosterImageViewVisibility(isVisible: false)
        }
    }
    
    // MARK: - Private Methods
    
    private func loadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return } 
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    self.posterImageView.image = image
                } else {
                    self.posterImageView.image = UIImage(named: "placeholder_image")
                }
            }
        }
        task.resume()
    }
    
    private func setPosterImageViewVisibility(isVisible: Bool) {
        posterImageView.isHidden = !isVisible
        posterImageViewHeightConstraint?.update(offset: isVisible ? 300 : 0)
    }
    
    private func getTimeAgo(from publishedDate: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute, .hour, .day, .weekOfYear, .month, .year], from: publishedDate, to: now)
        
        if let year = components.year, year > 0 {
            return "\(year) year\(year > 1 ? "s" : "") ago"
        } else if let month = components.month, month > 0 {
            return "\(month) month\(month > 1 ? "s" : "") ago"
        } else if let week = components.weekOfYear, week > 0 {
            return "\(week) week\(week > 1 ? "s" : "") ago"
        } else if let day = components.day, day > 0 {
            return "\(day) day\(day > 1 ? "s" : "") ago"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour) hour\(hour > 1 ? "s" : "") ago"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute) min\(minute > 1 ? "s" : "") ago"
        } else {
            return "Just now"
        }
    }
 
    private func updateSaveButtonUI() {
        saveButton.tintColor = isSaved ? .red : .lightGreyColor
    }
}

// MARK: - Setup UI

extension NewsFeedTableViewCellCreator {
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        setupSourceInfoLabel()
        setupSaveButton()
        setupTitleLabel()
        setupPosterImageView()
        setupConstraints()
        contentView.bringSubviewToFront(saveButton)
    }
    
    private func setupSourceInfoLabel() {
        sourceInfoLabel.textColor = .lightGreyColor
        sourceInfoLabel.font = UIFont(name: "Poppins-Light", size: 12)
        sourceInfoLabel.textAlignment = .left
        sourceInfoLabel.numberOfLines = 1
        contentView.addSubview(sourceInfoLabel)
    }
    
    private func setupSaveButton() {
        let buttonImage = UIImage(systemName: "bookmark")
        saveButton.setImage(buttonImage, for: .normal)
        saveButton.imageView?.contentMode = .scaleAspectFit
        saveButton.tintColor = .lightGreyColor
        saveButton.isUserInteractionEnabled = true
        saveButton.addTarget(self, action: #selector(toggleSaveState), for: .touchUpInside)
        contentView.addSubview(saveButton)
    }
    
    private func setupTitleLabel() {
        titleLabel.textColor = .newsTextColor
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.font = UIFont(name: "Poppins-SemiBold", size: 24)
        contentView.addSubview(titleLabel)
    }
    
    private func setupPosterImageView() {
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        contentView.addSubview(posterImageView)
    }
    
    // MARK: - Setup constraints
    
    private func setupConstraints() {
        sourceInfoLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(20)
            maker.left.equalTo(self.safeAreaLayoutGuide.snp.left).offset(16)
        }
        
        saveButton.snp.makeConstraints { maker in
            maker.centerY.equalTo(sourceInfoLabel)
            maker.right.equalTo(self.safeAreaLayoutGuide.snp.right).offset(-16)
        }
        
        titleLabel.snp.makeConstraints { maker in
            maker.top.equalTo(sourceInfoLabel.snp.bottom).offset(20)
            maker.left.equalTo(self.safeAreaLayoutGuide.snp.left).offset(16)
            maker.right.equalTo(self.safeAreaLayoutGuide.snp.right).offset(-16)
        }
        
        posterImageView.snp.makeConstraints { maker in
            maker.top.equalTo(titleLabel.snp.bottom).offset(5)
            maker.left.equalTo(self.safeAreaLayoutGuide.snp.left)
            maker.right.equalTo(self.safeAreaLayoutGuide.snp.right)
            posterImageViewHeightConstraint = maker.height.equalTo(300).constraint
            maker.bottom.equalToSuperview().priority(.medium)
        }
    }
}
