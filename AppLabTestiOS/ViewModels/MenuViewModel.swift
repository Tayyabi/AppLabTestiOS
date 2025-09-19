//
//  MenuViewModel.swift
//  AppLabTestiOS
//
//  Created by M Tayyab on 19/09/2025.
//

import Foundation
import SwiftUI
import Combine

// MARK: - Menu View Model
class MenuViewModel: ObservableObject {
    @Published var menuItems: [MenuItem] = MenuItem.allCases
    @Published var selectedItem: MenuItem = .home

    private let navigationManager = NavigationManager.shared
    private let localizationManager = LocalizationManager.shared

    init() {
        // Observe navigation manager for selected menu item changes
        selectedItem = navigationManager.selectedMenuItem
    }

    /// Handle menu item selection
    func selectMenuItem(_ item: MenuItem) {
        selectedItem = item
        navigationManager.navigate(to: item)
    }

    /// Check if menu item is currently selected
    func isSelected(_ item: MenuItem) -> Bool {
        return selectedItem == item
    }

    /// Get localized title for menu item
    func localizedTitle(for item: MenuItem) -> String {
        return item.localizedKey.localized
    }

    /// Close the menu
    func closeMenu() {
        navigationManager.closeMenu()
    }

    /// Toggle language
    func toggleLanguage() {
        localizationManager.toggleLanguage()
    }

    /// Get current language display name
    var currentLanguageDisplayName: String {
        return localizationManager.currentLanguage.displayName
    }

    /// Get current language logo
    var currentLanguageLogo: String {
        return localizationManager.currentLanguage.logoImageName
    }

    /// Get layout direction
    var layoutDirection: LayoutDirection {
        return localizationManager.layoutDirection
    }
}
