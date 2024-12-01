//
//  NewsFeedTableViewCellCreator.swift
//  News feed
//
//  Created by Ivan Solohub on 27.10.2024.

import UIKit
import SnapKit
import Alamofire

class NewsFeedTableViewCellCreator: UITableViewCell {
    
    private var sourceInfoLabel = UILabel()
    private var saveButton = UIButton(type: .custom)
    private var titleLabel = UILabel()
    private var posterImageView = UIImageView()
    
    private var newsItem: NewsItem?
    private var manager: NewsItemsCacheManager?
    
    private var imageLoadIdentifier: String?
    private var posterImageViewHeightConstraint: Constraint?
    private var isSaved = false
    
    var onSaveStateChanged: (() -> Void)?
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func toggleSaveState() {
        guard let newsItem = newsItem else { return }
        isSaved.toggle()
        updateSaveButtonUI()
        
        if isSaved {
            manager?.saveNewsItem(newsItem)
        } else {
            manager?.deleteNewsItem(newsItem)
        }
        
        onSaveStateChanged?()
    }
    
    // MARK: - Public Methods
    
//    func configure(with newsItem: NewsItem, manager: NewsItemsCacheManager) {
//        self.newsItem = newsItem
//        self.manager = manager
//        
//        let timeLeft = getTimeAgo(from: newsItem.datePublished)
//        sourceInfoLabel.text = "\(newsItem.sourceName) • \(timeLeft)"
//
//        isSaved = manager.isNewsItemSaved(newsItem)
//        updateSaveButtonUI()
//        
//        titleLabel.text = newsItem.title
//        
//        if let imageUrlString = newsItem.imageUrl, let imageUrl = URL(string: imageUrlString) {
//            imageLoadIdentifier = imageUrlString
//            loadImage(from: imageUrl)
//            setPosterImageViewVisibility(isVisible: true)
//            
//        } else {
//            imageLoadIdentifier = nil
//            posterImageView.image = nil
//            setPosterImageViewVisibility(isVisible: false)
//        }
//    }
    func configure(with newsItem: NewsItem, manager: NewsItemsCacheManager) {
        self.newsItem = newsItem
        self.manager = manager

        // Оновлення джерела та часу публікації
        let timeLeft = getTimeAgo(from: newsItem.datePublished)
        sourceInfoLabel.text = "\(newsItem.sourceName) • \(timeLeft)"

        // Оновлення стану кнопки збереження
        isSaved = manager.isNewsItemSaved(newsItem)
        updateSaveButtonUI()

        // Відображення заголовка новини
        titleLabel.text = newsItem.title

        // Логіка відображення зображення
        if let imageData = newsItem.imageData, let image = UIImage(data: imageData) {
            // Якщо є збережене зображення
            posterImageView.image = image
            setPosterImageViewVisibility(isVisible: true)
        } else if let imageUrlString = newsItem.imageUrl, let imageUrl = URL(string: imageUrlString) {
            // Якщо збереженого зображення немає, але є URL
            imageLoadIdentifier = imageUrlString
            loadImage(from: imageUrl)
            setPosterImageViewVisibility(isVisible: true)
        } else {
            // Якщо немає ні збереженого зображення, ні URL
            imageLoadIdentifier = nil
            posterImageView.image = nil
            setPosterImageViewVisibility(isVisible: false)
        }
    }
    
    func configureSavedNewsCell(with newsItem: NewsItem, manager: NewsItemsCacheManager) {
        self.newsItem = newsItem
        self.manager = manager
        
        let timeLeft = getTimeAgo(from: newsItem.datePublished)
        sourceInfoLabel.text = "\(newsItem.sourceName) • \(timeLeft)"

        isSaved = manager.isNewsItemSaved(newsItem)
        updateSaveButtonUI()
        
        titleLabel.text = newsItem.title
        
        setPosterImageViewVisibility(isVisible: false)
    }
    
    func updateSaveButtonUI() {
        let buttonImage = isSaved ? UIImage(named: "bookmarkSelected") : UIImage(named: "bookmark")
        saveButton.setImage(buttonImage, for: .normal)
    }
    
    // MARK: - Private Methods
    
//    private func loadImage(from url: URL) {
//        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
//            guard let self = self, error == nil, let data = data, let image = UIImage(data: data) else { return }
//            DispatchQueue.main.async {
//                if self.imageLoadIdentifier == url.absoluteString {
//                    self.posterImageView.image = image
//                }
//            }
//        }
//        task.resume()
//    }
    private func loadImage(from url: URL) {
        imageLoadIdentifier = url.absoluteString

        AF.request(url).responseData { [weak self] response in
            guard let self = self else { return }

            switch response.result {
            case .success(let data):
                if self.imageLoadIdentifier == url.absoluteString, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.posterImageView.image = image
                    }
                }
            case .failure(let error):
                print("Failed to load image: \(error.localizedDescription)")
            }
        }
    }
    
    private func setPosterImageViewVisibility(isVisible: Bool) {
        posterImageView.isHidden = !isVisible
        posterImageViewHeightConstraint?.update(offset: isVisible ? 300 : 0)
    }
    
    private func getTimeAgo(from publishedDate: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute], from: publishedDate, to: now)
        
        switch components {
        case let comp where comp.year ?? 0 > 0:
            let years = comp.year!
            return "\(years) year\(years > 1 ? "s" : "") ago"
            
        case let comp where comp.month ?? 0 > 0:
            let months = comp.month!
            return "\(months) month\(months > 1 ? "s" : "") ago"
            
        case let comp where comp.weekOfYear ?? 0 > 0:
            let weeks = comp.weekOfYear!
            return "\(weeks) week\(weeks > 1 ? "s" : "") ago"
            
        case let comp where comp.day ?? 0 > 0:
            let days = comp.day!
            return "\(days) day\(days > 1 ? "s" : "") ago"
            
        case let comp where comp.hour ?? 0 > 0:
            let hours = comp.hour!
            return "\(hours) hour\(hours > 1 ? "s" : "") ago"
            
        case let comp where comp.minute ?? 0 > 0:
            let minutes = comp.minute!
            return "\(minutes) min\(minutes > 1 ? "s" : "") ago"
            
        default:
            return "Just now"
        }
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
        let buttonImage = UIImage(named: "bookmark")
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
