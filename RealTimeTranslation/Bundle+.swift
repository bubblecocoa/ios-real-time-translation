//
//  Bundle+.swift
//  RealTimeTranslation
//
//  Created by BMO on 2023/10/15.
//

import Foundation

extension Bundle {
    var naverClientId: String {
        guard let file = self.path(forResource: "NaverAPIKey", ofType: "plist") else { return "" }
        guard let resource = NSDictionary (contentsOfFile: file) else { return "" }
        guard let id = resource["ClientID"] as? String else {
            fatalError("NaverAPIKey.plist에 ClientID를 설정해주세요.")
        }
        
        return id
    }
    
    var naverClientSecret: String {
        guard let file = self.path(forResource: "NaverAPIKey", ofType: "plist") else { return "" }
        guard let resource = NSDictionary (contentsOfFile: file) else { return "" }
        guard let secret = resource["ClientSecret"] as? String else {
            fatalError("NaverAPIKey.plist에 ClientSecret를 설정해주세요.")
        }
        
        return secret
    }
}
