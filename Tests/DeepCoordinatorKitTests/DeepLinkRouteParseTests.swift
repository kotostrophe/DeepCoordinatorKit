import XCTest
@testable import DeepCoordinatorKit

final class DeepLinkRouteParseTests: XCTestCase {
    
    func testRouteParser() {
        let value = 10
        let path = "/some/path/\(value)"
        
        let handler = DeepLinkRoute(path: "/some/path/:value") { json in
            let jsonValue = json["value"].intValue
            XCTAssertTrue(jsonValue == value)
        }
        
        let coordinator = SomeCoordinator()
        coordinator.setup(deeplinkHandlers: handler)
        coordinator.hitTest(with: path)?.respond(on: path)
    }
    
    
    func testRouteParserWithComponent() {
        enum Component: String {
            case value
        }
        
        let value = 10
        let path = "/some/path/\(value)"
        
        let handler = DeepLinkRoute(path: "/some/path" / Component.value) { json in
            let jsonValue = json[Component.value].intValue
            XCTAssertTrue(jsonValue == value)
        }
        
        let coordinator = SomeCoordinator()
        coordinator.setup(deeplinkHandlers: handler)
        coordinator.hitTest(with: path)?.respond(on: path)
    }
}
