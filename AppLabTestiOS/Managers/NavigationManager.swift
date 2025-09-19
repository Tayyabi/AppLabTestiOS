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
    case home = "Home"
    case weatherNews = "Weather News"
    case settings = "Settings"
    case aboutUs = "About Us"
    case contactUs = "Contact Us"

    var id: String { rawValue }

    var localizedKey: String {
        switch self {
        case .home:
            return "menu_home"
        case .weatherNews:
            return "menu_weather_news"
        case .settings:
            return "menu_settings"
        case .aboutUs:
            return "menu_about_us"
        case .contactUs:
            return "menu_contact_us"
        }
    }

    var destination: NavigationDestination? {
        switch self {
        case .home:
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

    @Published var selectedMenuItem: MenuItem = .home
    @Published var navigationPath = NavigationPath()
    @Published var isMenuOpen = false

    private init() {}

    /// Navigate to a specific destination
    func navigate(to destination: NavigationDestination) {
        switch destination {
        case .home:
            navigationPath = NavigationPath()
            selectedMenuItem = .home
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
        selectedMenuItem = .home
    }

    /// Go back one level
    func goBack() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }
}