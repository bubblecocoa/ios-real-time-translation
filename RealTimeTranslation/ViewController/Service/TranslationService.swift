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
        to label: UILabel
    ) {
        detectLanguage(of: transcript) { [weak self] languageCode in
            self?.translate(
                transcript,
                sourceLanguage: languageCode,
                targetLanguage: "ko"
            ) { result in
                DispatchQueue.main.async {
                    label.text = result.message.result.translatedText
                }
            }
        }
    }
    
    // 언어 번역
    private func translate(
        _ text: String,
        sourceLanguage: String = "en",
        targetLanguage: String = "ko",
        complition: @escaping (PapagoTranslation) -> Void
    ) {
        var components = URLComponents()
        components.scheme = NaverAPI.scheme
        components.host = NaverAPI.host
        components.path = NaverAPI.translatePath

        let query = [
            "source" : sourceLanguage,
            "target" : targetLanguage,
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
                print("감지 언어 : \(detectLanguage.languageCode)")
                complition(detectLanguage.languageCode)
            } catch {
                print(error)
            }
        }.resume()
    }
}
