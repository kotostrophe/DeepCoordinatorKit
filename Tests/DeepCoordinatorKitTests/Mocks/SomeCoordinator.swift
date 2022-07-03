//
//  File.swift
//  
//
//  Created by Тарас Коцур on 03.07.2022.
//

import UIKit
import CoordinatorKit
@testable import DeepCoordinatorKit

final class SomeCoordinator: Coordinatable, DeepLinkResponder {
    
    // MARK: - Properties
    
    var rootViewController: UIViewController?
    var deepLinkLocator: DeepLinkLocatorProtocol = DeepLinkLocator()
    var childLocator: CoordinatorLocatorProtocol = CoordinatorLocator()
    weak var parent: Coordinatable?
    
    // MARK: - Initializers
    
    init() {
        
    }
    
    // MARK: - Methods
    
    func start(animated: Bool) {
        
    }
    
    func finish(animated: Bool) {
        parent = nil
    }
    
    func setup(deeplinkHandlers: DeepLinkRoute...) {
        deepLinkLocator.add(routes: deeplinkHandlers)
    }
}
