//
//  Utils.swift
//  pass
//
//  Created by Mingshen Sun on 8/2/2017.
//  Copyright © 2017 Bob Sun. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
import KeychainAccess

public class Utils {
    public static func removeFileIfExists(atPath path: String) {
        let fm = FileManager.default
        do {
            if fm.fileExists(atPath: path) {
                try fm.removeItem(atPath: path)
            }
        } catch {
            print(error)
        }
    }
    public static func removeFileIfExists(at url: URL) {
        removeFileIfExists(atPath: url.path)
    }
    
    public static func getPasswordFromKeychain(name: String) -> String? {
        let keychain = Keychain(service: Globals.bundleIdentifier, accessGroup: Globals.groupIdentifier)
        do {
            return try keychain.getString(name)
        } catch {
            print(error)
        }
        return nil
    }
    
    public static func addPasswordToKeychain(name: String, password: String?) {
        let keychain = Keychain(service: Globals.bundleIdentifier, accessGroup: Globals.groupIdentifier)
        keychain[name] = password
    }
    
    public static func removeKeychain(name: String) {
        let keychain = Keychain(service: Globals.bundleIdentifier, accessGroup: Globals.groupIdentifier)
        do {
            try keychain.remove(name)
        } catch {
            print(error)
        }
    }
    
    public static func removeAllKeychain() {
        let keychain = Keychain(service: Globals.bundleIdentifier, accessGroup: Globals.groupIdentifier)
        do {
            try keychain.removeAll()
        } catch {
            print(error)
        }
    }
    public static func copyToPasteboard(textToCopy: String?) {
        guard textToCopy != nil else {
            return
        }
        UIPasteboard.general.string = textToCopy
    }
    public static func attributedPassword(plainPassword: String) -> NSAttributedString{
        let attributedPassword = NSMutableAttributedString.init(string: plainPassword)
        // draw all digits in the password into red
        // draw all punctuation characters in the password into blue
        for (index, element) in plainPassword.unicodeScalars.enumerated() {
            var charColor = UIColor.darkText
            if NSCharacterSet.decimalDigits.contains(element) {
                charColor = Globals.digitColor
            } else if !NSCharacterSet.letters.contains(element) {
                charColor = Globals.symbolColor
            } else {
                charColor = Globals.letterColor
            }
            attributedPassword.addAttribute(NSAttributedStringKey.foregroundColor, value: charColor, range: NSRange(location: index, length: 1))
        }
        return attributedPassword
    }
    public static func initDefaultKeys() {
        if SharedDefaults[.passwordGeneratorFlavor] == "" {
            SharedDefaults[.passwordGeneratorFlavor] = "Random"
        }
    }
    
    public static func alert(title: String, message: String, controller: UIViewController, handler: ((UIAlertAction) -> Void)? = nil, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: handler))
        controller.present(alert, animated: true, completion: completion)
    }
}

