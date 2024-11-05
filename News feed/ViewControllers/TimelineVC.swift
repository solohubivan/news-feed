//
//  TimelineVC.swift
//  News feed
//
//  Created by Ivan Solohub on 16.10.2024.
//

import UIKit
import SnapKit

class TimelineVC: UIViewController {
    
    private var titleLabel = UILabel()
    private var separateLine = UIView()
    private var newsFeedTableView = UITableView()
    
    private let newsFeedCreator = NewsFeedCreator()
    private let newsItemsManager = NewsItemsManager()
    
//    треба тягнути данні з моделі замість того щоб юзать лишній масив
    private var newsItems: [NewsItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchAndDisplayNews()
    }
    
    // MARK: - Private methods
    
    private func fetchAndDisplayNews() {
        newsFeedCreator.fetchCombinedNews { [weak self] in
            DispatchQueue.main.async {
                self?.newsItems = self?.newsFeedCreator.getCombinedNewsItems() ?? []
                self?.newsFeedTableView.reloadData()
            }
        }
    }
}

// MARK: - UITableView delegates

extension TimelineVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedTableViewCell", for: indexPath) as? NewsFeedTableViewCellCreator else {
            return UITableViewCell()
        }
                
        let newsItem = newsItems[indexPath.row]
        cell.configure(with: newsItem, manager: newsItemsManager)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vk = ShowOnSourceNewsItemVC()
        let newsItem = newsItems[indexPath.row]
        vk.configure(with: newsItem)
        vk.modalPresentationStyle = .fullScreen
        present(vk, animated: true)
    }
}

// MARK: - Setup UI

extension TimelineVC {
    private func setupUI() {
        view.backgroundColor = .greyBackGroundColor
        setupTitleLabel()
        setupSeparateLine()
        setupNewsFeedTableView()
        setupConstraints()
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "Timeline"
        titleLabel.textColor = .newsTextColor
        titleLabel.font = UIFont(name: "Poppins-Regular", size: 16)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
    }
    
    private func setupSeparateLine() {
        separateLine.backgroundColor = .lightGreyColor
        view.addSubview(separateLine)
    }
    
    private func setupNewsFeedTableView() {
        newsFeedTableView.dataSource = self
        newsFeedTableView.delegate = self
        newsFeedTableView.register(NewsFeedTableViewCellCreator.self, forCellReuseIdentifier: "NewsFeedTableViewCell")
        newsFeedTableView.backgroundColor = .clear
        newsFeedTableView.separatorStyle = .singleLine
        newsFeedTableView.separatorColor = .lightGray
        view.addSubview(newsFeedTableView)
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
        
        newsFeedTableView.snp.makeConstraints { maker in
            maker.top.equalTo(separateLine.snp.bottom)
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
    }
}
