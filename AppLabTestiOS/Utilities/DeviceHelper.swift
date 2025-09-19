//
//  DeviceHelper.swift
//  AppLabTestiOS
//
//  Created by M Tayyab on 19/09/2025.
//

import SwiftUI

// MARK: - Device Helper
struct DeviceHelper {
    // MARK: - Device Detection
    static var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    static var isPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }

    // MARK: - Screen Dimensions
    static var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }

    static var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }

    // MARK: - Layout Values
    static var menuWidth: CGFloat {
        isPad ? min(350, screenWidth * 0.4) : screenWidth * 0.65
    }

    static var contentPadding: CGFloat {
        isPad ? 40 : 20
    }

    static var headerHeight: CGFloat {
        isPad ? 80 : 60
    }

    static var weatherIconSize: CGFloat {
        isPad ? 120 : 80
    }

    static var temperatureSize: CGFloat {
        isPad ? 60 : 48
    }

    static var titleSize: CGFloat {
        isPad ? 36 : 28
    }

    static var subtitleSize: CGFloat {
        isPad ? 22 : 18
    }

    static var bodyTextSize: CGFloat {
        isPad ? 20 : 16
    }

    static var smallTextSize: CGFloat {
        isPad ? 18 : 14
    }

    // MARK: - Layout Helpers
    static func adaptiveColumns(minWidth: CGFloat = 300) -> Int {
        let availableWidth = screenWidth - (contentPadding * 2)
        return max(1, Int(availableWidth / minWidth))
    }

    static func adaptiveSpacing(base: CGFloat) -> CGFloat {
        isPad ? base * 1.5 : base
    }
}

// MARK: - Size Classes
extension View {
    func adaptiveFont(size: CGFloat, weight: Font.Weight = .regular) -> some View {
        let adaptiveSize = DeviceHelper.isPad ? size * 1.2 : size
        return self.font(.system(size: adaptiveSize, weight: weight))
    }

    func adaptivePadding(_ edges: Edge.Set = .all, _ length: CGFloat? = nil) -> some View {
        let adaptiveLength = length != nil ?
            (DeviceHelper.isPad ? length! * 1.3 : length!) :
            DeviceHelper.contentPadding
        return self.padding(edges, adaptiveLength)
    }

    func adaptiveFrame(width: CGFloat? = nil, height: CGFloat? = nil) -> some View {
        let adaptiveWidth = width != nil ? (DeviceHelper.isPad ? width! * 1.2 : width!) : nil
        let adaptiveHeight = height != nil ? (DeviceHelper.isPad ? height! * 1.2 : height!) : nil
        return self.frame(width: adaptiveWidth, height: adaptiveHeight)
    }
}

// MARK: - Responsive Grid Helper
struct ResponsiveGrid<Content: View>: View {
    let content: Content
    let minItemWidth: CGFloat

    init(minItemWidth: CGFloat = 300, @ViewBuilder content: () -> Content) {
        self.minItemWidth = minItemWidth
        self.content = content()
    }

    var body: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: DeviceHelper.adaptiveSpacing(base: 20)),
                          count: DeviceHelper.adaptiveColumns(minWidth: minItemWidth))

        LazyVGrid(columns: columns, spacing: DeviceHelper.adaptiveSpacing(base: 20)) {
            content
        }
    }
}
