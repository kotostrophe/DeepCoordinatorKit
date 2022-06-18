//
//  Coordinator+DeepLinkResponder.swift
//  
//
//  Created by Тарас Коцур on 19.06.2022.
//

import UIKit
import CoordinatorKit

// MARK: - DeepLinkResponder

public extension Coordinatable where Self: DeepLinkResponder {
    func becomeFirstResponder(child: Coordinatable? = nil) {
        switch rootViewController {
        case let tabBarController as UITabBarController:
            guard
                let childViewController = child?.rootViewController,
                let index = tabBarController.viewControllers?.firstIndex(of: childViewController)
            else { break }
            tabBarController.selectedIndex = index
        default: break
        }

        guard let parent = parent as? DeepLinkResponder else { return }
        parent.becomeFirstResponder(child: self)
    }

    func respond(on path: String) {
        deepLinkLocator.routes
            .first(where: { route in path == route })?
            .prepareAction(with: path)()
    }

    func canRespond(on path: String) -> Bool {
        deepLinkLocator.routes.contains(where: { route in path == route })
    }

    func hitTest(with path: String) -> DeepLinkResponder? {
        if canRespond(on: path) { return self }
        for targetResponder in childLocator.coordiantors.compactMap({ $0 as? DeepLinkResponder }) {
            guard let targetResponder = targetResponder.hitTest(with: path) else { continue }
            return targetResponder
        }
        return nil
    }
}

// MARK: - DeepLinkResponder start

public extension Coordinatable where Self: DeepLinkResponder {
    
    func start(
        deeplink path: String,
        on queue: DispatchQueue = .global(qos: .background)
    ) {
        start(deeplink: path, from: self, on: queue)
    }
    
    func start<Responder>(
        deeplink path: String,
        from responder: Responder,
        on queue: DispatchQueue = .global(qos: .background)
    ) where Responder: Coordinatable, Responder: DeepLinkResponder {
        queue.async {
            guard let firstResponder = responder.hitTest(with: path) else { return }
            DispatchQueue.main.async {
                firstResponder.becomeFirstResponder(child: nil)
                firstResponder.respond(on: path)
            }
        }
    }
}
