//
//  DeepLinkResponder.swift
//  
//
//  Created by Тарас Коцур on 19.06.2022.
//

import UIKit
import CoordinatorKit

public protocol DeepLinkResponder: AnyObject {
    var deepLinkLocator: DeepLinkLocatorProtocol { get }

    func becomeFirstResponder(child: Coordinatable?)
    func canRespond(on path: String) -> Bool
    func respond(on path: String)
    func hitTest(with path: String) -> DeepLinkResponder?
}

public extension DeepLinkResponder {
    func respond(on deepLink: String) {}
}

