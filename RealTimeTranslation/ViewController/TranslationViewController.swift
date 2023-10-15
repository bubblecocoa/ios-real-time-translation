//
//  TranslationViewController.swift
//  RealTimeTranslation
//
//  Created by BMO on 2023/10/11.
//

import UIKit
import VisionKit

final class TranslationViewController: UIViewController {
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        
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
    private let languageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    private let fromLanguageButton: UIButton = {
        let button = UIButton()
        button.setTitle("영어", for: .normal)
        button.backgroundColor = .systemGray
        
        return button
    }()
    private let toTranslateLanguageButton: UIButton = {
        let button = UIButton()
        button.setTitle("한국어", for: .normal)
        button.backgroundColor = .systemGray
        
        return button
    }()
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        
        return stackView
    }()
    private let emptyButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    private let shotButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 70 / 2
        button.setImage(UIImage(systemName: "circle.inset.filled"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemGray2
        
        return button
    }()
    private let flashButton: UIButton = {
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
        setDataScanner()
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
            languageStackView,
            buttonStackView
        ].forEach {
            mainStackView.addArrangedSubview($0)
        }
        
        // dataScanner
        NSLayoutConstraint.activate([
            dataScanner.view.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            dataScanner.view.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            dataScanner.view.topAnchor.constraint(equalTo: mainStackView.topAnchor),
            dataScanner.view.bottomAnchor.constraint(equalTo: languageStackView.topAnchor, constant: -16)
        ])
        
        // languageStackView
        NSLayoutConstraint.activate([
            languageStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 16),
            languageStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -16),
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
            buttonStackView.topAnchor.constraint(equalTo: languageStackView.bottomAnchor, constant: 16),
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
    
    private func setDataScanner() {
        dataScanner.delegate = self
        
        do {
            try dataScanner.startScanning()
        } catch {
            print("데이터 스캔 시작에 실패했습니다. - \(error)")
        }
    }
    
    private func drawLabels(using items: [RecognizedItem]) {
        dataScanner.view.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        items.forEach { item in
            switch item {
            case .text(let text):
                let bounds = text.bounds
                let transcript = text.transcript
                let label = UILabel(frame: CGRect(
                    origin: bounds.bottomLeft,
                    size: CGSize(
                        width: bounds.topRight.x - bounds.topLeft.x,
                        height: bounds.topRight.y - bounds.bottomRight.y
                    )
                ))
                
                label.backgroundColor = .cyan
                label.text = transcript
                label.textAlignment = .center
                label.textColor = .black
                label.numberOfLines = 0
                
                detectLanguage(of: transcript) { [weak self] languageCode in
                    self?.translateText(
                        of: transcript,
                        sourceLanguage: languageCode,
                        targetLanguage: "ko"
                    ) { result in
                        DispatchQueue.main.async {
                            label.text = result.message.result.translatedText
                        }
                    }
                }
                
                dataScanner.view.addSubview(label)
            default:
                print("Item is not text.")
            }
        }
    }
    
    // 언어 번역
    private func translateText(
        of text: String,
        sourceLanguage: String = "en",
        targetLanguage: String = "ko",
        complition: @escaping (PapagoTranslation) -> Void
    ) {
        let parameters = "source=\(sourceLanguage)&target=\(targetLanguage)&text=\(text)"
        let postData =  parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://openapi.naver.com/v1/papago/n2mt")!, timeoutInterval: Double.infinity)
        request.addValue("aEpCXgtaj9I8W8FmtPTy", forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue("9gsVXE0aSl", forHTTPHeaderField: "X-Naver-Client-Secret")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let translation = try jsonDecoder.decode(PapagoTranslation.self, from: data)
                print("번역 결과 : \(translation.message.result.translatedText)")
                complition(translation)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    // 언어 감지
    private func detectLanguage(
        of text: String,
        complition: @escaping (String) -> Void
    ) {
        let parameters = "query=What%20is%20the%20language%20of%20this%20sentence%3F"
        let postData =  parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://openapi.naver.com/v1/papago/detectLangs")!, timeoutInterval: Double.infinity)
        request.addValue(Bundle.main.naverClientId, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(Bundle.main.naverClientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else {
                print(String(describing: error))
                return
            }

            let jsonDecoder = JSONDecoder()
            
            do {
                let detectLanguage = try jsonDecoder.decode(PapagoDetectLanguage.self, from: data)
                print("번역 결과 : \(detectLanguage.languageCode)")
                complition(detectLanguage.languageCode)
            } catch {
                print(error)
            }
        }.resume()
    }
}

extension TranslationViewController: DataScannerViewControllerDelegate {
    func dataScanner(
        _ dataScanner: DataScannerViewController,
        didAdd addedItems: [RecognizedItem],
        allItems: [RecognizedItem]
    ) {
        drawLabels(using: allItems)
    }

    func dataScanner(
        _ dataScanner: DataScannerViewController,
        didTapOn item: RecognizedItem
    ) {
        switch item {
        case .text(let text):
            print("text: \(text.transcript)")
        default:
            print("unexpected item")
        }
    }
}
