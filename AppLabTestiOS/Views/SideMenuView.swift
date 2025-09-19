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
        
        ZStack {
            
            Image("bgWithWaves")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .overlay(
                    Color.black.opacity(0.3)
                )
                .ignoresSafeArea()
            
            HStack(spacing: 0) {
                // Menu Content
                VStack(alignment: .leading, spacing: 0) {
                    // Menu Header with Logo and "Menu" label
                    menuHeaderView
                    
                    // Scrollable Menu Items and Footer
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            // Menu Items
                            menuItemsView
                            
                            // Language Toggle
                            languageToggleView
                            
                            // Footer space
                            Spacer(minLength: 40)
                        }
                    }
                }
                .frame(maxWidth: DeviceHelper.menuWidth, alignment: .leading)
                .environment(\.layoutDirection, menuViewModel.layoutDirection)
                
                Spacer()
                
            }
            
            .transition(.asymmetric(
                insertion: .move(edge: menuViewModel.layoutDirection == .rightToLeft ? .trailing : .leading)
                    .combined(with: .opacity),
                removal: .move(edge: menuViewModel.layoutDirection == .rightToLeft ? .trailing : .leading)
                    .combined(with: .opacity)
            ))
            .animation(AnimationHelper.menuSlideAnimation, value: navigationManager.isMenuOpen)
        }
        .ignoresSafeArea(.all)
        
    }
    
    // MARK: - Menu Header
    private var menuHeaderView: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Close Button
            HStack {
                if menuViewModel.layoutDirection == .rightToLeft {
                    Spacer()
                }
                
                
                if menuViewModel.layoutDirection == .leftToRight {
                    Spacer()
                }
            }
            
            // Logo
            Image(menuViewModel.currentLanguageLogo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: DeviceHelper.isPad ? 120 : 100)
            
            // Menu Label
            Text("Menu")
                .font(localizationManager.font(size: 20, weight: .bold))
                .foregroundColor(.yellow)
        }
        .padding(.top, 60)
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
    
    // MARK: - Menu Items
    private var menuItemsView: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(menuViewModel.menuItems.enumerated()), id: \.element.id) { index, item in
                menuItemView(item: item)
                    .onTapGesture {
                        menuViewModel.selectMenuItem(item)
                    }
                
                // Divider
                if item != menuViewModel.menuItems.last {
                    Divider()
                        .background(Color.white.opacity(0.2))
                        .padding(.horizontal, 20)
                }
            }
        }
        .padding(.top, 10)
    }
    
    // MARK: - Menu Item View
    private func menuItemView(item: MenuItem) -> some View {
        let isSelected = menuViewModel.isSelected(item)
        
        return HStack(spacing: 15) {
            
            
            // Menu Item Text
            Text(menuViewModel.localizedTitle(for: item))
                .font(localizationManager.font(
                    size: 16,
                    weight: isSelected ? .semibold : .medium
                ))
                .foregroundColor(.white)
            
            Spacer()
            
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 20)
        .background(
            isSelected ? Color.white.opacity(0.15) : Color.clear
        )
        .contentShape(Rectangle())
    }
    
    // MARK: - Language Toggle View
    private var languageToggleView: some View {
        VStack(spacing: 20) {
            
            
            // Language Toggle
            Button(action: {
                menuViewModel.toggleLanguage()
            }) {
                HStack {
                    Image(systemName: "globe")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                    
                    Text(menuViewModel.currentLanguageDisplayName)
                        .font(localizationManager.font(size: 16))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text(localizationManager.currentLanguage == .english ? "العربية" : "English")
                        .font(localizationManager.font(size: 14))
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .background(Color.white.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .scaleButtonStyle()
            .padding(.horizontal, 20)
            
            // Share Button
            Button(action: {
                menuViewModel.shareApp()
            }) {
                HStack {
                    Image("shareIcon")
                        .resizable()
                        .frame(width: 20, height: 25)
                        .foregroundColor(.white)
                    
                    Text("Share app")
                        .font(localizationManager.font(size: 16, weight: .medium))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 5)
                .padding(.vertical, 15)
                
            }
            .scaleButtonStyle()
            .padding(.horizontal, 20)
        }
        .padding(.top, 10)
    }
}

#Preview {
    SideMenuView()
}
