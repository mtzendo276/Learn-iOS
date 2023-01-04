//
//  ViewController.swift
//  Test
//
//  Created by Chen Yue on 17/12/22.
//

import UIKit

class ViewModel {
    
    func run() async {
        print(Thread.current.threadName)
//        for i in 0...100 {
//            debugPrint("aaa: \(i)")
//            sleep(1)
//        }
    }
    
}

class ViewController: UIViewController {
    
    var vm: ViewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func onRun(_ sender: Any)  {
//                Task.detached(
//                    priority: .userInitiated,
        //            operation: {
        
//    })
        
        Task {
//        Task.detached(
//            priority: .userInitiated) {
            print(Thread.current.threadName)
//                await self.run()
                await self.vm.run()
        }
        
//        DispatchQueue.global(qos: .userInitiated).async {
//            print(Thread.current.threadName)
//            self.run()
//        }
//        run()
    }
    
    private func run() async{
        print(Thread.current.threadName)
    }
    
    @IBAction func onTest(_ sender: Any) {
        debugPrint("ontest")
        
    }
    
//    func fetch1() {
//        let url = URL(string: "https://google.com")!
//        let data = try! Data(contentsOf: url)
//        let string = String(data: data, encoding: .utf8) ?? ""
//        debugPrint(string)
//    }
//
//    func fetch2() async {
//        let url = URL(string: "https://google.com")!
//        let data = try! Data(contentsOf: url)
//        let string = String(data: data, encoding: .utf8) ?? ""
//        debugPrint(string)
//    }
    
}

extension Thread {

    var threadName: String {
        if let currentOperationQueue = OperationQueue.current?.name {
            return "OperationQueue: \(currentOperationQueue)"
        } else if let underlyingDispatchQueue = OperationQueue.current?.underlyingQueue?.label {
            return "DispatchQueue: \(underlyingDispatchQueue)"
        } else {
            let name = __dispatch_queue_get_label(nil)
            return String(cString: name, encoding: .utf8) ?? Thread.current.description
        }
    }
}
