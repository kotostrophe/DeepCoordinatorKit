//
//  Collection+isNotEmpty.swift
//  
//
//  Created by Тарас Коцур on 19.06.2022.
//

import Foundation

extension Collection {
    @inlinable var isNotEmpty: Bool { isEmpty == false }
}
