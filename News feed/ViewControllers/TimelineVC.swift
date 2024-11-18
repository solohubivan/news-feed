//
//  TimelineVC.swift
//  News feed
//
//  Created by Ivan Solohub on 16.10.2024.
//

import UIKit
import SnapKit
import GoogleMobileAds

class TimelineVC: UIViewController {
    
    private var titleLabel = UILabel()
    private var separateLine = UIView()
    private var newsFeedTableView = UITableView()
    private let refreshControl = UIRefreshControl()
    
    private let newsFeedCreator = NewsFeedCreator()
    private let newsItemsManager = NewsItemsManager.shared

    private var bannerView: GADBannerView?
    private var nativeAdLoader: GADAdLoader?
    private var nativeAd: GADNativeAd?
    private var interstitialAd: GADInterstitialAd?
    private var transitionCount = 0
    
    private var newsItems: [NewsItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchAndDisplayNews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        for (index, _) in newsItems.enumerated() {
            if let cell = newsFeedTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? NewsFeedTableViewCellCreator {
                cell.updateSaveButtonUI()
            }
        }
        newsFeedTableView.reloadData()
    }
    
    @objc private func refreshNews() {
        fetchAndDisplayNews()
    }
        
    // MARK: - Private methods
    
    private func fetchAndDisplayNews() {
        
        newsFeedCreator.fetchCombinedNews { [weak self] in
            DispatchQueue.main.async {
                self?.newsItems = self?.newsFeedCreator.getCombinedNewsItems() ?? []
                self?.newsFeedTableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }
    }
}

// MARK: - UITableView delegates

extension TimelineVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let adCount = newsItems.count / 10
        return newsItems.count + adCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 11 == 10, let nativeAd = nativeAd {
            guard let adCell = tableView.dequeueReusableCell(withIdentifier: "NativeAdTableViewCell", for: indexPath) as? NativeAdTableViewCell else {
                return UITableViewCell()
            }
            adCell.configureAd(with: nativeAd)
            return adCell
        }

        let newsIndex = indexPath.row - (indexPath.row / 11)
        guard let newsCell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedTableViewCell", for: indexPath) as? NewsFeedTableViewCellCreator else {
            return UITableViewCell()
        }
            
        let newsItem = newsItems[newsIndex]
        newsCell.configure(with: newsItem, manager: newsItemsManager)
        return newsCell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
            
        let newsIndex = indexPath.row - (indexPath.row / 11)
        guard newsIndex < newsItems.count else { return }
            
        let newsItem = newsItems[newsIndex]
        let vk = ShowOnSourceNewsItemVC()
        vk.configure(with: newsItem)
        vk.modalPresentationStyle = .fullScreen
        
        transitionCount += 1
        
        if transitionCount % 3 == 0, let interstitialAd = interstitialAd {
            interstitialAd.present(fromRootViewController: self)
            loadInterstitialAd()
        } else {
            present(vk, animated: false)
        }
    }
}

// MARK: - Interstitial ad delegates

extension TimelineVC: GADFullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        let newsIndex = newsFeedTableView.indexPathForSelectedRow?.row ?? 0
        let vk = ShowOnSourceNewsItemVC()
        vk.configure(with: newsItems[newsIndex])
        vk.modalPresentationStyle = .fullScreen
        present(vk, animated: true)
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        
    }
}

// MARK: - Native ad delegates

extension TimelineVC: GADAdLoaderDelegate, GADNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        self.nativeAd = nativeAd
        newsFeedTableView.reloadData()
    }

    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        
    }
}

// MARK: - Setup UI

extension TimelineVC {
    private func setupUI() {
        view.backgroundColor = .greyBackGroundColor
        setupTitleLabel()
        setupSeparateLine()
        setupNewsFeedTableView()
        setupBannerAd()
        loadNativeAd()
        loadInterstitialAd()
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
        newsFeedTableView.register(NativeAdTableViewCell.self, forCellReuseIdentifier: "NativeAdTableViewCell")
        newsFeedTableView.backgroundColor = .clear
        newsFeedTableView.separatorStyle = .singleLine
        newsFeedTableView.separatorColor = .lightGray
        newsFeedTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
        view.addSubview(newsFeedTableView)
    }
    
    private func setupBannerAd() {
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView?.adUnitID = "ca-app-pub-1254388627213292/3555700304"
        bannerView?.rootViewController = self
        bannerView?.load(GADRequest())
        bannerView?.backgroundColor = .secondarySystemBackground
        if let bannerView = bannerView {
            view.addSubview(bannerView)
        }
    }
    
    private func loadNativeAd() {
        nativeAdLoader = GADAdLoader(adUnitID: "ca-app-pub-1254388627213292/4262648445",
                                     rootViewController: self,
                                     adTypes: [.native],
                                     options: nil)
        
        nativeAdLoader?.delegate = self
        nativeAdLoader?.load(GADRequest())
    }
    
    private func loadInterstitialAd() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-1254388627213292/3787774210", request: request) { [weak self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad: \(error.localizedDescription)")
                return
            }
            self?.interstitialAd = ad
            self?.interstitialAd?.fullScreenContentDelegate = self
        }
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
        
        bannerView?.snp.makeConstraints { maker in
            maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            maker.left.right.equalToSuperview()
            maker.height.equalTo(80)
        }
    }
}
