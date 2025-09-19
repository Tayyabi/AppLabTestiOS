//
//  NetworkManager.swift
//  AppLabTestiOS
//
//  Created by M Tayyab on 19/09/2025.
//

import Foundation
import Combine

// MARK: - Network Manager
class NetworkManager: ObservableObject {
    static let shared = NetworkManager()

    private let weatherURL = "https://raw.githubusercontent.com/Krishnarajsalim/JSON/refs/heads/main/weather.json"
    private let session = URLSession.shared

    private init() {}

    /// Fetch weather data from the API
    func fetchWeatherData() async throws -> WeatherResult {
        guard let url = URL(string: weatherURL) else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }

        do {
            let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)

            guard weatherResponse.response.status else {
                throw NetworkError.apiError(weatherResponse.response.message)
            }

            return weatherResponse.response.result
        } catch let decodingError as DecodingError {
            print("Decoding error: \(decodingError)")
            throw NetworkError.decodingError
        } catch {
            print("Network error: \(error)")
            throw NetworkError.unknown(error)
        }
    }

    /// Fetch weather data with completion handler (alternative approach)
    func fetchWeatherData(completion: @escaping (Result<WeatherResult, NetworkError>) -> Void) {
        guard let url = URL(string: weatherURL) else {
            completion(.failure(.invalidURL))
            return
        }

        session.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(.unknown(error)))
                    return
                }

                guard let data = data,
                      let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    completion(.failure(.invalidResponse))
                    return
                }

                do {
                    let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)

                    guard weatherResponse.response.status else {
                        completion(.failure(.apiError(weatherResponse.response.message)))
                        return
                    }

                    completion(.success(weatherResponse.response.result))
                } catch {
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
}

// MARK: - Network Errors
enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError
    case apiError(String)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL error")
        case .invalidResponse:
            return NSLocalizedString("Invalid response from server", comment: "Invalid response error")
        case .decodingError:
            return NSLocalizedString("Failed to decode data", comment: "Decoding error")
        case .apiError(let message):
            return message
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}