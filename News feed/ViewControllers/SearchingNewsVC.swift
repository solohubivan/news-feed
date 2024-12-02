//
//  SearchingNewsVC.swift
//  News feed
//
//  Created by Ivan Solohub on 02.12.2024.
//

import UIKit
import SnapKit

class SearchingNewsVC: UIViewController {
    
    private let titleLabel = UILabel()
    private let separateLine = UIView()
    private var searchTF = UITextField()
    private var resultTableView = UITableView()
    
    private var allCachedNews: [NewsItem] = []
    private var filteredNews: [NewsItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadCachedNews()
    }
    
    // MARK: - Private methods
    
    private func loadCachedNews() {
        allCachedNews = NewsItemsCacheManager.shared.loadAllFromCache()
    }
    
    private func removeDuplicatesAndSort(from newsItems: [NewsItem]) -> [NewsItem] {
        var uniqueItems = [NewsItem]()
        var seenTitles = Set<String>()
        
        for item in newsItems {
            if !seenTitles.contains(item.title) {
                uniqueItems.append(item)
                seenTitles.insert(item.title)
            }
        }
        uniqueItems.sort { $0.datePublished > $1.datePublished }
        return uniqueItems
    }
    
    private func showNoInternetAlertForNews() {
        let alert = AlertFactory.noInternetForNewsAlert()
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - TextField delegate

extension SearchingNewsVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && string == " " {
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let searchText = textField.text?.lowercased() ?? ""
        if searchText.isEmpty {
            filteredNews = removeDuplicatesAndSort(from: allCachedNews)
        } else {
            filteredNews = removeDuplicatesAndSort(from: allCachedNews.filter { newsItem in
                newsItem.title.lowercased().contains(searchText)
            })
        }
        resultTableView.reloadData()
    }
}

// MARK: - UITableView delegates

extension SearchingNewsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.Identifiers.newsFeedTableViewCellID, for: indexPath) as? NewsFeedTableViewCellCreator else {
            return UITableViewCell()
        }
        
        let newsItem = filteredNews[indexPath.row]
        cell.configure(with: newsItem, manager: NewsItemsCacheManager.shared)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if NetworkMonitor.shared.connectionMode == .offline {
            showNoInternetAlertForNews()
            return
        }
        
        let selectedNewsItem = filteredNews[indexPath.row]
        let vk = ShowOnSourceNewsItemVC()
        vk.configure(with: selectedNewsItem)
        vk.modalPresentationStyle = .fullScreen
        present(vk, animated: true)
    }
}

// MARK: Setup UI

extension SearchingNewsVC {
    private func setupUI() {
        view.backgroundColor = .greyBackGroundColor
        setupTitleLabel()
        setupSeparateLine()
        setupSearchTF()
        setupResultTableView()
        setupConstraints()
    }
    
    private func setupTitleLabel() {
        titleLabel.text = AppConstants.SearchingNewsVC.titleLabelText
        titleLabel.textColor = .newsTextColor
        titleLabel.font = .customFont(name: AppConstants.Fonts.poppinsRegular, size: 16, textStyle: .body)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
    }
    
    private func setupSeparateLine() {
        separateLine.backgroundColor = .lightGreyColor
        view.addSubview(separateLine)
    }
    
    private func setupSearchTF() {
        searchTF.delegate = self
        searchTF.clearButtonMode = .whileEditing
        searchTF.borderStyle = .none
        searchTF.layer.cornerRadius = 10
        searchTF.layer.backgroundColor = UIColor.lightGray.cgColor
        searchTF.font = .customFont(name: AppConstants.Fonts.poppinsRegular, size: 18, textStyle: .body)
        searchTF.adjustsFontForContentSizeCategory = true
        searchTF.placeholder = AppConstants.SearchingNewsVC.tFPlaceholderText
        searchTF.overrideUserInterfaceStyle = .light
        placeholderIndent()
        view.addSubview(searchTF)
    }
    
    private func placeholderIndent() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: Int(searchTF.frame.height)))
        searchTF.leftView = paddingView
        searchTF.leftViewMode = .always
    }
    
    private func setupResultTableView() {
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.register(NewsFeedTableViewCellCreator.self, forCellReuseIdentifier: AppConstants.Identifiers.newsFeedTableViewCellID)
        resultTableView.separatorStyle = .singleLine
        resultTableView.backgroundColor = .clear
        view.addSubview(resultTableView)
    }
    
    // MARK: - Setup constraints
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { maker in
            maker.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(16)
            maker.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-16)
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
        }
        
        separateLine.snp.makeConstraints { maker in
            maker.top.equalTo(titleLabel.snp.bottom).offset(11)
            maker.height.equalTo(1)
            maker.left.right.equalToSuperview()
        }
        
        searchTF.snp.makeConstraints { maker in
            maker.top.equalTo(separateLine.snp.bottom).offset(16)
            maker.left.equalToSuperview().offset(16)
            maker.right.equalToSuperview().offset(-16)
            maker.height.equalTo(40)
        }
        
        resultTableView.snp.makeConstraints { maker in
            maker.top.equalTo(searchTF.snp.bottom).offset(10)
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
    }
}
