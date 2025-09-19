//
//  WeatherNewsView.swift
//  AppLabTestiOS
//
//  Created by M Tayyab on 19/09/2025.
//

import SwiftUI
import Combine

struct WeatherNewsView: View {
    @StateObject private var weatherViewModel = WeatherViewModel()
    @StateObject private var localizationManager = LocalizationManager.shared
    @StateObject private var navigationManager = NavigationManager.shared

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                backgroundView
                    .ignoresSafeArea()

                // Content
                VStack(spacing: 0) {
                    headerView

                    ScrollView {
                        LazyVStack(spacing: 20) {
                            // Latest Weather News Section
                            newsHeaderSection

                            // Current Weather Summary
                            if let weather = weatherViewModel.weatherData {
                                currentWeatherSummaryView(weather: weather)
                            }

                            // Weather Forecast Cards
                            weatherForecastSection

                            // Weather Tips Section
                            weatherTipsSection
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .environment(\.layoutDirection, localizationManager.layoutDirection)
        .navigationBarHidden(true)
        .onAppear {
            if weatherViewModel.weatherData == nil {
                weatherViewModel.loadWeatherData()
            }
        }
    }

    // MARK: - Background View
    private var backgroundView: some View {
        Image("bgWithWaves")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .overlay(
                LinearGradient(
                    colors: [
                        Color.blue.opacity(0.8),
                        Color.blue.opacity(0.3),
                        Color.blue.opacity(0.6)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
    }

    // MARK: - Header View
    private var headerView: some View {
        HStack {
            // Back Button
            Button(action: {
                navigationManager.goBack()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
            }

            Spacer()

            // Title
            Text("weather_news_title".localized)
                .font(localizationManager.font(size: 22, weight: .medium))
                .foregroundColor(.white)

            Spacer()

            // Share Button
            Button(action: {
                shareWeatherNews()
            }) {
                Image("shareIcon")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
            }
        }
        .padding(.top, 10)
        .padding(.horizontal, 20)
    }

    // MARK: - News Header Section
    private var newsHeaderSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("latest_weather_updates".localized)
                    .font(localizationManager.font(size: 24, weight: .light))
                    .foregroundColor(.white)

                Spacer()
            }

            Text("weather_forecast".localized)
                .font(localizationManager.font(size: 16))
                .foregroundColor(.white.opacity(0.9))
        }
        .padding(.top, 20)
    }

    // MARK: - Current Weather Summary
    private func currentWeatherSummaryView(weather: WeatherResult) -> some View {
        VStack(spacing: 15) {
            HStack {
                Text("Current Conditions in \(weather.city)")
                    .font(localizationManager.font(size: 20, weight: .medium))
                    .foregroundColor(.white)

                Spacer()
            }

            HStack(spacing: 20) {
                // Weather Icon
                AsyncImage(url: URL(string: weather.weatherIcon)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Image("sun")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .frame(width: 60, height: 60)

                VStack(alignment: .leading, spacing: 5) {
                    Text(weather.formattedTemp)
                        .font(localizationManager.font(size: 28, weight: .light))
                        .foregroundColor(.white)

                    Text(weather.weather)
                        .font(localizationManager.font(size: 16))
                        .foregroundColor(.white.opacity(0.9))

                    Text("\("feels_like".localized) \(weather.feelsLike)")
                        .font(localizationManager.font(size: 14))
                        .foregroundColor(.white.opacity(0.8))
                }

                Spacer()
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }

    // MARK: - Weather Forecast Section
    private var weatherForecastSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("7-Day Forecast")
                    .font(localizationManager.font(size: 20, weight: .medium))
                    .foregroundColor(.white)

                Spacer()
            }

            // Sample forecast cards (in a real app, this would come from API)
            LazyVStack(spacing: 10) {
                ForEach(sampleForecastData, id: \.day) { forecast in
                    forecastCardView(forecast: forecast)
                }
            }
        }
    }

    // MARK: - Forecast Card View
    private func forecastCardView(forecast: ForecastDay) -> some View {
        HStack(spacing: 15) {
            // Day
            Text(forecast.day)
                .font(localizationManager.font(size: 16, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 80, alignment: .leading)

            // Weather Icon
            Image(forecast.icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)

            // Weather Description
            Text(forecast.description)
                .font(localizationManager.font(size: 14))
                .foregroundColor(.white.opacity(0.9))
                .frame(maxWidth: .infinity, alignment: .leading)

            // Temperature Range
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(forecast.high)°")
                    .font(localizationManager.font(size: 16, weight: .medium))
                    .foregroundColor(.white)

                Text("\(forecast.low)°")
                    .font(localizationManager.font(size: 14))
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    // MARK: - Weather Tips Section
    private var weatherTipsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Weather Tips")
                    .font(localizationManager.font(size: 20, weight: .medium))
                    .foregroundColor(.white)

                Spacer()
            }

            LazyVStack(spacing: 10) {
                ForEach(weatherTips, id: \.title) { tip in
                    weatherTipCardView(tip: tip)
                }
            }
        }
        .padding(.top, 10)
    }

    // MARK: - Weather Tip Card View
    private func weatherTipCardView(tip: WeatherTip) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: tip.icon)
                    .font(.system(size: 20))
                    .foregroundColor(.white)

                Text(tip.title)
                    .font(localizationManager.font(size: 16, weight: .medium))
                    .foregroundColor(.white)

                Spacer()
            }

            Text(tip.description)
                .font(localizationManager.font(size: 14))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.leading)
        }
        .padding(15)
        .background(Color.white.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Share Weather News
    private func shareWeatherNews() {
        guard let weather = weatherViewModel.weatherData else { return }

        let shareText = """
        Weather News Update:

        Current conditions in \(weather.city):
        \(weather.formattedTemp) - \(weather.weather)
        Feels like \(weather.feelsLike)

        High: \(Int(weather.high))° | Low: \(Int(weather.low))°
        Humidity: \(weather.humidity)
        Wind: \(weather.formattedWindSpeed)

        Stay weather-aware! 🌤️
        """

        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }

    // MARK: - Sample Data
    private var sampleForecastData: [ForecastDay] {
        [
            ForecastDay(day: "Today", icon: "sun", description: "Sunny", high: 28, low: 18),
            ForecastDay(day: "Tomorrow", icon: "sun", description: "Partly Cloudy", high: 26, low: 16),
            ForecastDay(day: "Saturday", icon: "sun", description: "Mostly Sunny", high: 29, low: 19),
            ForecastDay(day: "Sunday", icon: "sun", description: "Sunny", high: 31, low: 21),
            ForecastDay(day: "Monday", icon: "sun", description: "Hot", high: 33, low: 23),
            ForecastDay(day: "Tuesday", icon: "sun", description: "Very Hot", high: 35, low: 25),
            ForecastDay(day: "Wednesday", icon: "sun", description: "Sunny", high: 32, low: 22)
        ]
    }

    private var weatherTips: [WeatherTip] {
        [
            WeatherTip(
                icon: "sun.max.fill",
                title: "Sun Protection",
                description: "High UV levels expected. Wear sunscreen, protective clothing, and seek shade during peak hours (10 AM - 4 PM)."
            ),
            WeatherTip(
                icon: "drop.fill",
                title: "Stay Hydrated",
                description: "Hot weather increases dehydration risk. Drink plenty of water throughout the day, even if you don't feel thirsty."
            ),
            WeatherTip(
                icon: "wind",
                title: "Wind Advisory",
                description: "Moderate winds expected. Secure outdoor items and be cautious when driving high-profile vehicles."
            )
        ]
    }
}

// MARK: - Supporting Data Structures
struct ForecastDay {
    let day: String
    let icon: String
    let description: String
    let high: Int
    let low: Int
}

struct WeatherTip {
    let icon: String
    let title: String
    let description: String
}

#Preview {
    WeatherNewsView()
}