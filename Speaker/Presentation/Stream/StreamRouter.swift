//
//  StreamRouter.swift
//  Speaker
//
//  Created by Денис Ледовский on 28.08.2024.
//

import UIKit

protocol StreamRouterInterface: AnyObject {

}

class StreamRouter: NSObject {
    weak var controller: UIViewController?
}

// MARK: - StreamRouterInterface

extension StreamRouter: StreamRouterInterface {

}
