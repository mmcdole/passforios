//
//  PasscodeLockDisplay.swift
//  pass
//
//  Created by Yishi Lin on 14/6/17.
//  Copyright © 2017 Bob Sun. All rights reserved.
//

import Foundation
import passKit

// cancel means cancel the extension
class PasscodeLockViewControllerForExtension: PasscodeLockViewController {
    var originalExtensionContest: NSExtensionContext?
    public convenience init(extensionContext: NSExtensionContext?) {
        self.init()
        originalExtensionContest = extensionContext
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButton?.removeTarget(nil, action: nil, for: .allEvents)
        cancelButton?.addTarget(self, action: #selector(cancelExtension), for: .touchUpInside)
    }
    @objc func cancelExtension() {
        originalExtensionContest?.completeRequest(returningItems: [], completionHandler: nil)
    }
}

class PasscodeExtensionDisplay {
    private var isPasscodePresented = false
    private let passcodeLockVC: PasscodeLockViewControllerForExtension
    private let extensionContext: NSExtensionContext?
    
    public init(extensionContext: NSExtensionContext?) {
        self.extensionContext = extensionContext
        passcodeLockVC = PasscodeLockViewControllerForExtension(extensionContext: extensionContext)
        passcodeLockVC.dismissCompletionCallback = { [weak self] in
            self?.dismiss()
        }
        passcodeLockVC.setCancellable(true)
    }
    
    // present the passcode lock view if passcode is set and the view controller is not presented
    public func presentPasscodeLockIfNeeded(_ extensionVC: UIViewController) {
        guard PasscodeLock.shared.hasPasscode && !isPasscodePresented == true else {
            return
        }
        isPasscodePresented = true
        extensionVC.present(passcodeLockVC, animated: true, completion: nil)
    }
    
    public func dismiss(animated: Bool = true) {
        isPasscodePresented = false
    }
}
