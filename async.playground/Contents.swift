import UIKit

var greeting = "Hello, playground"

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
