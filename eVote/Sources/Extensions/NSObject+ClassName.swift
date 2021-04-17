//
//  NSObject+ClassName.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation

extension NSObject {
    @objc class var classFullName: String {
        return String(reflecting: self)
    }
    
    @objc class var className: String {
        return String(describing: self)
    }
    
    @objc var classFullName: String {
        return type(of: self).classFullName
    }
    
    @objc var className: String {
        return type(of: self).className
    }
}
