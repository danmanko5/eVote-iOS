//
//  URLHandler.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit

protocol URLHandler {
    func open(_ url: URL)
}

extension UIApplication: URLHandler {
    
    func open(_ url: URL) {
        self.open(url, options: [:], completionHandler: nil)
    }
}
