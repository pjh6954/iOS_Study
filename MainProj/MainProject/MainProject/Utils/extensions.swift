//
//  extensions.swift
//  MainProject
//
//  Created by JunHo Park on 2023/02/27.
//

import UIKit

extension UINavigationController {
    // https://stackoverflow.com/questions/9906966/completion-handler-for-uinavigationcontroller-pushviewcontrolleranimated
    public func pushViewController(viewController: UIViewController, animated: Bool, completion: @escaping (() -> Void)) {
        // why remove '?'mark? : "Closure is already escaping in optional type argument. Remove '@escaping'" error.
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
}

