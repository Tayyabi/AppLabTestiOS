//
//  SideMenuView.swift
//  AppLabTestiOS
//
//  Created by M Tayyab on 19/09/2025.
//

import SwiftUI
import Combine

struct SideMenuView: View {
    @StateObject private var menuViewModel = MenuViewModel()
    @StateObject private var localizationManager = LocalizationManager.shared
    @StateObject private var navigationManager = NavigationManager.shared

    var body: some View {
        HStack(spacing: 0) {
            // Menu Content
            VStack(alignment: .leading, spacing: 0) {
                // Menu Header
                menuHeaderView

                // Menu Items
                menuItemsView

                Spacer()

                // Footer
                menuFooterView
            }
            .frame(maxWidth: DeviceHelper.menuWidth)
            .background(
                LinearGradient(
                    colors: [
                        Color.blue.opacity(0.9),
                        Color.blue.opacity(0.7)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .environment(\.layoutDirection, menuViewModel.layoutDirection)

            // Overlay to close menu when tapping outside
            Color.black.opacity(0.3)
                .onTapGesture {
                    menuViewModel.closeMenu()
                }
        }
        .ignoresSafeArea()
        .transition(.asymmetric(
            insertion: .move(edge: menuViewModel.layoutDirection == .rightToLeft ? .trailing : .leading)
                .combined(with: .opacity),
            removal: .move(edge: menuViewModel.layoutDirection == .rightToLeft ? .trailing : .leading)
                .combined(with: .opacity)
        ))
        .animation(AnimationHelper.menuSlideAnimation, value: navigationManager.isMenuOpen)
    }

    // MARK: - Menu Header
    private var menuHeaderView: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Close Button
            HStack {
                if menuViewModel.layoutDirection == .rightToLeft {
                    Spacer()
                }

                Button(action: {
                    menuViewModel.closeMenu()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                }
                .scaleButtonStyle()

                if menuViewModel.layoutDirection == .leftToRight {
                    Spacer()
                }
            }

            // Logo
            HStack {
                if menuViewModel.layoutDirection == .rightToLeft {
                    Spacer()
                }

                Image(menuViewModel.currentLanguageLogo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: DeviceHelper.isPad ? 50 : 40)

                if menuViewModel.layoutDirection == .leftToRight {
                    Spacer()
                }
            }

            // Welcome Message
            VStack(alignment: menuViewModel.layoutDirection == .rightToLeft ? .trailing : .leading, spacing: 5) {
                Text("Welcome")
                    .font(localizationManager.font(size: 24, weight: .light))
                    .foregroundColor(.white)

                Text("Select an option below")
                    .font(localizationManager.font(size: 14))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 60)
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
    }

    // MARK: - Menu Items
    private var menuItemsView: some View {
        VStack(spacing: 0) {
            ForEach(Array(menuViewModel.menuItems.enumerated()), id: \.element.id) { index, item in
                menuItemView(item: item)
                    .onTapGesture {
                        menuViewModel.selectMenuItem(item)
                    }
                    .fadeInEffect(delay: Double(index) * 0.1)

                // Divider
                if item != menuViewModel.menuItems.last {
                    Divider()
                        .background(Color.white.opacity(0.3))
                        .padding(.horizontal, 20)
                }
            }
        }
    }

    // MARK: - Menu Item View
    private func menuItemView(item: MenuItem) -> some View {
        let isSelected = menuViewModel.isSelected(item)

        return HStack(spacing: 15) {
            // Selection Indicator
            Rectangle()
                .fill(isSelected ? Color.white : Color.clear)
                .frame(width: 4)

            if menuViewModel.layoutDirection == .rightToLeft {
                Spacer()
            }

            // Menu Item Text
            Text(menuViewModel.localizedTitle(for: item))
                .font(localizationManager.font(
                    size: 18,
                    weight: isSelected ? .medium : .regular
                ))
                .foregroundColor(isSelected ? .white : .white.opacity(0.8))

            if menuViewModel.layoutDirection == .leftToRight {
                Spacer()
            }

            // Arrow Indicator for navigable items
            if item.isNavigable {
                Image(systemName: menuViewModel.layoutDirection == .rightToLeft ? "chevron.left" : "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 20)
        .background(
            isSelected ? Color.white.opacity(0.1) : Color.clear
        )
        .contentShape(Rectangle())
    }

    // MARK: - Menu Footer
    private var menuFooterView: some View {
        VStack(spacing: 15) {
            // Language Toggle
            Button(action: {
                menuViewModel.toggleLanguage()
            }) {
                HStack {
                    Image(systemName: "globe")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.8))

                    Text(menuViewModel.currentLanguageDisplayName)
                        .font(localizationManager.font(size: 16))
                        .foregroundColor(.white.opacity(0.8))

                    Spacer()

                    Text(localizationManager.currentLanguage == .english ? "العربية" : "English")
                        .font(localizationManager.font(size: 14))
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.white.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .scaleButtonStyle()

            // App Version
            Text("Version 1.0.0")
                .font(localizationManager.font(size: 12))
                .foregroundColor(.white.opacity(0.5))
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 40)
    }
}

#Preview {
    SideMenuView()
}