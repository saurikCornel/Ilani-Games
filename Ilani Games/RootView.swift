import Foundation
import SwiftUI


struct RootView: View {
    @ObservedObject var nav: AppNavigator = AppNavigator.shared
    var body: some View {
        switch nav.currentScreen {
            
        case .MENU:
            MenuView()
        case .LOADING:
            LoadingScreen()
        case .SHOP:
            ShopView()
        case .SETTINGS:
            SettingsView()
        case .LEVELS:
            LevelsScreen()
        case .RULES:
            AboutScreen()
        case .LEVEL1:
            LevelGame1()
        case .LEVEL2:
            LevelGame2()
        case .LEVEL3:
            LevelGame3()
        case .LEVEL4:
            GameLevel4()
        case .LEVEL5:
            LevelGame5()
            case .LEVEL6:
            LevelGame6()
        case .LEVEL7:
            LevelGame7()
        case .LEVEL8:
            LevelGame8()
        case .LEVEL9:
            LevelGame9()
        case .LEVEL10:
            LevelGame10()
        }
    }
}
