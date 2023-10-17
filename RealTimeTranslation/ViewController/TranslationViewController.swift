//
//  TranslationViewController.swift
//  RealTimeTranslation
//
//  Created by BMO on 2023/10/11.
//

import UIKit
import VisionKit

final class TranslationViewController: UIViewController {
    private let translationService: TranslationService
    private var flashState: Bool = false
    private var scanningState: Bool = true
    private var targetLanguage: PapagoTranslationLanguage = .ko
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        
        stackView.backgroundColor = .black
        
        return stackView
    }()
    private let dataScanner: DataScannerViewController = {
        let scanner = DataScannerViewController(
            recognizedDataTypes: [
                .text()
            ],
            recognizesMultipleItems: true,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true
        )

        return scanner
    }()
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fill
        
        return stackView
    }()
    private let toggleFlashButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.tintColor = .black
        button.setImage(UIImage(systemName: "bolt.slash.fill"), for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.clipsToBounds = true

        return button
    }()
    private lazy var toTranslateLanguageButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.setTitle(PapagoTranslationLanguage.ko.notation, for: .normal)
        button.menu = UIMenu(children: PapagoTranslationLanguage.allCases.map { language in
            UIAction(
                title: language.notation,
                handler: { [weak self] _ in
                    self?.targetLanguage = language
                    self?.stopScanning()
                    self?.startScanning()
                    button.setTitle(language.notation, for: .normal)
                }
            )
        }.reversed())
        button.showsMenuAsPrimaryAction = true
        
        return button
    }()
    private let toggleScanningButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.tintColor = .black
        button.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.clipsToBounds = true

        return button
    }()
    
    init(translationService: TranslationService) {
        self.translationService = translationService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setDataScanner()
        setButtonAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setButtonCornerRadius()
    }

    private func setUI() {
        // view
        view.backgroundColor = .black
        view.addSubview(mainStackView)
        
        // mainStackView
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        [
            dataScanner.view,
            buttonStackView
        ].forEach {
            mainStackView.addArrangedSubview($0)
        }
        
        // dataScanner
        NSLayoutConstraint.activate([
            dataScanner.view.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            dataScanner.view.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            dataScanner.view.topAnchor.constraint(equalTo: mainStackView.topAnchor)
        ])
        
        // buttonStackView
        NSLayoutConstraint.activate([
            buttonStackView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 1, constant: -32),
            buttonStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        [
            toggleFlashButton,
            toTranslateLanguageButton,
            toggleScanningButton
        ].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            toggleFlashButton.widthAnchor.constraint(equalTo: toggleFlashButton.heightAnchor, multiplier: 1),
            toggleScanningButton.widthAnchor.constraint(equalTo: toggleScanningButton.heightAnchor, multiplier: 1)
        ])
    }
    
    private func setDataScanner() {
        dataScanner.delegate = self
        
        do {
            try dataScanner.startScanning()
        } catch {
            print("데이터 스캔 시작에 실패했습니다. - \(error)")
        }
    }
    
    private func setButtonAction() {
        let toggleFlashAction = UIAction { [weak self] _ in
            self?.toggleFlash()
        }
        
        let toggleScanningAction = UIAction { [weak self] _ in
            self?.toggleScanning()
        }
        
        toggleFlashButton.addAction(toggleFlashAction, for: .touchUpInside)
        toggleScanningButton.addAction(toggleScanningAction, for: .touchUpInside)
    }
    
    private func setButtonCornerRadius() {
        toggleFlashButton.layer.cornerRadius = toggleFlashButton.frame.width / 2
        toggleScanningButton.layer.cornerRadius = toggleScanningButton.frame.width / 2
    }
    
    private func showTranslation(using items: [RecognizedItem]) {
        dataScanner.removeAllSubviews()
        
        items.forEach { item in
            switch item {
            case .text(let text):
                drawLabels(text)
            default:
                print("Item is not text.")
            }
        }
    }
    
    private func drawLabels(_ text: RecognizedItem.Text) {
        let bounds = text.bounds
        let transcript = text.transcript
        let label = UILabel(frame: CGRect(
            origin: bounds.bottomLeft,
            size: CGSize(
                width: bounds.topRight.x - bounds.topLeft.x,
                height: bounds.topRight.y - bounds.bottomRight.y
            )
        ))
        
        label.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        label.text = transcript
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.adjustsFontSizeToFitWidth = true
        label.layer.cornerRadius = label.frame.size.height / 8
        label.clipsToBounds = true
        
        applyTranslation(transcript, to: label)
        dataScanner.addSubview(label)
    }
    
    private func applyTranslation(_ transcript: String, to label: UILabel) {
        translationService.applyTranslation(transcript, targetLanguage: targetLanguage, to: label)
    }
    
    private func toggleFlash() {
        flashState.toggle()
        
        if flashState {
            turnOnFlash()
        } else {
            turnOffFlash()
        }
    }
    
    private func turnOnFlash() {
        toggleFlashButton.setImage(UIImage(systemName: "bolt.fill"), for: .normal)
    }
    
    private func turnOffFlash() {
        toggleFlashButton.setImage(UIImage(systemName: "bolt.slash.fill"), for: .normal)
    }
    
    private func toggleScanning() {
        scanningState.toggle()
        
        if scanningState {
            startScanning()
        } else {
            stopScanning()
        }
    }
    
    private func startScanning() {
        try? dataScanner.startScanning()
        toggleScanningButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
    }
    
    private func stopScanning() {
        dataScanner.stopScanning()
        toggleScanningButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
    }
}

extension TranslationViewController: DataScannerViewControllerDelegate {
    func dataScanner(
        _ dataScanner: DataScannerViewController,
        didAdd addedItems: [RecognizedItem],
        allItems: [RecognizedItem]
    ) {
        showTranslation(using: allItems)
    }

    func dataScanner(
        _ dataScanner: DataScannerViewController,
        didTapOn item: RecognizedItem
    ) {
        switch item {
        case .text(let text):
            print("text: \(text.transcript)")
            let modal = ModalViewController(translationService: translationService, sourceText: text, targetLanguage: targetLanguage)
            self.present(modal, animated: true)
        default:
            print("unexpected item")
        }
    }
}
