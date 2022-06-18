//
//  File.swift
//  
//
//  Created by Тарас Коцур on 19.06.2022.
//

import Foundation

public protocol DeepLinkLocatorProtocol: AnyObject {
    var routes: Set<DeepLinkRoute> { get }

    func add(route: DeepLinkRoute)
    func add(routes: [DeepLinkRoute])
    func add(routes: DeepLinkRoute...)
    func remove(route: DeepLinkRoute)
    func get(routeBy path: String) -> DeepLinkRoute?
    func remove(routeBy path: String)
}

public final class DeepLinkLocator: DeepLinkLocatorProtocol {
    // MARK: - Properties

    public var routes: Set<DeepLinkRoute>

    // MARK: - Initializers

    public init(routes: Set<DeepLinkRoute> = []) {
        self.routes = routes
    }

    // MARK: - Methods

    public func add(route: DeepLinkRoute) {
        routes.insert(route)
    }

    public func add(routes: [DeepLinkRoute]) {
        routes.forEach(add(route:))
    }

    public func add(routes: DeepLinkRoute...) {
        routes.forEach(add(route:))
    }

    public func remove(route: DeepLinkRoute) {
        routes.remove(route)
    }

    public func get(routeBy path: String) -> DeepLinkRoute? {
        routes.first { $0.path == path }
    }

    public func remove(routeBy path: String) {
        guard let route = get(routeBy: path) else { return }
        routes.remove(route)
    }
}
