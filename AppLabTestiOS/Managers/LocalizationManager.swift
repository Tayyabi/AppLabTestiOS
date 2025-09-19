//
//  LocalizationManager.swift
//  AppLabTestiOS
//
//  Created by M Tayyab on 19/09/2025.
//

import SwiftUI
import Foundation
import Combine

// MARK: - Supported Languages
enum SupportedLanguage: String, CaseIterable {
    case english = "en"
    case arabic = "ar"

    var displayName: String {
        switch self {
        case .english:
            return "English"
        case .arabic:
            return "العربية"
        }
    }

    var fontName: String {
        switch self {
        case .english:
            return "Effra"
        case .arabic:
            return "Cairo"
        }
    }

    var isRTL: Bool {
        return self == .arabic
    }

    var logoImageName: String {
        switch self {
        case .english:
            return "logo_en"
        case .arabic:
            return "logo_ar"
        }
    }
}

// MARK: - Localization Manager
class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()

    @Published var currentLanguage: SupportedLanguage = .english

    private init() {
        // Load saved language preference
        if let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage"),
           let language = SupportedLanguage(rawValue: savedLanguage) {
            currentLanguage = language
        }
    }

    /// Switch to a specific language
    func switchLanguage(to language: SupportedLanguage) {
        currentLanguage = language
        UserDefaults.standard.set(language.rawValue, forKey: "selectedLanguage")
    }

    /// Get localized string for key
    func localizedString(for key: String) -> String {
        guard let path = Bundle.main.path(forResource: currentLanguage.rawValue, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return NSLocalizedString(key, comment: "")
        }
        return NSLocalizedString(key, bundle: bundle, comment: "")
    }

    /// Get layout direction for current language
    var layoutDirection: LayoutDirection {
        return currentLanguage.isRTL ? .rightToLeft : .leftToRight
    }

    /// Get font for current language
    func font(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return Font.custom(currentLanguage.fontName, size: size).weight(weight)
    }

    /// Toggle between languages
    func toggleLanguage() {
        switch currentLanguage {
        case .english:
            switchLanguage(to: .arabic)
        case .arabic:
            switchLanguage(to: .english)
        }
    }
}

// MARK: - String Extension for Localization
extension String {
    var localized: String {
        return LocalizationManager.shared.localizedString(for: self)
    }
}
