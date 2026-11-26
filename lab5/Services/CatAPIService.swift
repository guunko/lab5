import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case badResponse(Int)
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Некоректна адреса запиту"
        case .badResponse(let code):
            return "Сервер повернув помилку (код \(code))"
        case .decodingFailed:
            return "Не вдалося обробити відповідь сервера"
        }
    }
}

final class CatAPIService {

    private let baseURL = "https://api.thecatapi.com/v1"

    private let apiKey = "live_HYDLIZ8YKF9V5LbHqRrpXjD7cnzYk5NbtismpPAMjEWnwoyhhs1nGRMCmmUSnBbG"

    func fetchBreeds() async throws -> [CatBreed] {
        guard let url = URL(string: "\(baseURL)/breeds") else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if !apiKey.isEmpty {
            request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.badResponse(0)
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.badResponse(httpResponse.statusCode)
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode([CatBreed].self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
