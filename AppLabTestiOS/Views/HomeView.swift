//
//  HomeView.swift
//  AppLabTestiOS
//
//  Created by M Tayyab on 19/09/2025.
//

import SwiftUI
import Combine

struct HomeView: View {
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

                    if weatherViewModel.isLoading {
                        loadingView
                    } else if weatherViewModel.hasError {
                        errorView
                    } else {
                        weatherContentView
                    }

                    Spacer()
                }
                .padding(.horizontal, DeviceHelper.contentPadding)
                .padding(.top, DeviceHelper.isPad ? 60 : 50)
            }
            .cornerRadius(navigationManager.isMenuOpen ? 58 : 0)
            .shadow(color: .black.opacity(navigationManager.isMenuOpen ? 0.58 : 0),
                    radius: navigationManager.isMenuOpen ? 14 : 0, x: navigationManager.isMenuOpen ? 0 : -14, y:
                        navigationManager.isMenuOpen ? 14 : 0
            )
            .offset(x: navigationManager.isMenuOpen ? 229 : 0, y: navigationManager.isMenuOpen ? 14 : 0)
            .scaleEffect(navigationManager.isMenuOpen ? 0.7 : 1)
            .ignoresSafeArea()
        }
        
        .environment(\.layoutDirection, localizationManager.layoutDirection)
        .onTapGesture {
            if navigationManager.isMenuOpen {
                navigationManager.closeMenu()
            }
        }
        .refreshable {
            weatherViewModel.refreshWeatherData()
        }
    }
    
    // MARK: - Background View
    private var backgroundView: some View {
        Image("bgHome")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .clipped()
            .overlay(
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.3),
                        Color.clear,
                        Color.black.opacity(0.4)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack {
            // Hamburger Menu Button
            Button(action: {
                navigationManager.toggleMenu()
            }) {
                Image("menuIcon")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
            }
            .scaleButtonStyle()
            
            Spacer()
            
            // Logo
            Image(localizationManager.currentLanguage.logoImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: DeviceHelper.isPad ? 40 : 30)
                .fadeInEffect(delay: 0.2)
            
            Spacer()
            
            // Language Toggle Button
            Button(action: {
                localizationManager.toggleLanguage()
            }) {
                Text(localizationManager.currentLanguage == .english ? "ع" : "EN")
                    .font(localizationManager.font(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
            }
            .scaleButtonStyle()
        }
        .padding(.top, 10)
        .padding(.horizontal, 5)
        .fadeInEffect()
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
            
            Text("loading".localized)
                .font(localizationManager.font(size: 18, weight: .medium))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Error View
    private var errorView: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.white)
            
            Text(weatherViewModel.errorMessage ?? "error".localized)
                .font(localizationManager.font(size: 16))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: {
                weatherViewModel.refreshWeatherData()
            }) {
                Text("retry".localized)
                    .font(localizationManager.font(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(Color.blue.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Weather Content View
    private var weatherContentView: some View {
        VStack(spacing: 30) {
            // Current Weather
            if let weather = weatherViewModel.weatherData {
                currentWeatherView(weather: weather)
                    .slideInFromBottom()
            }
        }
        .padding(.top, 40)
    }
    
    // MARK: - Current Weather View
    private func currentWeatherView(weather: WeatherResult) -> some View {
        GeometryReader { geometry in
            ZStack {
                // Sun glare background - covers 80% of screen height
                Image("sun_glare")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.8)
                    .clipped()
                    .overlay(
                        // Overlay for better text readability
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0.2),
                                Color.black.opacity(0.1),
                                Color.black.opacity(0.3)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                // Weather content
                VStack(spacing: 15) {
                    // Top section with city and date aligned to leading
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            // City Name
                            Text(weather.city)
                                .font(localizationManager.font(size: DeviceHelper.titleSize, weight: .bold))
                                .foregroundColor(.white)
                            
                            // Date
                            Text(weatherViewModel.formattedDate)
                                .font(localizationManager.font(size: DeviceHelper.bodyTextSize))
                                .foregroundColor(.white.opacity(0.9))
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    // Center section with weather icon, temperature, description, feels like, and high/low
                    VStack(alignment: .leading, spacing: 12) {
                        // Weather Icon
                        if !weather.weatherIcon.isEmpty {
                            AsyncImage(url: URL(string: weather.weatherIcon)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } placeholder: {
                                Image("sun")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                            .frame(width: DeviceHelper.weatherIconSize, height: DeviceHelper.weatherIconSize)
                        }
                        
                        // Temperature
                        Text(weather.formattedTemp)
                            .font(localizationManager.font(size: DeviceHelper.temperatureSize, weight: .medium))
                            .foregroundColor(.white)
                        
                        // Weather Description
                        Text(weather.capitalizedWeather)
                            .font(localizationManager.font(size: DeviceHelper.subtitleSize, weight: .semibold))
                            .foregroundColor(.white.opacity(0.9))
                        
                        // Feels Like
                        Text("\("feels_like".localized) \(weather.feelsLike)")
                            .font(localizationManager.font(size: DeviceHelper.bodyTextSize))
                            .foregroundColor(.white.opacity(0.9))
                        
                        // High/Low in a row
                        HStack(spacing: 20) {
                            Text("\("high".localized):\(Int(weather.high))°")
                                .font(localizationManager.font(size: DeviceHelper.bodyTextSize, weight: .medium))
                                .foregroundColor(.white)
                            
                            Text("\("low".localized):\(Int(weather.low))°")
                                .font(localizationManager.font(size: DeviceHelper.bodyTextSize, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    // Weather Details Strip at bottom
                    VStack {
                        Spacer()
                        weatherDetailsView(weather: weather)
                            .fadeInEffect(delay: 0.3)
                    }
                }
                .frame(height: geometry.size.height * 0.8)
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color.black.opacity(0.2), radius: 15, x: 0, y: 8)
        }
        .frame(height: UIScreen.main.bounds.height * 0.7)
    }
    
    // MARK: - Weather Details View
    private func weatherDetailsView(weather: WeatherResult) -> some View {
        Group {
            if DeviceHelper.isPad {
                // iPad: Use responsive grid layout
                ResponsiveGrid(minItemWidth: 200) {
                    weatherDetailItem(
                        icon: "ic_humidity",
                        title: "humidity".localized,
                        value: weather.humidity
                    )
                    weatherDetailItem(
                        icon: weather.windDirectionIcon,
                        title: "wind_direction".localized,
                        value: weather.windDirection
                    )
                    
                    weatherDetailItem(
                        icon: "ic_wind",
                        title: "wind_speed".localized,
                        value: weather.formattedWindSpeed
                    )
                }
                .padding(.horizontal, DeviceHelper.contentPadding)
            } else {
                // iPhone: Use HStack layout
                HStack(spacing: 20) {
                    weatherDetailItem(
                        icon: "ic_humidity",
                        title: "humidity".localized,
                        value: weather.humidity
                    )
                    
                    weatherDetailItem(
                        icon: weather.windDirectionIcon,
                        title: "wind_direction".localized,
                        value: weather.windDirection
                    )
                    
                    weatherDetailItem(
                        icon: "ic_wind",
                        title: "wind_speed".localized,
                        value: weather.formattedWindSpeed
                    )
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.vertical, 15)
        .background(Color.white)
        .clipShape(
            .rect(
                topLeadingRadius: 0,
                bottomLeadingRadius: 20,
                bottomTrailingRadius: 20,
                topTrailingRadius: 0
            )
        )
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Weather Detail Item
    private func weatherDetailItem(icon: String, title: String, value: String) -> some View {
        HStack(spacing: DeviceHelper.adaptiveSpacing(base: 10)) {
            Image(icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: DeviceHelper.isPad ? 32 : 24, height: DeviceHelper.isPad ? 32 : 24)
                .foregroundColor(.gray.opacity(0.8))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(localizationManager.font(size: DeviceHelper.smallTextSize))
                    .foregroundColor(.gray)
                
                Text(value)
                    .font(localizationManager.font(size: DeviceHelper.bodyTextSize, weight: .medium))
                    .foregroundColor(.black)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
}

#Preview {
    HomeView()
}
