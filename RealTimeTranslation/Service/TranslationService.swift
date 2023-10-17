//
//  TranslationService.swift
//  RealTimeTranslation
//
//  Created by BMO on 2023/10/16.
//

import UIKit

final class TranslationService {
    func applyTranslation(
        _ transcript: String,
        targetLanguage: PapagoTranslationLanguage,
        to label: UILabel
    ) {
        detectLanguage(of: transcript) { [weak self] sourceLanguage in
            self?.translate(
                transcript,
                sourceLanguage: sourceLanguage,
                targetLanguage: targetLanguage
            ) { result in
                DispatchQueue.main.async {
                    label.text = result.message.result.translatedText
                }
            }
        }
    }
    
    // 번역
    private func translate(
        _ text: String,
        sourceLanguage: PapagoTranslationLanguage,
        targetLanguage: PapagoTranslationLanguage,
        complition: @escaping (PapagoTranslation) -> Void
    ) {
        var components = URLComponents()
        components.scheme = NaverAPI.scheme
        components.host = NaverAPI.host
        components.path = NaverAPI.translatePath

        let query = [
            "source" : sourceLanguage.rawValue,
            "target" : targetLanguage.rawValue,
            "text" : text
        ]

        components.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = components.url else { return }

        let headers = [
            NaverAPI.clientIdKey : NaverAPI.clientIdValue,
            NaverAPI.clientSecretKey : NaverAPI.clientSecretValue,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        headers.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }

            let jsonDecoder = JSONDecoder()

            do {
                let translation = try jsonDecoder.decode(PapagoTranslation.self, from: data)
                complition(translation)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    // 언어 감지
    private func detectLanguage(
        of text: String,
        complition: @escaping (PapagoTranslationLanguage) -> Void
    ) {
        var components = URLComponents()
        components.scheme = NaverAPI.scheme
        components.host = NaverAPI.host
        components.path = NaverAPI.detectLanguagePath

        let query = [
            "query" : text,
        ]

        components.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = components.url else { return }

        let headers = [
            NaverAPI.clientIdKey : NaverAPI.clientIdValue,
            NaverAPI.clientSecretKey : NaverAPI.clientSecretValue,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        headers.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else {
                print(String(describing: error))
                return
            }

            let jsonDecoder = JSONDecoder()
            
            do {
                let detectLanguage = try jsonDecoder.decode(PapagoDetectLanguage.self, from: data)
                // FIXME: 감지 언어 18개, 번역 언어 13개. 5가지 차이에 의해 에러가 발생할 수 있음.
                complition(detectLanguage.languageCode)
            } catch {
                print(error)
            }
        }.resume()
    }
}
