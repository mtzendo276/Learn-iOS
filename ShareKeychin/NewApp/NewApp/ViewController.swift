//
//  ViewController.swift
//  NewApp
//
//  Created by Chen Yue on 1/02/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tfMessage: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func onLaunchBtn(_ sender: Any) {
        guard let inputText = tfMessage.text, !inputText.isEmpty else {
            let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let itemKey = "tokenKey"
        let itemValue = inputText
        let keychainAccessGroupName = "G639TCDRRY.com.mtzendo.demo.keychainsharing"
        
        
        guard let valueData = itemValue.data(using: String.Encoding.utf8) else {
          print("Error saving text to Keychain")
          return
        }
        
        let queryDelete: [String: AnyObject] = [
          kSecClass as String: kSecClassGenericPassword,
          kSecAttrAccount as String: itemKey as AnyObject,
          kSecAttrAccessGroup as String: keychainAccessGroupName as AnyObject
        ]

        let resultCodeDelete = SecItemDelete(queryDelete as CFDictionary)

        if resultCodeDelete != noErr {
          print("Error deleting from Keychain: \(resultCodeDelete)")
        }
        

        let queryAdd: [String: AnyObject] = [
          kSecClass as String: kSecClassGenericPassword,
          kSecAttrAccount as String: itemKey as AnyObject,
          kSecValueData as String: valueData as AnyObject,
          kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked,
          kSecAttrAccessGroup as String: keychainAccessGroupName as AnyObject
        ]

        let resultCode = SecItemAdd(queryAdd as CFDictionary, nil)

        if resultCode != noErr {
          print("Error saving to Keychain: \(resultCode)")
//            let resultCode = SecItemUpdate(queryAdd as CFDictionary)
            //SecItemAdd(queryAdd as CFDictionary, nil)
        }
        
        
        
        if UIApplication.shared.canOpenURL(URL(string: "oldapp://dashboard")!) {
            UIApplication.shared.open(URL(string: "oldapp://dashboard")!)
        } else {
            debugPrint("no")
        }
    }
    

}

