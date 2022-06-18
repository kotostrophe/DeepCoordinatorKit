//
//  DeepLinkComponent+JSON.swift
//  
//
//  Created by Тарас Коцур on 19.06.2022.
//

import Foundation
import SwiftyJSON

public extension JSON {
    subscript<Component>(key: Component) -> JSON
    where Component: RawRepresentable, Component.RawValue == String {
        self[key.rawValue]
    }
}
