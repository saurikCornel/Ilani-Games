import Foundation


enum AvailableScreens {
    case MENU
    case LOADING
    case SETTINGS
    case SHOP
    case RULES
    case LEVELS
    case LEVEL1
    case LEVEL2
    case LEVEL3
    case LEVEL4
    case LEVEL5
    case LEVEL6
    case LEVEL7
    case LEVEL8
    case LEVEL9
    case LEVEL10
}

class AppNavigator: ObservableObject {
    @Published var currentScreen: AvailableScreens = .LOADING
    static var shared: AppNavigator = .init()
}
