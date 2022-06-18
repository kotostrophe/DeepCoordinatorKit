//
//  DeepLinkComponent+String.swift
//  
//
//  Created by Тарас Коцур on 19.06.2022.
//

import Foundation

public func / (lhs: String, rhs: String) -> String {
    [lhs, rhs]
        .joined(separator: DeepLinkRoute.separator)
}

public func / <Component>(lhs: String, rhs: Component) -> String
where Component: RawRepresentable, Component.RawValue == String {
    [lhs, DeepLinkRoute.variable + rhs.rawValue]
        .joined(separator: DeepLinkRoute.separator)
}

public func / <Component>(lhs: Component, rhs: String) -> String
where Component: RawRepresentable, Component.RawValue == String {
    [DeepLinkRoute.variable + lhs.rawValue, rhs]
        .joined(separator: DeepLinkRoute.separator)
}

public func / <Component>(lhs: Component, rhs: Component) -> String
where Component: RawRepresentable, Component.RawValue == String {
    [DeepLinkRoute.variable + lhs.rawValue, DeepLinkRoute.variable + rhs.rawValue]
        .joined(separator: DeepLinkRoute.separator)
}
