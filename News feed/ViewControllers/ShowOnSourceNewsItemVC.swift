//
//  ShowFullNewsItemVC.swift
//  News feed
//
//  Created by Ivan Solohub on 30.10.2024.
//

import UIKit
import SnapKit
import WebKit

class ShowOnSourceNewsItemVC: UIViewController {
    
    private var backButton = UIButton()
    private var saveButton = UIButton()
    private var separateLine = UIView()
    private var webView = WKWebView()
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let newsItemsManager = NewsItemsCacheManager.shared
    private var newsItem: NewsItem?
    private var isSaved = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Public methods
    
    func configure(with newsItem: NewsItem) {
        self.newsItem = newsItem
        isSaved = newsItemsManager.isNewsItemSaved(newsItem)
        updateSaveButtonUI()
                
        if let url = URL(string: newsItem.sourceLink) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    // MARK: - Private methods
    
    private func updateSaveButtonUI() {
        let buttonImage = isSaved ? UIImage(named: AppConstants.ImagesNames.bookmarkSelected) : UIImage(named: AppConstants.ImagesNames.bookmark)
        saveButton.setImage(buttonImage, for: .normal)
    }
    
    // MARK: - Buttons actions
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        guard let newsItem = newsItem else { return }
        isSaved.toggle()

        if isSaved {
            newsItemsManager.saveNewsItem(newsItem)
        } else {
            newsItemsManager.deleteNewsItem(newsItem)
        }
            
        updateSaveButtonUI()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.backgroundColor = .greyBackGroundColor
        setupBackButton()
        setupSaveButton()
        setupSeparateLine()
        setupWebView()
        setupActivityIndicator()
        setupConstraints()
    }
    
    private func setupBackButton() {
        backButton.accessibilityIdentifier = AppConstants.ObjectsIdentifiers.backButtonArrowId
        backButton.setImage(UIImage(named: AppConstants.ImagesNames.backArrow), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        view.addSubview(backButton)
    }
    
    private func setupSaveButton() {
        saveButton.accessibilityIdentifier = AppConstants.ObjectsIdentifiers.saveButtonId
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.addSubview(saveButton)
    }
    
    private func setupSeparateLine() {
        separateLine.backgroundColor = .lightGreyColor
        view.addSubview(separateLine)
    }
    
    private func setupWebView() {
        webView.accessibilityIdentifier = AppConstants.ObjectsIdentifiers.webViewId
        webView.navigationDelegate = self
        webView.backgroundColor = .clear
        webView.alpha = 0
        webView.allowsBackForwardNavigationGestures = true
        view.addSubview(webView)
    }
    
    private func setupActivityIndicator() {
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    // MARK: - Setup constraints
    
    private func setupConstraints() {
        backButton.snp.makeConstraints { maker in
            maker.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(12)
            maker.height.width.equalTo(28)
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
        }
        
        saveButton.snp.makeConstraints { maker in
            maker.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-16)
            maker.height.width.equalTo(28)
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
        }
        
        separateLine.snp.makeConstraints { maker in
            maker.top.equalTo(backButton.snp.bottom).offset(11)
            maker.height.equalTo(1)
            maker.left.right.equalToSuperview()
        }
        
        webView.snp.makeConstraints { maker in
            maker.top.equalTo(separateLine.snp.bottom)
            maker.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        activityIndicator.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }
    }
}

// MARK: - WebView delegates

extension ShowOnSourceNewsItemVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
        webView.alpha = 0
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.alpha = 1
        activityIndicator.stopAnimating()
    }
}
