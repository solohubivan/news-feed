//
//  TestVC.swift
//  News feed
//
//  Created by Ivan Solohub on 17.10.2024.
//

import UIKit

class TestVC: UIViewController {
    
    private var button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
        setupButton()
    }
    
    private func setupButton() {
            button.setTitle("Move Back", for: .normal)
            button.backgroundColor = .orange
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 8
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            
            view.addSubview(button)
        
            
            // Налаштовуємо розміщення кнопки по центру
            button.snp.makeConstraints { maker in
                maker.center.equalToSuperview() // Центр по відношенню до супервью
                maker.width.equalTo(200) // Ширина кнопки 200
                maker.height.equalTo(50) // Висота кнопки 50
            }
        }
    
    @objc private func buttonTapped () {
        dismiss(animated: true)
    }
}
