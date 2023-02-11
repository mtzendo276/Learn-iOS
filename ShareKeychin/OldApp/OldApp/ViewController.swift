//
//  ViewController.swift
//  OldApp
//
//  Created by Chen Yue on 1/02/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let itemKey = "tokenKey"
//        let itemValue = inputText
        let keychainAccessGroupName = "G639TCDRRY.com.mtzendo.demo.keychainsharing"
        
        let queryLoad: [String: AnyObject] = [
          kSecClass as String: kSecClassGenericPassword,
          kSecAttrAccount as String: itemKey as AnyObject,
          kSecReturnData as String: kCFBooleanTrue,
          kSecMatchLimit as String: kSecMatchLimitOne,
          kSecAttrAccessGroup as String: keychainAccessGroupName as AnyObject
        ]

        var result: AnyObject?

        let resultCodeLoad = withUnsafeMutablePointer(to: &result) {
          SecItemCopyMatching(queryLoad as CFDictionary, UnsafeMutablePointer($0))
        }

        if resultCodeLoad == noErr {
          if let result = result as? Data,
            let keyValue = NSString(data: result,
                                    encoding: String.Encoding.utf8.rawValue) as? String {

            // Found successfully
            print(keyValue)
              
              let alert = UIAlertController(title: "From new app", message: keyValue, preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
              self.present(alert, animated: true, completion: nil)
          }
        } else {
          print("Error loading from Keychain: \(resultCodeLoad)")
        }
    }

}

