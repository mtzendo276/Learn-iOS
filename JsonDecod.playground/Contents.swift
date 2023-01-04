import UIKit

//var greeting = "Hello, playground"
struct BlogPost: Decodable {
    enum Category: String, Decodable {
        case swift, combine, debugging, xcode
    }

    let title: String
    let url: URL
    let category: Category
    let views: Int
}

let JSON = """
{
    "title": "Optionals in Swift explained: 5 things you should know",
    "url": "https://www.avanderlee.com/swift/optionals-in-swift-explained-5-things-you-should-know/",
    "category": "swift",
    "views": 47093
}
"""

let jsonData = JSON.data(using: .utf8)!
let blogPost: BlogPost = try! JSONDecoder().decode(BlogPost.self, from: jsonData)

print(blogPost.title)

struct TypeA: Codable {
    
}

struct TypeB: Codable {
    
}



enum Widget: Codable {
    
    case typeA(TypeA)
    case typeB(TypeB)
    
    private enum CodingKeys: String, CodingKey {
        case type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawType = try container.decode(String.self, forKey: .type)
        if let type = WidgetType(rawValue: rawType) {
            let widgetContainer = try decoder.singleValueContainer()
            do {
                
            } catch (let error) {
                print("Unable to properly mapped action with type: \(rawType). ERROR: \(error)")
                self = .unsupported
            }
        } else {
            self = .unsupported
            print("Unsupported action with type: \(rawType)")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
            
            case .unsupported:
                let context = EncodingError.Context(codingPath: [], debugDescription: "Invalid attachment.")
                throw EncodingError.invalidValue(self, context)
            }
        }
    
}
