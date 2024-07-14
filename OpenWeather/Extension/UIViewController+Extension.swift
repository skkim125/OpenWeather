//
//  UIViewController+Extension.swift
//  OpenWeather
//
//  Created by 김상규 on 7/14/24.
//

import UIKit

extension UIViewController {
    func showAlert() {
        let alert = UIAlertController(title: "네트워크 연결 실패", message: "잠시 후 다시 시도해주세요", preferredStyle: .alert)
        let back = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(back)
        
        present(alert, animated: true)
    }
}
