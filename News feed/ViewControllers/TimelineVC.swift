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
    private var newsFeedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
}

// MARK: - UICollectionView properties

extension TimelineVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimelineCollectionViewCell", for: indexPath) as? NewsFeedCollectionCell else { return UICollectionViewCell() }
        return cell
    }
}

// MARK: - Setup UI

extension TimelineVC {
    private func setupUI() {
        view.backgroundColor = .greyBackGroundColor
        setupTitleLabel()
        setupSeparateLine()
        setupNewsLineCollectionView()
        
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
    
    private func setupNewsLineCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: 400)
        layout.minimumLineSpacing = 0
        newsFeedCollectionView.setCollectionViewLayout(layout, animated: false)
        newsFeedCollectionView.backgroundColor = .clear
        newsFeedCollectionView.delegate = self
        newsFeedCollectionView.dataSource = self
        newsFeedCollectionView.register(NewsFeedCollectionCell.self, forCellWithReuseIdentifier: "TimelineCollectionViewCell")
        view.addSubview(newsFeedCollectionView)
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
        
        newsFeedCollectionView.snp.makeConstraints { maker in
            maker.top.equalTo(separateLine.snp.bottom)
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
    }
}
