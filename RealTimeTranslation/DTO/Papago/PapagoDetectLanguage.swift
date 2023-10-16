//
//  PapagoDetectLanguage.swift
//  RealTimeTranslation
//
//  Created by BMO on 2023/10/15.
//

struct PapagoDetectLanguage: Decodable {
    let languageCode: PapagoTranslationLanguage    // 감지된 언어
    
    private enum CodingKeys: String, CodingKey {
        case languageCode = "langCode"
    }
}
