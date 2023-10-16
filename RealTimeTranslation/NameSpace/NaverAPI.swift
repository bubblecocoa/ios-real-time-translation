//
//  NaverNameSpace.swift
//  RealTimeTranslation
//
//  Created by BMO on 2023/10/16.
//

import Foundation

enum NaverAPI {
    static let clientIdKey = "X-Naver-Client-Id"
    static let clientIdValue = Bundle.main.naverClientId
    static let clientSecretKey = "X-Naver-Client-Secret"
    static let clientSecretValue = Bundle.main.naverClientSecret
    static let scheme = "https"
    static let host = "openapi.naver.com"
    static let translatePath = "/v1/papago/n2mt"
    static let detectLanguagePath = "/v1/papago/detectLangs"
}
