//
//  AnimationHelper.swift
//  AppLabTestiOS
//
//  Created by M Tayyab on 19/09/2025.
//

import SwiftUI

// MARK: - Animation Helper
struct AnimationHelper {
    // MARK: - Menu Animations
    static let menuSlideAnimation = Animation.easeInOut(duration: 0.3)
    static let menuFadeAnimation = Animation.easeInOut(duration: 0.25)

    // MARK: - Content Animations
    static let contentFadeIn = Animation.easeIn(duration: 0.4)
    static let contentSlideUp = Animation.spring(response: 0.6, dampingFraction: 0.8)

    // MARK: - Button Animations
    static let buttonPress = Animation.spring(response: 0.3, dampingFraction: 0.6)
    static let buttonHover = Animation.easeInOut(duration: 0.2)

    // MARK: - Loading Animations
    static let loadingPulse = Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)
    static let loadingSpin = Animation.linear(duration: 1.0).repeatForever(autoreverses: false)

    // MARK: - Transition Animations
    static let pageTransition = AnyTransition.asymmetric(
        insertion: .move(edge: .trailing).combined(with: .opacity),
        removal: .move(edge: .leading).combined(with: .opacity)
    )

    static let modalTransition = AnyTransition.asymmetric(
        insertion: .scale(scale: 0.8).combined(with: .opacity),
        removal: .scale(scale: 1.1).combined(with: .opacity)
    )

    // MARK: - Weather Data Animations
    static let weatherDataAppear = Animation.spring(response: 0.7, dampingFraction: 0.8, blendDuration: 0.1)
    static let temperatureChange = Animation.easeInOut(duration: 0.5)

    // MARK: - Language Switch Animation
    static let languageSwitchAnimation = Animation.easeInOut(duration: 0.4)
}

// MARK: - Custom Animation Modifiers
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(AnimationHelper.buttonPress, value: configuration.isPressed)
    }
}

struct PulseEffect: ViewModifier {
    @State private var isPulsing = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? 1.05 : 1.0)
            .opacity(isPulsing ? 0.8 : 1.0)
            .onAppear {
                withAnimation(AnimationHelper.loadingPulse) {
                    isPulsing.toggle()
                }
            }
    }
}

struct SlideInFromBottom: ViewModifier {
    @State private var isVisible = false

    func body(content: Content) -> some View {
        content
            .offset(y: isVisible ? 0 : 100)
            .opacity(isVisible ? 1 : 0)
            .onAppear {
                withAnimation(AnimationHelper.contentSlideUp) {
                    isVisible = true
                }
            }
    }
}

struct FadeInEffect: ViewModifier {
    @State private var isVisible = false
    let delay: Double

    init(delay: Double = 0) {
        self.delay = delay
    }

    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation(AnimationHelper.contentFadeIn) {
                        isVisible = true
                    }
                }
            }
    }
}

// MARK: - View Extensions
extension View {
    func scaleButtonStyle() -> some View {
        buttonStyle(ScaleButtonStyle())
    }

    func pulseEffect() -> some View {
        modifier(PulseEffect())
    }

    func slideInFromBottom() -> some View {
        modifier(SlideInFromBottom())
    }

    func fadeInEffect(delay: Double = 0) -> some View {
        modifier(FadeInEffect(delay: delay))
    }
}