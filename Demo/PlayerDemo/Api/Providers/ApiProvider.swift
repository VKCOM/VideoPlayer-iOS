import Foundation


protocol ApiProvider {
    
    var fullPath: String { get }
    
    func decode<Body>(response: Data) throws -> Body where Body: Decodable
}
