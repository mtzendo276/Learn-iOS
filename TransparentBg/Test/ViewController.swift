//
//  ViewController.swift
//  Test
//
//  Created by Chen Yue on 3/02/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func onShowBtn(_ sender: Any) {
        let vc = SecondViewController.loadFromNib()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
            
    }
}


extension UIViewController {
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }
        return instantiateFromNib()
    }
}
