//
//  ViewController.swift
//  AsyncTest
//
//  Created by Chen Yue on 4/01/23.
//

import UIKit

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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func fetchWeatherHistory() async -> [Double] {
        
        (1...100).map { _ in
            debugPrint("aaa")
            sleep(1)
            return Double.random(in: -10...30)
        }
    }

    func calculateAverageTemperature(for records: [Double]) async -> Double {
        let total = records.reduce(0, +)
        let average = total / Double(records.count)
        return average
    }

    func upload(result: Double) async -> String {
        "OK"
    }
    
    func processWeather() async {
        Task.detached(priority:.background) {
            print(Thread.current.threadName)
            let records = await self.fetchWeatherHistory()
            let average = await self.calculateAverageTemperature(for: records)
            let response = await self.upload(result: average)
           
            
            print("Server response: \(response)")
        }
    }

    @IBAction func onTest1(_ sender: Any) {
        debugPrint("onTest1 begin")
        Task.detached(priority:.background) {
            print(Thread.current.threadName)
             await self.processWeather()
        }
        debugPrint("onTest1 end")
    }
    
    @IBAction func onTest2(_ sender: Any) {
        debugPrint("onTest2")
    }
}

