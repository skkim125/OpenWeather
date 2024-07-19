//
//  UIViewController+Extension.swift
//  OpenWeather
//
//  Created by 김상규 on 7/14/24.
//

import UIKit

extension UIViewController {
    // MARK: - Alert Functions
    func showOneButtonAlert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let back = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(back)
        
        present(alert, animated: true)
    }
    
    func showTwoButtonAlert(title: String, message: String?, checkButtonTitle: String, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .destructive)
        let ok = UIAlertAction(title: checkButtonTitle, style: .default) { _ in
            completionHandler()
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
}
