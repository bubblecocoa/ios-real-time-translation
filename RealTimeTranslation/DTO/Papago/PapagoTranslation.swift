//
//  PapagoTranslation.swift
//  RealTimeTranslation
//
//  Created by BMO on 2023/10/15.
//

struct PapagoTranslation: Decodable {
    let message: PapagoTranslationMessage
}

struct PapagoTranslationMessage: Decodable {
    let result: PapagoTranslationResult
}

struct PapagoTranslationResult: Decodable {
    let sourceLanguageType: String  // 번역할 원본 언어의 언어 코드
    let targetLanguageType: String  // 번역한 목적 언어의 언어 코드
    let translatedText: String      // 번역된 텍스트
    
    private enum CodingKeys: String, CodingKey {
        case sourceLanguageType = "srcLangType"
        case targetLanguageType = "tarLangType"
        case translatedText
    }
}
