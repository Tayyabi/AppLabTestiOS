//
//  ContentView.swift
//  AppLabTestiOS
//
//  Created by M Tayyab on 18/09/2025.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var navigationManager = NavigationManager.shared
    @StateObject private var localizationManager = LocalizationManager.shared

    var body: some View {
        NavigationStack(path: $navigationManager.navigationPath) {
            ZStack {
                // Side Menu (underneath)
                if navigationManager.isMenuOpen {
                    SideMenuView()
                        .zIndex(0)
                }

                // Main Content (on top)
                HomeView()
                    .zIndex(1)
            }
            .navigationDestination(for: NavigationDestination.self) { destination in
                destinationView(for: destination)
            }
        }
        .environment(\.layoutDirection, localizationManager.layoutDirection)
    }

    // MARK: - Destination View Builder
    @ViewBuilder
    private func destinationView(for destination: NavigationDestination) -> some View {
        switch destination {
        case .home:
            HomeView()
        case .weatherNews:
            WeatherNewsView()
        case .settings:
            SettingsView()
        }
    }
}

// MARK: - Settings View (Placeholder)
struct SettingsView: View {
    @StateObject private var localizationManager = LocalizationManager.shared
    @StateObject private var navigationManager = NavigationManager.shared

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.4)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {
                // Header
                HStack {
                    Button(action: {
                        navigationManager.goBack()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                    }

                    Spacer()

                    Text("menu_settings".localized)
                        .font(localizationManager.font(size: 22, weight: .medium))
                        .foregroundColor(.white)

                    Spacer()

                    // Invisible spacer for centering
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20))
                        .opacity(0)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)

                Spacer()

                // Settings Content
                VStack(spacing: 20) {
                    Image(systemName: "gear")
                        .font(.system(size: 80))
                        .foregroundColor(.white.opacity(0.8))

                    Text("Settings")
                        .font(localizationManager.font(size: 24, weight: .medium))
                        .foregroundColor(.white)

                    Text("Settings page coming soon...")
                        .font(localizationManager.font(size: 16))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }

                Spacer()
            }
        }
        .navigationBarHidden(true)
        .environment(\.layoutDirection, localizationManager.layoutDirection)
    }
}

#Preview {
    ContentView()
}
