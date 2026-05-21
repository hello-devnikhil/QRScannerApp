import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(url: URL) async throws -> T
}

class NetworkService: NetworkServiceProtocol {
    
    static let shared = NetworkService()
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func request<T: Decodable>(url: URL) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10.0 // 10 seconds timeout
        
        do {
            let (data, response) = try await urlSession.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIError.serverError(httpResponse.statusCode)
            }
            
            do {
                let decoder = JSONDecoder()
                // Use keyDecodingStrategy if necessary based on API, OpenFoodFacts uses snake_case usually
                // but we map it manually in our model if needed.
                return try decoder.decode(T.self, from: data)
            } catch {
                throw APIError.decodingError
            }
            
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
}
