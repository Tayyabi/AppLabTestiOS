//
//  WeatherViewModel.swift
//  AppLabTestiOS
//
//  Created by M Tayyab on 19/09/2025.
//

import Foundation
import Combine

// MARK: - Weather View Model
@MainActor
class WeatherViewModel: ObservableObject {
    @Published var weatherData: WeatherResult?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var hasError = false

    private let networkManager = NetworkManager.shared
    private var cancellables = Set<AnyCancellable>()

    init() {
        loadWeatherData()
    }

    /// Load weather data from API
    func loadWeatherData() {
        isLoading = true
        hasError = false
        errorMessage = nil

        Task {
            do {
                let result = try await networkManager.fetchWeatherData()
                self.weatherData = result
                self.isLoading = false
            } catch {
                self.handleError(error)
            }
        }
    }

    /// Refresh weather data
    func refreshWeatherData() {
        loadWeatherData()
    }

    /// Handle network errors
    private func handleError(_ error: Error) {
        isLoading = false
        hasError = true

        if let networkError = error as? NetworkError {
            errorMessage = networkError.errorDescription
        } else {
            errorMessage = "data_error".localized
        }
    }

    /// Clear error state
    func clearError() {
        hasError = false
        errorMessage = nil
    }

    /// Get formatted date from weather data
    var formattedDate: String {
        guard let weatherData = weatherData else { return "" }

        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none

        // If dateTime is a timestamp, convert it
        if let timestamp = Double(weatherData.dateTime) {
            let date = Date(timeIntervalSince1970: timestamp)
            return formatter.string(from: date)
        }

        // If dateTime is already formatted, return as is
        return weatherData.dateTime
    }

    /// Check if data is available
    var hasWeatherData: Bool {
        return weatherData != nil
    }
}