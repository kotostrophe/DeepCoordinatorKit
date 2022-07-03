import XCTest
@testable import DeepCoordinatorKit

final class DeepLinkLocatorTests: XCTestCase {
    
    func testAddingDublicatingRoute() {
        let routesLocator: DeepLinkLocatorProtocol = DeepLinkLocator()
        
        let route = DeepLinkRoute(path: "/path/first") { _ in }
        
        routesLocator.add(route: route)
        routesLocator.add(routes: route)
        routesLocator.add(routes: [route])
        
        XCTAssert(
            routesLocator.routes.count == 1 && routesLocator.routes.first == route,
            "Routes locator contains dublicats of single route"
        )
    }
    
    func testStorageOfLocator() {
        let routesLocator: DeepLinkLocatorProtocol = DeepLinkLocator()
        
        let firstRoute = DeepLinkRoute(path: "/path/first") { _ in }
        let secondRoute = DeepLinkRoute(path: "/path/second") { _ in }
        let thirdRoute = DeepLinkRoute(path: "/path/third") { _ in }
        
        routesLocator.add(route: firstRoute)
        routesLocator.add(route: secondRoute)
        routesLocator.add(route: thirdRoute)
        
        XCTAssert(
            routesLocator.routes.count == 3,
            "Routes locator don't save routes"
        )
    }
    
    func testRemovingRoutesFromLocator() {
        let routesLocator: DeepLinkLocatorProtocol = DeepLinkLocator()
        
        let firstRoute = DeepLinkRoute(path: "/path/first") { _ in }
        let secondRoute = DeepLinkRoute(path: "/path/second") { _ in }
        let thirdRoute = DeepLinkRoute(path: "/path/third") { _ in }
        
        routesLocator.add(route: firstRoute)
        routesLocator.add(route: secondRoute)
        routesLocator.add(route: thirdRoute)
        
        routesLocator.remove(route: firstRoute)
        
        XCTAssert(
            routesLocator.routes.count == 2,
            "Routes locator don't remove routes propperly"
        )
        
        routesLocator.remove(routeBy: secondRoute.path)
        
        XCTAssert(
            routesLocator.routes.count == 1 && routesLocator.routes.first == thirdRoute,
            "Routes locator don't remove routes propperly"
        )
    }
    
    func testGettingRoutesFromLocator() {
        let routesLocator: DeepLinkLocatorProtocol = DeepLinkLocator()
        
        let firstRoute = DeepLinkRoute(path: "/path/first") { _ in }
        let secondRoute = DeepLinkRoute(path: "/path/second") { _ in }
        
        routesLocator.add(route: firstRoute)
        routesLocator.add(route: secondRoute)
        
        XCTAssertNotNil(
            routesLocator.get(routeBy: firstRoute.path),
            "Failed to get route by reference via method"
        )
        
        XCTAssertNotNil(
            routesLocator.routes.first(where: { route in route == secondRoute }),
            "Failed to get route by path"
        )
    }
}
