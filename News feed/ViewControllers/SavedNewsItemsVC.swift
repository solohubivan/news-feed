//
//  SavedNewsItemsVC.swift
//  News feed
//
//  Created by Ivan Solohub on 05.11.2024.
//
import UIKit

class SavedNewsItemsVC: UIViewController {
    
    private var titleLabel = UILabel()
    private var separateLine = UIView()
    private var savedNewsItemsTableView = UITableView()
    private let refreshControl = UIRefreshControl()
    
    private let newsItemsManager = NewsItemsCacheManager.shared
    
    private var savedNewsItems: [NewsItem] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        savedNewsItems = newsItemsManager.getSavedItems()
        savedNewsItemsTableView.reloadData()
    }
    
    // MARK: - Actions
        
    @objc private func refreshTableView() {
        savedNewsItemsTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    // MARK: - Private methods
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        savedNewsItemsTableView.refreshControl = refreshControl
    }
    
    private func showNoInternetAlertForNews() {
        let alert = AlertFactory.noInternetForNewsAlert()
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableView delegates

extension SavedNewsItemsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsItemsManager.getSavedItems().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.Identifiers.newsFeedTableViewCellID, for: indexPath) as? NewsFeedTableViewCellCreator else {
            return UITableViewCell()
        }
        let newsItem = newsItemsManager.getSavedItems()[indexPath.row]
        cell.configureSavedNewsCell(with: newsItem, manager: newsItemsManager)
        
        cell.onSaveStateChanged = { [weak self] in
            self?.savedNewsItemsTableView.reloadData()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if NetworkMonitor.shared.connectionMode == .offline {
            showNoInternetAlertForNews()
            return
        }
        
        let vk = ShowOnSourceNewsItemVC()
        let newsItem = newsItemsManager.getSavedItems()[indexPath.row]
        vk.configure(with: newsItem)
        vk.modalPresentationStyle = .fullScreen
        present(vk, animated: true)
    }
}

// MARK: Setup UI

extension SavedNewsItemsVC {
    private func setupUI() {
        view.backgroundColor = .greyBackGroundColor
        setupTitleLabel()
        setupSeparateLine()
        setupNewsFeedTableView()
        setupConstraints()
    }
    
    private func setupTitleLabel() {
        titleLabel.accessibilityIdentifier = AppConstants.ObjectsIdentifiers.saveNewsItemsVCTitleLabelId
        titleLabel.text = AppConstants.SavedNewsItemsVC.titleLabelText
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
    
    private func setupNewsFeedTableView() {
        savedNewsItemsTableView.accessibilityIdentifier = AppConstants.ObjectsIdentifiers.saveNewsItemsVCTableViewId
        savedNewsItemsTableView.dataSource = self
        savedNewsItemsTableView.delegate = self
        savedNewsItemsTableView.register(NewsFeedTableViewCellCreator.self, forCellReuseIdentifier: AppConstants.Identifiers.newsFeedTableViewCellID)
        savedNewsItemsTableView.backgroundColor = .clear
        savedNewsItemsTableView.separatorStyle = .singleLine
        savedNewsItemsTableView.separatorColor = .lightGray
        view.addSubview(savedNewsItemsTableView)
    }
    
    // MARK: - Setup Constraints
    
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
        
        savedNewsItemsTableView.snp.makeConstraints { maker in
            maker.top.equalTo(separateLine.snp.bottom)
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
    }
}
