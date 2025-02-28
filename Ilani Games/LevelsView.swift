import SwiftUI

struct LevelsScreen: View {
    @AppStorage("isCanSpin") var isCanSpin: Bool = true
    @AppStorage("level") var level: Int = 1 // Переменная для хранения текущего уровня
    
    // Массив с именами изображений для уровней
    let levelImages: [String] = Array(1...10).map { "\($0)" }
    
    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            ZStack {
                if isLandscape {
                    ZStack {
                        VStack {
                            HStack {
                                Image("back")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .onTapGesture {
                                        AppNavigator.shared.currentScreen = .MENU
                                    }
                                Spacer()
                            }
                            Spacer()
                        }
                        
                        // Сетка с уровнями
                        VStack(spacing: 5) {
                            ForEach(0..<2, id: \.self) { row in
                                HStack(spacing: 5) {
                                    ForEach(0..<5, id: \.self) { col in
                                        let index = row * 5 + col
                                        if index < levelImages.count {
                                            let imageName = levelImages[index]
                                            Image(imageName)
                                                .resizable()
                                                .frame(width: 95, height: 95)
                                                .scaledToFill()
                                                .overlay(
                                                    Group {
                                                        if index >= level {
                                                            Color.black.opacity(0.5)
                                                        }
                                                    }
                                                )
                                                .onTapGesture {
                                                    if index < level {
                                                        // Переход на соответствующий уровень
                                                        switch index {
                                                        case 0:
                                                            AppNavigator.shared.currentScreen = .LEVEL1
                                                        case 1:
                                                            AppNavigator.shared.currentScreen = .LEVEL2
                                                        case 2:
                                                            AppNavigator.shared.currentScreen = .LEVEL3
                                                        case 3:
                                                            AppNavigator.shared.currentScreen = .LEVEL4
                                                        case 4:
                                                            AppNavigator.shared.currentScreen = .LEVEL5
                                                        case 5:
                                                            AppNavigator.shared.currentScreen = .LEVEL6
                                                        case 6:
                                                            AppNavigator.shared.currentScreen = .LEVEL7
                                                        case 7:
                                                            AppNavigator.shared.currentScreen = .LEVEL8
                                                        case 8:
                                                            AppNavigator.shared.currentScreen = .LEVEL9
                                                        case 9:
                                                            AppNavigator.shared.currentScreen = .LEVEL10
                                                        default:
                                                            break // Не должно произойти
                                                        }
                                                    }
                                                }
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.top, 50)
                    }
                } else {
                    ZStack {
                        Color.black.opacity(0.7)
                            .edgesIgnoringSafeArea(.all)
                        RotateDeviceScreen()
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image("backgroundLevels")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )
        }
    }
}


#Preview {
    LevelsScreen()
}

