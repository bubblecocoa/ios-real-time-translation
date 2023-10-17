//
//  ModalViewController.swift
//  RealTimeTranslation
//
//  Created by BMO on 2023/10/17.
//

import UIKit
import VisionKit

final class ModalViewController: UIViewController {
    let translationService: TranslationService
    let sourceText: RecognizedItem.Text
    let targetLanguage: PapagoTranslationLanguage
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .leading
        
        return stackView
    }()
    let sourceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        
        return label
    }()
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray

        return view
    }()
    let translatedLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        
        return label
    }()
    
    init(translationService: TranslationService, sourceText: RecognizedItem.Text, targetLanguage: PapagoTranslationLanguage) {
        self.translationService = translationService
        self.sourceText = sourceText
        self.targetLanguage = targetLanguage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        if let sheetPresentationController {
            sheetPresentationController.detents = [.medium(), .large()]
            sheetPresentationController.prefersGrabberVisible = true
        }
        
        setUI()
        setLabelText()
    }
    
    private func setUI() {
        view.backgroundColor = .darkGray
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30)
        ])
        
        [sourceLabel, separator, translatedLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            separator.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1),
            separator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    private func setLabelText() {
        sourceLabel.text = sourceText.transcript
        translationService.applyTranslation(sourceText.transcript, targetLanguage: targetLanguage, to: translatedLabel)
    }
}
