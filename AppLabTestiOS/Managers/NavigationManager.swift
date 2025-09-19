//
//  NavigationManager.swift
//  AppLabTestiOS
//
//  Created by M Tayyab on 19/09/2025.
//

import SwiftUI
import Foundation
import Combine

// MARK: - Navigation Destinations
enum NavigationDestination: Hashable {
    case home
    case weatherNews
    case settings
}

// MARK: - Menu Items
enum MenuItem: String, CaseIterable, Identifiable {
    case dashboard = "Dashboard"
    case weatherNews = "Weather News"
    case rainRadar = "Rain Radar"
    case weatherStations = "Weather Stations"
    case notificationCenter = "Notification Center"
    case monthlyReports = "Monthly Reports"
    case worldwideCities = "Worldwide Cities"
    case aboutUs = "About Us"
    case settings = "Settings"
    case disclaimer = "Disclaimer"

    var id: String { rawValue }

    var localizedKey: String {
        switch self {
        case .dashboard:
            return "menu_dashboard"
        case .weatherNews:
            return "menu_weather_news"
        case .rainRadar:
            return "menu_rain_radar"
        case .weatherStations:
            return "menu_weather_stations"
        case .notificationCenter:
            return "menu_notification_center"
        case .monthlyReports:
            return "menu_monthly_reports"
        case .worldwideCities:
            return "menu_worldwide_cities"
        case .aboutUs:
            return "menu_about_us"
        case .settings:
            return "menu_settings"
        case .disclaimer:
            return "menu_disclaimer"
        }
    }

    var destination: NavigationDestination? {
        switch self {
        case .dashboard:
            return .home
        case .weatherNews:
            return .weatherNews
        case .settings:
            return .settings
        default:
            return nil
        }
    }

    var isNavigable: Bool {
        return destination != nil
    }
}

// MARK: - Navigation Manager
class NavigationManager: ObservableObject {
    static let shared = NavigationManager()

    @Published var selectedMenuItem: MenuItem = .dashboard
    @Published var navigationPath = NavigationPath()
    @Published var isMenuOpen = false

    private init() {}

    /// Navigate to a specific destination
    func navigate(to destination: NavigationDestination) {
        switch destination {
        case .home:
            navigationPath = NavigationPath()
            selectedMenuItem = .dashboard
        case .weatherNews:
            navigationPath.append(destination)
            selectedMenuItem = .weatherNews
        case .settings:
            navigationPath.append(destination)
            selectedMenuItem = .settings
        }
        closeMenu()
    }

    /// Navigate to a menu item
    func navigate(to menuItem: MenuItem) {
        if let destination = menuItem.destination {
            navigate(to: destination)
        }
        selectedMenuItem = menuItem
        closeMenu()
    }

    /// Open side menu
    func openMenu() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isMenuOpen = true
        }
    }

    /// Close side menu
    func closeMenu() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isMenuOpen = false
        }
    }

    /// Toggle menu state
    func toggleMenu() {
        if isMenuOpen {
            closeMenu()
        } else {
            openMenu()
        }
    }

    /// Pop to root view
    func popToRoot() {
        navigationPath = NavigationPath()
        selectedMenuItem = .dashboard
    }

    /// Go back one level
    func goBack() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }
}