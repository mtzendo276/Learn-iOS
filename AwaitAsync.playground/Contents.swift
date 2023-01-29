import UIKit

var greeting = "Hello, playground"

//Retrying a Task with an exponential delay.
//self.documents = try await Task.retried(times: 3) {
//  try await self.fetcher.fetchAllDocuments() // returns [Documents]
//}.value

extension Task {
  static func retried(times: Int, backoff: TimeInterval = 1.0, priority: TaskPriority? = nil, operation: @escaping @Sendable () async throws -> Success) -> Task where Failure == Error {
    Task(priority: priority) {
      for attempt in 0..<times {
        do {
          return try await operation()
        }
        catch {
          let exponentialDelay = UInt64(backoff * pow(2.0, Double(attempt)) * 1_000_000_000)
          try await Task<Never, Never>.sleep(nanoseconds: exponentialDelay)
          continue
        }
      }
      return try await operation()
    }
  }
}




/*
 Sometimes we have several independent tasks we need to complete. Let’s take an example when we want to preload messages for conversations. The code snippet below takes an array of conversations and then starts loading messages for each of the conversation. Since conversations are not related to each other, we can do this concurrently. This is what a TaskGroup enables us to do. We create a group and add tasks to it. Tasks in the group can run at the same time, which can be a time-saver.
 */



//func preloadMessages(for conversations: [Conversation]) async {
//  await withThrowingTaskGroup(of: Void.self) { taskGroup in
//    for conversation in conversations {
//      taskGroup.addTask {
//        try await self.preloadMessages(for: conversation)
//      }
//    }
//  }
//}

/*
 Calling async function from non-async context
 When using the await keyword then the current asynchronous context suspends until the awaited async function finishes. Suspension can only happen if we are in an asynchronous context. Therefore, a function without the async keyword can’t use await directly. Fortunately, we can create asynchronous contexts easily with a Task. One example of this is when we use MVVM in SwiftUI views and the view model has different methods we want to call when, for example, a user taps on a button
 */
//func refreshDocuments() {
//  Task(priority: .userInitiated) {
//    do {
//      self.documents = try await fetcher.fetchAllDocuments()
//    }
//    catch {
//      // Handle error
//    }
//  }
//}

//https://augmentedcode.io/2022/02/21/a-few-examples-of-async-await-in-swift/

//ref: https://www.avanderlee.com/swift/async-let-asynchronous-functions-in-parallel/

func loadImage(index: Int) async -> UIImage {
    let imageURL = URL(string: "https://picsum.photos/200/300")!
    let request = URLRequest(url: imageURL)
    let (data, _) = try! await URLSession.shared.data(for: request, delegate: nil)
    print("Finished loading image \(index)")
    return UIImage(data: data)!
}


func loadImages() {
    Task {
        async let firstImage = loadImage(index: 1)
        async let secondImage = loadImage(index: 2)
        async let thirdImage = loadImage(index: 3)
        let images = await [firstImage, secondImage, thirdImage]
    }
}


loadImages()
