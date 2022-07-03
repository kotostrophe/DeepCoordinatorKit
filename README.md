# DeepCoordinatorKit

[![CI](https://github.com/kotostrophe/DeepCoordinatorKit/actions/workflows/DeepCoordinatorKitTests.yml/badge.svg?branch=main&event=push)](https://github.com/kotostrophe/DeepCoordinatorKit/actions/workflows/DeepCoordinatorKitTests.yml)


Lightweight library that pass deeplinks trought coordiantor tree and respond on them. Depends on [CoordinatorKit](https://github.com/kotostrophe/CoordinatorKit).

## Navigation

- [Installation](#installation)
    - [Swift Package Manager](#swift-package-manager)
    - [Manually](#manually)
- [Usage](#usage)

## Installation

Ready to use on iOS 9+

### Swift Package Manager

In Xcode go to `File`  → `Packages`  → `Update to Latest Package Versions` and insert url: 

```url
https://github.com/kotostrophe/DeepCoordiantorKit
```

or add it to the `dependencies` value of your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/kotostrophe/CoordinatorKit", from: "1.0.0"),
]
```


### Manually

If you prefer not to use any of dependency managers, you can integrate manually. Put `Sources/DeepCoordiantorKit` folder in your Xcode project. Make sure to enable `Copy items if needed` and `Create groups`.

> Library is developed with dependency of another library called [CoordinatorKit](https://github.com/kotostrophe/CoordinatorKit). If you decided to add this library manually then do that with [depended part](https://github.com/kotostrophe/CoordinatorKit).


## Usage

`DeepLinkResponder` it's a base protocol that help to pass deeplink throught the nodes. By default protocol `DeepLinkResponder` uses only `Coordinatable` protocol from [CoordinatorKit](https://github.com/kotostrophe/CoordinatorKit). It help for building tree-like structure from nodes.

```swift
public protocol DeepLinkResponder: AnyObject {
    var deepLinkLocator: DeepLinkLocatorProtocol { get }    // store all the deeplink handler for this object

    func becomeFirstResponder(child: DeepLinkResponder?)        // run in case of first responder
    func canRespond(on path: String) -> Bool                // helps to check is deeplink path can be handled by this object
    func respond(on path: String)                           // activates handler that respond on deeplink path
    func hitTest(with path: String) -> DeepLinkResponder?   // mechanism of searching deeplink path responder
}
```

Deeplink passing throught the initial node (root) and searching node that can respond on it.
Protocol `DeepLinkResponder` have default body methods. Check that in file [Coordinatable+DeepLinkResponder.swift](https://github.com/kotostrophe/DeepCoordinatorKit/blob/main/Sources/DeepCoordinatorKit/Extensions/Coordinator%2BDeepLinkResponder.swift)

Default realization of `canRespond(on:)` method compare all available routes with deeplink route path. If any route with similar path exists then `return true`.

```swift
func canRespond(on path: String) -> Bool {
    deepLinkLocator.routes
        .contains(where: { route in path == route })
}
```

Default realization of `respond(on:)` method find first responder with similar path and prepare action if handler exists.

```swift
func respond(on path: String) {
    deepLinkLocator.routes
        .first(where: { route in path == route })?
        .prepareAction(with: path)()
}
```

`hitTest(with:)` it is main method of handling deeplink. It composit two previous methods `canRespond(on:)` and `respond(on:)`. It uses recoursive mechanism to find deeplink responder. By the structure it looks like [graph depth-first search](https://en.wikipedia.org/wiki/Depth-first_search).

> `hitTest(with:)` must be called to the initial point (root) of coordinators tree

```swift
func hitTest(with path: String) -> DeepLinkResponder? {
    if canRespond(on: path) { return self }
    for targetResponder in childLocator.coordiantors.compactMap({ $0 as? DeepLinkResponder }) {
        guard let targetResponder = targetResponder.hitTest(with: path) else { continue }
        return targetResponder
    }
    return nil
}
```

#### Example

`applicationCoordinator` uses a initial point of nodes tree. When deeplink passes trought the application it activates method `findFirstResponderIfNeeded(of:)` that run method `hitTest(with:)` inside of it. When responder will be found it will respond on deeplink.

```swift
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Properties
    
    var applicationCoordinator: ApplicationCoordinatorProtocol?
    var window: UIWindow?

    // MARK: - UIWindowSceneDelegate
    
    ...
    
    func scene(_ scene: UIScene, openURLContexts urlContexts: Set<UIOpenURLContext>) {
        findFirstResponderIfNeeded(of: urlContexts.first?.url.path)
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        findFirstResponderIfNeeded(of: userActivity.webpageURL?.path)
    }
    
    // MARK: - Deeplink
    
    func findFirstResponderIfNeeded(of deeplinkPath: String?) {
        guard let path = deeplinkPath else { return }
        guard let firstResponder = applicationCoordinator?.hitTest(with: path) else { return }
        firstResponder.becomeFirstResponder(child: nil)
        firstResponder.respond(on: path)
    }
}
```

## Example app

In the repository [deeplink-responder](https://github.com/kotostrophe/deeplink-responder) presented example of coordiantor pattern via using `CoordinatorKit`. As an addition there was developed deeplink handling mechanism via `DeepCoordinatorKit`.
