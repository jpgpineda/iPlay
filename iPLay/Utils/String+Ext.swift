//
//  String+Ext.swift
//  iPLay
//
//  Created by javier pineda on 25/09/25.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return emailPredicate.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        return self.count >= 8
    }
}
