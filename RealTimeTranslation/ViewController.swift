//
//  ViewController.swift
//  RealTimeTranslation
//
//  Created by BMO on 2023/10/11.
//

import UIKit

final class ViewController: UIViewController {
    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        
        stackView.backgroundColor = .systemRed
        
        return stackView
    }()
    let cameraArea: UIView = {
        let view = UIView()
        
        view.backgroundColor = .systemGreen
        
        return view
    }()
    let languageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        
        stackView.backgroundColor = .systemBlue
        
        return stackView
    }()
    let fromLanguageButton: UIButton = {
        let button = UIButton()
        button.setTitle("영어", for: .normal)
        button.backgroundColor = .systemCyan
        
        return button
    }()
    let toTranslateLanguageButton: UIButton = {
        let button = UIButton()
        button.setTitle("한국어", for: .normal)
        button.backgroundColor = .systemMint
        
        return button
    }()
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        
        stackView.backgroundColor = .systemYellow
        
        return stackView
    }()
    let emptyButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    let shotButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 70 / 2
        button.setImage(UIImage(systemName: "circle.inset.filled"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemGray2
        
        return button
    }()
    let flashButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 50 / 2
        button.setImage(UIImage(systemName: "flashlight.on.fill"), for: .normal)
        button.tintColor = .white
        
        button.backgroundColor = .systemGray2
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }

    private func setUI() {
        // view
        view.addSubview(mainStackView)
        
        // mainStackView
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        [
            cameraArea,
            languageStackView,
            buttonStackView
        ].forEach {
            mainStackView.addArrangedSubview($0)
        }
        
        // cameraArea
        NSLayoutConstraint.activate([
            cameraArea.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            cameraArea.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            cameraArea.topAnchor.constraint(equalTo: mainStackView.topAnchor),
            cameraArea.bottomAnchor.constraint(equalTo: languageStackView.topAnchor)
        ])
        
        // languageStackView
        NSLayoutConstraint.activate([
            languageStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 32),
            languageStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -32),
            languageStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        [
            fromLanguageButton,
            toTranslateLanguageButton
        ].forEach {
            languageStackView.addArrangedSubview($0)
        }
        
        // buttonStackView
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 32),
            buttonStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -32),
            buttonStackView.topAnchor.constraint(equalTo: languageStackView.bottomAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor),
            buttonStackView.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        [
            emptyButton,
            shotButton,
            flashButton
        ].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            emptyButton.widthAnchor.constraint(equalToConstant: 50),
            emptyButton.heightAnchor.constraint(equalToConstant: 50),
            shotButton.widthAnchor.constraint(equalToConstant: 70),
            shotButton.heightAnchor.constraint(equalToConstant: 70),
            flashButton.widthAnchor.constraint(equalToConstant: 50),
            flashButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

