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
                    
                    Spacer()
                    LazyVStack(spacing: 20) {
                        // Latest Weather News Section
                        newsHeaderSection
                        
                        // Current Weather Summary
                        if let weather = weatherViewModel.weatherData {
                            currentWeatherSummaryView(weather: weather)
                        }
                        
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    
                    
                    Spacer()
                    Spacer()
                    
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
            }
            
            // Title with fixed frame
            Text("weather_news_title".localized)
                .font(localizationManager.font(size: 20, weight: .medium))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity) // Takes up all available space and centers text
            
            // Invisible spacer element to balance the back button
            Spacer()
                .frame(width: 30, height: 30) // Same size as back button
        }
        .padding(.top, 10)
        .padding(.horizontal, 20)
    }
    
    // MARK: - News Header Section
    private var newsHeaderSection: some View {
        VStack(alignment: .center, spacing: 15) {
            
            Text("welcome".localized)
                .font(localizationManager.font(size: 24, weight: .semibold))
                .foregroundColor(.white)
            
            
            
            Text("weather_news_description".localized)
                .font(localizationManager.font(size: 16))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }
    
    // MARK: - Current Weather Summary
    private func currentWeatherSummaryView(weather: WeatherResult) -> some View {
        VStack(spacing: 15) {
            // Weather Overview Card
            HStack {
                AsyncImage(url: URL(string: weather.weatherIcon)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Image("sun_cloud")
                        .font(.system(size: 24))
                        .foregroundColor(.yellow)
                        .tint(.yellow)
                        .frame(width: 30, height: 30)
                    
                }
                .frame(width: 30, height: 30)
                VStack(alignment: .leading, spacing: 4) {
                    Text("weather_overview".localized)
                        .font(localizationManager.font(size: 14, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text(weather.formattedTemp)
                        .font(localizationManager.font(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .padding(20)
            .background(Color.white.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            
            // Humidity Card
            HStack {
                Image(systemName: "humidity")
                    .font(.system(size: 24))
                    .foregroundColor(.yellow)
                    .frame(width: 30, height: 30)
                VStack(alignment: .leading, spacing: 4) {
                    Text("humidity".localized)
                        .font(localizationManager.font(size: 14, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text(weather.humidity)
                        .font(localizationManager.font(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .padding(20)
            .background(Color.white.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            
            // Wind Speed Card
            HStack {
                Image(systemName: "wind")
                    .font(.system(size: 24))
                    .foregroundColor(.yellow)
                    .frame(width: 30, height: 30)
                VStack(alignment: .leading, spacing: 4) {
                    Text("wind_speed".localized)
                        .font(localizationManager.font(size: 14, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text(weather.formattedWindSpeed)
                        .font(localizationManager.font(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .padding(20)
            .background(Color.white.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }
}

#Preview {
    WeatherNewsView()
}
