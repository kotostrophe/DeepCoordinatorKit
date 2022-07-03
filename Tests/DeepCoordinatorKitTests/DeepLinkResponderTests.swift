import XCTest
@testable import DeepCoordinatorKit

final class DeepLinkResponderTests: XCTestCase {
    
    func testCanRespond() {
        let handler = DeepLinkRoute(path: "/some/path") { _ in }
        let handlerWithValue = DeepLinkRoute(path: "/some/path/:id") { _ in }
        
        let parentCoordinator = SomeCoordinator()
        let childCoordinator = SomeCoordinator()
        childCoordinator.setup(deeplinkHandlers: handler, handlerWithValue)
        
        XCTAssertTrue(
            childCoordinator.canRespond(on: handler.path),
            "Children object must respond with active handler"
        )
        
        XCTAssertFalse(
            childCoordinator.canRespond(on: "/another/path"),
            "Children object must respond with active handler"
        )
        
        XCTAssertTrue(
            childCoordinator.canRespond(on: "/some/path/123"),
            "Children object must respond with active handler"
        )
        
        XCTAssertFalse(
            parentCoordinator.canRespond(on: handler.path),
            "Parent object mustn't respond with active handler"
        )
    }
    
    func testRespond() {
        let handler = DeepLinkRoute(path: "/some/path") { _ in
            XCTAssertTrue(true)
        }
        
        let coordinator = SomeCoordinator()
        coordinator.setup(deeplinkHandlers: handler)
        coordinator.respond(on: "/another/path")
    }
    
    func testHitTest() {
        let handler = DeepLinkRoute(path: "/some/path") { _ in }
        let secondHandler = DeepLinkRoute(path: "/some/path/:value") { _ in }
        
        let coordinator = SomeCoordinator()
        coordinator.setup(deeplinkHandlers: handler, secondHandler)
        
        let firstTargetCoordinator = coordinator.hitTest(with: "/some/path")
        XCTAssertNotNil(
            firstTargetCoordinator,
            "First object must be nil, because of there mustn't be a handler. Something going wrong"
        )
        
        let secondTargetCoordinator = coordinator.hitTest(with: "/another/path")
        XCTAssertNil(
            secondTargetCoordinator,
            "Second object must be nil, because of there mustn't be a handler. Something going wrong"
        )
        
        let thirdCoordinator = coordinator.hitTest(with: "/some/path/10")
        XCTAssertNotNil(
            thirdCoordinator,
            "Third object must be nil, because of there mustn't be a handler. Something going wrong"
        )
    }
    
    func testHitTestRecoursively() {
        let handler = DeepLinkRoute(path: "/some/path") { _ in }
        let secondHandler = DeepLinkRoute(path: "/some/path/:value") { _ in }
        
        let parentCoordinator = SomeCoordinator()
        let childCoordinator = SomeCoordinator()
        parentCoordinator.childLocator.push(childCoordinator)
        childCoordinator.setup(deeplinkHandlers: handler, secondHandler)
        
        let firstTargetCoordinator = parentCoordinator.hitTest(with: "/some/path")
        XCTAssertTrue(
            firstTargetCoordinator != nil && firstTargetCoordinator === childCoordinator,
            "First object must be nil, because of there mustn't be a handler. Something going wrong"
        )
        
        let secondTargetCoordinator = parentCoordinator.hitTest(with: "/another/path")
        XCTAssertTrue(
            secondTargetCoordinator == nil && secondTargetCoordinator !== childCoordinator,
            "Second object must be nil, because of there mustn't be a handler. Something going wrong"
        )
        
        let thirdCoordinator = parentCoordinator.hitTest(with: "/some/path/10")
        XCTAssertTrue(
            thirdCoordinator != nil && thirdCoordinator === childCoordinator,
            "Third object must be nil, because of there mustn't be a handler. Something going wrong"
        )
    }
    
    func testHitTestRecoursivelyShort() {
        let path = "/some/path"
        let expectation = XCTestExpectation(description: "Extected to run handler by path `\(path)`")
        
        let handler = DeepLinkRoute(path: path) { _ in
            expectation.fulfill()
        }
        
        let parentCoordinator = SomeCoordinator()
        let childCoordinator = SomeCoordinator()
        parentCoordinator.childLocator.push(childCoordinator)
        childCoordinator.setup(deeplinkHandlers: handler)
        
        parentCoordinator.start(deeplink: path)
    }
    
    func testHitTestRecoursivelyShortInverted() {
        let path = "/some/path"
        let targetPath = "/another/path"
        let expectation = XCTestExpectation(description: "Nothing is expecting. Handler mustn't run")
        
        let handler = DeepLinkRoute(path: path) { _ in
            XCTAssertFalse(true, "Handler mustn't run cause of different paths (\(path), \(targetPath)")
        }
        
        let parentCoordinator = SomeCoordinator()
        let childCoordinator = SomeCoordinator()
        parentCoordinator.childLocator.push(childCoordinator)
        childCoordinator.setup(deeplinkHandlers: handler)
        
        parentCoordinator.start(deeplink: targetPath)
        
        DispatchQueue.main.async {
            expectation.fulfill()
        }
    }
    
    func testBecomeFirstResponderWithTabBar() {
        let firstViewController = UIViewController()
        let firstCoordinator = SomeCoordinator()
        firstCoordinator.rootViewController = firstViewController
        
        let secondViewController = UIViewController()
        let secondCoordinator = SomeCoordinator()
        secondCoordinator.rootViewController = secondViewController
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [firstViewController, secondViewController]
        tabBarController.selectedIndex = 1
        let rootCoordinator = SomeCoordinator()
        rootCoordinator.rootViewController = tabBarController
        firstCoordinator.parent = rootCoordinator
        secondCoordinator.parent = rootCoordinator
        
        firstCoordinator.becomeFirstResponder()
        XCTAssertTrue(tabBarController.selectedIndex == 0)
        
        secondCoordinator.becomeFirstResponder()
        XCTAssertTrue(tabBarController.selectedIndex == 1)
    }
}
