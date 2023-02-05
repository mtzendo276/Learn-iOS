import UIKit

/*
 The actor type is one of the concurrency-related improvements introduced in Swift 5.5. actor is a programming type just like its peers: enum, struct, class and so on. More specifically, it’s a reference type like class.

 The code looks quite familiar, too. Here’s the example from the previous section. This time, however, it replaces class with actor to make it thread-safe:
 */
actor Counter {
  private var count = 0

  func increment() {
    count += 1
  }
}
