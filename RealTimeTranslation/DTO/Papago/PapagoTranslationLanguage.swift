//
//  PapagoTranslationLanguage.swift
//  RealTimeTranslation
//
//  Created by BMO on 2023/10/16.
//

enum PapagoTranslationLanguage: String, Decodable, CaseIterable {
    case ko                 // 한국어
    case en                 // 영어
    case ja                 // 일본어
    case zhCN = "zh-CN"     // 중국어 간체
    case zhTW = "zh-TW"     // 중국어 번체
    case vi                 // 베트남어
    case id                 // 인도네시아어
    case th                 // 태국어
    case de                 // 독일어
    case ru                 // 러시아어
    case es                 // 스페인어
    case it                 // 이탈리아어
    case fr                 // 프랑스어
    
    private enum CodingKeys: String, CodingKey {
        case ko
        case en
        case ja
        case zhCN = "zh-CN"
        case zhTW = "zh-TW"
        case vi
        case id
        case th
        case de
        case ru
        case es
        case it
        case fr
    }
    
    var notation: String {
        switch self {
        case .ko:
            return "한국어"
        case .en:
            return "English"
        case .ja:
            return "日本語"
        case .zhCN:
            return "簡體字"
        case .zhTW:
            return "繁体字"
        case .vi:
            return "Tiếng Việt"
        case .id:
            return "Bahasa Indonesia"
        case .th:
            return "ภาษาไทย"
        case .de:
            return "Deutsch"
        case .ru:
            return "Русский"
        case .es:
            return "Español"
        case .it:
            return "Italiano"
        case .fr:
            return "Français"
        }
    }
}
