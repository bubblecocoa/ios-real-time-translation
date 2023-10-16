//
//  DataScannerViewController+.swift
//  RealTimeTranslation
//
//  Created by BMO on 2023/10/16.
//

import VisionKit

extension DataScannerViewController {
    func addSubview(_ view: UIView) {
        self.view.addSubview(view)
    }
    
    func removeAllSubviews() {
        view.subviews.forEach { $0.removeFromSuperview() }
    }
}
