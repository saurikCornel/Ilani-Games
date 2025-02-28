import SwiftUI
import StoreKit

struct SettingsView: View {
    @ObservedObject var settings = CheckingSound()
    
    var body: some View {
        GeometryReader { geometry in
            var isLandscape = geometry.size.width > geometry.size.height
            ZStack {
                if isLandscape {
                    ZStack {
                        VStack {
                            HStack {
                                Image("back")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .padding()
                                    .foregroundStyle(.white)
                                    .onTapGesture {
                                        AppNavigator.shared.currentScreen = .MENU
                                    }
                                Spacer()
                            }
                            Spacer()
                        }
                        
                     
                        
                                
                        VStack(spacing: -20) {
                                if settings.musicEnabled {
                                    Image(.musicOn)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 300, height: 90)
                                        .onTapGesture {
                                            settings.musicEnabled.toggle()
                                        }
                                } else {
                                    Image(.musicOff)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 300, height: 90)
                                        .onTapGesture {
                                            settings.musicEnabled.toggle()
                                        }
                                }
                            
                            if settings.soundEnabled {
                                Image(.soundOn)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 300, height: 90)
                                    .onTapGesture {
                                        settings.soundEnabled.toggle()
                                    }
                            } else {
                                Image(.soundOff)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 300, height: 90)
                                    .onTapGesture {
                                        settings.soundEnabled.toggle()
                                    }
                            }
                                if settings.vibroEnabled {
                                    Image(.vibroOn)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 300, height: 90)
                                        .onTapGesture {
                                            settings.vibroEnabled.toggle()
                                        }
                                } else {
                                    Image(.vibroOff)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 300, height: 90)
                                        .onTapGesture {
                                            settings.vibroEnabled.toggle()
                                        }
                                }
                            
                            Image(.rateUsBtn)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 80)
                                .onTapGesture {
                                    requestAppReview()
                                }
                            
                            Image(.shareBtn)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 80)
                                .onTapGesture {
                                    requestAppReview()
                                }
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
                Image(.backgroundSettings)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )
        }
    }
}



extension SettingsView {
    // Метод для запроса отзыва через StoreKit
    func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            // Попробуем показать диалог с отзывом через StoreKit
            SKStoreReviewController.requestReview(in: scene)
        } else {
            print("Не удалось получить активную сцену для запроса отзыва.")
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SoundManager.shared)
}


