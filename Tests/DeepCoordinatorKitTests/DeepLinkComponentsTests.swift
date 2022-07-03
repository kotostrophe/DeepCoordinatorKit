import XCTest
@testable import DeepCoordinatorKit

final class DeepLinkComponentsTests: XCTestCase {
    
    enum DeepLinkComponent: String {
        case id, value
    }
    
    func testStringToStringConcatination() {
        let result = "movie" / "id" / "cast"
        let target = "movie/id/cast"
        let wrongTarget = "movie/:id/cast"
        
        XCTAssertEqual(result, target, "Failed to concatinate strings and string")
        XCTAssertNotEqual(result, wrongTarget, "Failed to concatinate component and component")
    }
    
    func testStringToComponentConcatination() {
        let result = "movie" / DeepLinkComponent.id / "cast"
        let target = "movie/:id/cast"
        let wrongTarget = "movie/id/cast"
        
        XCTAssertEqual(result, target, "Failed to concatinate strings and component")
        XCTAssertNotEqual(result, wrongTarget, "Failed to concatinate component and component")
    }
    
    func testComponentToStringConcatination() {
        let result = DeepLinkComponent.id / "cast" / DeepLinkComponent.value
        let target = ":id/cast/:value"
        let wrongTarget = "id/cast/value"
        
        XCTAssertEqual(result, target, "Failed to concatinate component and component")
        XCTAssertNotEqual(result, wrongTarget, "Failed to concatinate component and component")
    }
    
    func testComponentToComponentConcatination() {
        let result = DeepLinkComponent.id / DeepLinkComponent.value
        let target = ":id/:value"
        let wrongTarget = "id/value"
        
        XCTAssertEqual(result, target, "Failed to concatinate component and component")
        XCTAssertNotEqual(result, wrongTarget, "Failed to concatinate component and component")
    }
}
