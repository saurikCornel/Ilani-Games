import SwiftUI

struct MenuView: View {
    @StateObject private var soundManager = CheckingSound() // Подключаем CheckingSound
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true // Флаг первого запуска
    
    var body: some View {
        GeometryReader { geometry in
            var isLandscape = geometry.size.width > geometry.size.height
            ZStack {
                if isLandscape {
                    ZStack {
                        VStack {
                            HStack {
                                StageTemplate()
                                Spacer()
                                BalanceTemplate()
                                
                            }
                            Spacer()
                        }
                        
                        VStack {
                            Spacer()
                            HStack(spacing: -20) {
                                ButtonTemplateSmall(image: "startBtn", action: { AppNavigator.shared.currentScreen = .LEVELS })
                                
                                ButtonTemplateSmall(image: "shopBtn", action: { AppNavigator.shared.currentScreen = .SHOP })
                                
                                ButtonTemplateSmall(image: "optionBtn", action: { AppNavigator.shared.currentScreen = .SETTINGS })
                            }
                        }
                        
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                ButtonTemplateVerySmall(image: "rulesBtn", action: { AppNavigator.shared.currentScreen = .RULES })
                            }
                        }
                        
                        
                    }
                    .onAppear {
                        // Включаем музыку только при первом запуске
                        if isFirstLaunch {
                            soundManager.musicEnabled = true
                            isFirstLaunch = false // Отмечаем, что первый запуск прошёл
                        }
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
                Image("backgroundMenu")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )
        }
    }
}

struct BalanceTemplate: View {
    @AppStorage("coinscore") var coinscore: Int = 10
    
    var body: some View {
        ZStack {
            Image("balanceTemplate")
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 70)
                .overlay(
                    ZStack {
                        Text("\(coinscore)")
                            .foregroundColor(.black)
                            .fontWeight(.heavy)
                            .font(.title3)
                            .position(x: 50, y: 35)
                    }
                )
        }
    }
}

struct StageTemplate: View {
    @AppStorage("level") var level: Int = 1
    
    var body: some View {
        ZStack {
            Image("stageTemplate")
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 70)
                .overlay(
                    ZStack {
                        Text("\(level)")
                            .foregroundColor(.white)
                            .fontWeight(.heavy)
                            .font(.title3)
                            .position(x: 115, y: 35)
                    }
                )
        }
    }
}

struct ButtonTemplateSmall: View {
    var image: String
    var action: () -> Void
    
    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 80)
                .cornerRadius(10)
                .shadow(radius: 10)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                action()
            }
        }
    }
}

struct ButtonTemplateVerySmall: View {
    var image: String
    var action: () -> Void
    
    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 80)
                .cornerRadius(10)
                .shadow(radius: 10)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                action()
            }
        }
    }
}



#Preview {
    MenuView()
}
