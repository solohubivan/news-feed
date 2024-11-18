//
//  NativeAdTableViewCell.swift
//  News feed
//
//  Created by Ivan Solohub on 14.11.2024.
//

import UIKit
import GoogleMobileAds
import SnapKit

class NativeAdTableViewCell: UITableViewCell {
    private var nativeAdView: GADNativeAdView!
    
    private var headlineLabel: UILabel!
    private var advertiserLabel: UILabel!
    private var adIconView: UIImageView!
    private var callToActionButton: UIButton!
    private var adChoicesView: UIView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAdView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func configureAd(with nativeAd: GADNativeAd) {
        nativeAdView.nativeAd = nativeAd

        if let headline = nativeAd.headline {
            headlineLabel.text = headline
        }

        if let advertiser = nativeAd.advertiser {
            advertiserLabel.text = advertiser
        }

        if let icon = nativeAd.icon {
            adIconView.image = icon.image
        }

        if let callToAction = nativeAd.callToAction {
            callToActionButton.setTitle(callToAction, for: .normal)
        }

        headlineLabel.isHidden = nativeAd.headline == nil
        advertiserLabel.isHidden = nativeAd.advertiser == nil
        adIconView.isHidden = nativeAd.icon == nil
        callToActionButton.isHidden = nativeAd.callToAction == nil
    }

    // MARK: - Private methods
    
    private func setupAdView() {
        nativeAdView = GADNativeAdView()
        contentView.addSubview(nativeAdView)

        nativeAdView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview().inset(8)
        }

        headlineLabel = UILabel()
        headlineLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        headlineLabel.numberOfLines = 2
        nativeAdView.headlineView = headlineLabel
        nativeAdView.addSubview(headlineLabel)

        advertiserLabel = UILabel()
        advertiserLabel.font = UIFont.systemFont(ofSize: 12)
        advertiserLabel.textColor = .gray
        nativeAdView.advertiserView = advertiserLabel
        nativeAdView.addSubview(advertiserLabel)

        adIconView = UIImageView()
        adIconView.contentMode = .scaleAspectFit
        nativeAdView.iconView = adIconView
        nativeAdView.addSubview(adIconView)

        callToActionButton = UIButton(type: .system)
        callToActionButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        callToActionButton.setTitleColor(.white, for: .normal)
        callToActionButton.backgroundColor = .blue
        callToActionButton.layer.cornerRadius = 4
        nativeAdView.callToActionView = callToActionButton
        nativeAdView.addSubview(callToActionButton)

        adChoicesView = UIView()
        nativeAdView.addSubview(adChoicesView)
    }
    
    // MARK: - Setup constraints
    
    private func setupConstraints() {
        headlineLabel.snp.makeConstraints { maker in
            maker.top.left.equalToSuperview().offset(8)
            maker.right.equalToSuperview().inset(8)
        }

        advertiserLabel.snp.makeConstraints { maker in
            maker.top.equalTo(headlineLabel.snp.bottom).offset(4)
            maker.left.equalToSuperview().offset(8)
        }

        adIconView.snp.makeConstraints { maker in
            maker.top.equalTo(advertiserLabel.snp.bottom).offset(8)
            maker.left.equalToSuperview().offset(8)
            maker.width.height.equalTo(40)
        }

        callToActionButton.snp.makeConstraints { maker in
            maker.top.equalTo(adIconView.snp.bottom).offset(8)
            maker.left.equalToSuperview().offset(8)
            maker.right.equalToSuperview().inset(8)
            maker.height.equalTo(40)
            maker.bottom.equalToSuperview().inset(8)
        }

        adChoicesView.snp.makeConstraints { maker in
            maker.top.right.equalToSuperview().inset(8)
            maker.width.height.equalTo(20)
        }
    }
}
