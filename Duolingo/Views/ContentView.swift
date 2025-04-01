//
//  Tab.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//


// Views/ContentView.swift
import SwiftUI

enum Tab { //  tab items
    case lessons
    case practice
    case leaderboard
    case profile
    case shop
}

struct ContentView: View {
    @StateObject var appState = ChineseAppState() // App-level state defined once here
    @Environment(\.theme) var theme // Theme
    @Environment(\.colorScheme) var colorScheme // System color scheme
    @State private var selectedTab: Tab = .lessons // track selected tab
    @State private var tabAnimation: Bool = false // For tab switching animation

    var body: some View {
        ZStack {
            // Main TabView with content
            TabView(selection: $selectedTab) {
                LessonsScreen()
                    .tag(Tab.lessons)
                    .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 80) } // Add space for floating bar
                
                // Practice tab
                VStack {
                    Text("Practice")
                        .font(.system(size: 28, weight: .bold))
                        .padding(.top, 40)
                    
                    Spacer()
                    
                    Image(systemName: "dumbbell.fill")
                        .font(.system(size: 70))
                        .foregroundColor(theme.accent.opacity(0.8))
                    
                    Text("Coming soon!")
                        .font(.system(size: 18, weight: .medium))
                        .padding()
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(theme.background)
                .tag(Tab.practice)
                .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 80) } // Add space for floating bar
                
                // Leaderboard tab
                VStack {
                    Text("Leaderboard")
                        .font(.system(size: 28, weight: .bold))
                        .padding(.top, 40)
                    
                    Spacer()
                    
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 70))
                        .foregroundColor(theme.highlight)
                    
                    Text("Compete with friends!")
                        .font(.system(size: 18, weight: .medium))
                        .padding()
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(theme.background)
                .tag(Tab.leaderboard)
                .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 80) } // Add space for floating bar
                
                // Profile tab
                VStack {
                    Text("Profile")
                        .font(.system(size: 28, weight: .bold))
                        .padding(.top, 40)
                    
                    ZStack {
                        Circle()
                            .fill(theme.accent.opacity(0.1))
                            .frame(width: 120, height: 120)
                        
                        Image(systemName: "person.fill")
                            .font(.system(size: 50))
                            .foregroundColor(theme.accent)
                    }
                    .padding(.top, 20)
                    
                    Text("Your Progress")
                        .font(.system(size: 22, weight: .bold))
                        .padding(.top, 20)
                    
                    HStack(spacing: 20) {
                        statView(value: "7", label: "Day streak")
                        statView(value: "1024", label: "XP")
                        statView(value: "12", label: "Crowns")
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(theme.background)
                .tag(Tab.profile)
                .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 80) } // Add space for floating bar
                
                // Shop tab
                VStack {
                    Text("Shop")
                        .font(.system(size: 28, weight: .bold))
                        .padding(.top, 40)
                    
                    Spacer()
                    
                    Image(systemName: "cart.fill")
                        .font(.system(size: 70))
                        .foregroundColor(theme.accent.opacity(0.8))
                    
                    Text("Get more gems and power-ups!")
                        .font(.system(size: 18, weight: .medium))
                        .padding()
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(theme.background)
                .tag(Tab.shop)
                .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 80) } // Add space for floating bar
            }
            
            // Floating Navigation Bar
            VStack {
                Spacer()
                if !appState.isInExerciseView {  // Only show when not in exercise
                    floatingNavigationBar
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                }
            }
        }
        .environmentObject(appState)
        .preferredColorScheme(colorScheme)
    }
    
    // Stat item view for profile tab
    private func statView(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(theme.textPrimary)
            
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(theme.textSecondary)
        }
        .frame(width: 80)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(colorScheme == .dark ? Color.black.opacity(0.2) : Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }

    // Modern floating navigation bar
    private var floatingNavigationBar: some View {
        HStack(spacing: 0) {
            // Learn tab (with Duo owl)
            navButton(
                iconName: "graduationcap.fill", 
                title: "Learn", 
                tab: .lessons,
                useCustomIcon: true,
                customIcon: {
                    AnyView(
                        ZStack {
                            if selectedTab == .lessons {
                                Circle()
                                    .fill(theme.accent)
                                    .frame(width: 52, height: 52)
                            }
                            
                            Image(systemName: "book.fill")
                                .font(.system(size: selectedTab == .lessons ? 22 : 20))
                                .foregroundColor(selectedTab == .lessons ? .white : theme.textSecondary)
                        }
                    )
                }
            )
            
            Spacer(minLength: 0)
            
            // Practice tab
            navButton(iconName: "dumbbell.fill", title: "Practice", tab: .practice)
            
            Spacer(minLength: 0)
            
            // Leaderboard tab
            navButton(iconName: "trophy.fill", title: "Leaderboard", tab: .leaderboard)
            
            Spacer(minLength: 0)
            
            // Profile tab
            navButton(iconName: "person.fill", title: "Profile", tab: .profile)
            
            Spacer(minLength: 0)
            
            // Shop tab
            navButton(iconName: "bag.fill", title: "Shop", tab: .shop)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(colorScheme == .dark ? Color(UIColor.systemGray6) : Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                .overlay(
                    BlurView(style: colorScheme == .dark ? .systemUltraThinMaterialDark : .systemUltraThinMaterialLight)
                        .clipShape(RoundedRectangle(cornerRadius: 28))
                )
        )
    }

    // Duolingo-style tab button with bouncy animation
    private func navButton(
        iconName: String,
        title: String, 
        tab: Tab,
        useCustomIcon: Bool = false,
        customIcon: (() -> AnyView)? = nil
    ) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = tab
                tabAnimation = true
                
                // Reset animation flag after delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    tabAnimation = false
                }
            }
        }) {
            VStack(spacing: 4) {
                // Icon with bounce animation when selected
                if useCustomIcon && customIcon != nil {
                    customIcon!()
                        .scaleEffect(selectedTab == tab && tabAnimation ? 1.2 : 1.0)
                } else {
                    ZStack {
                        if selectedTab == tab {
                            Circle()
                                .fill(theme.accent)
                                .frame(width: 40, height: 40) // Slightly smaller for floating design
                                .shadow(color: theme.accent.opacity(0.3), radius: 5, x: 0, y: 2)
                        }
                        
                        Image(systemName: iconName)
                            .font(.system(size: 18)) // Slightly smaller icon
                            .foregroundColor(selectedTab == tab ? .white : theme.textSecondary)
                    }
                    .scaleEffect(selectedTab == tab && tabAnimation ? 1.2 : 1.0)
                }
                
                // Tab label
                Text(title)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(selectedTab == tab ? theme.accent : theme.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // Helper function to get the safe area bottom inset
    private func getSafeAreaBottom() -> CGFloat {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            return keyWindow.safeAreaInsets.bottom
        }
        return 0
    }
}

// MARK: - BlurView
// Helper for adding blur effect
struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

// Fix Preview by using the PreviewProvider protocol
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.theme, AppTheme.systemTheme())
    }
}
