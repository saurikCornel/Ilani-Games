import SwiftUI

struct CardOption: Identifiable {
    let id: String
    let buyImage: String
    let selectImage: String
    let closeImage: String
    let selectedImage: String
}

struct ShopView: View {
    @AppStorage("coinscore") var playerBalance: Int = 10
    @AppStorage("ownedCards") private var ownedCards: String = "background1" // Используем строку для хранения карт
    @AppStorage("selectedCard") private var selectedCard: String = "firstCardSelected" // Выбранная карта
    @AppStorage("currentSelectedCloseCard") private var currentSelectedCloseCard: String = "background1" // Новая переменная для хранения closeImage выбранной карты

    @State private var alertMessage: String? // Для хранения текста алерта
    @State private var showAlert: Bool = false // Отображение алерта

    private let cardOptions: [CardOption] = [
        CardOption(id: "firstCard", buyImage: "firstCardBuy", selectImage: "firstCardSelect", closeImage: "background1", selectedImage: "firstCardSelected"),
        CardOption(id: "secondCard", buyImage: "secondCardBuy", selectImage: "secondCardSelect", closeImage: "background2", selectedImage: "secondCardSelected"),
        CardOption(id: "thirdCard", buyImage: "thirdCardBuy", selectImage: "thirdCardSelect", closeImage: "background3", selectedImage: "thirdCardSelected"),
        CardOption(id: "fourCard", buyImage: "fourCardBuy", selectImage: "fourCardSelect", closeImage: "background4", selectedImage: "fourCardSelected"),
    ]
    
    private let cardPrice: Int = 1000
    

    var body: some View {
        GeometryReader { geometry in
            var isLandscape = geometry.size.width > geometry.size.height
            ZStack {
                if isLandscape {
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
                            BalanceTemplate()
                        }
                        Spacer()
                    }
                    
                    
                    
                    ZStack {
                        HStack(spacing: 20) {
                            ForEach(cardOptions) { card in
                                Button(action: {
                                    handleCardAction(for: card)
                                }) {
                                    Image(currentImage(for: card))
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: geometry.size.width / 5, height: geometry.size.height / 1.3)
                                }
                            }
                        }
                        .padding(.top, 90)
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Notification"), message: Text(alertMessage ?? ""), dismissButton: .default(Text("OK")))
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
                Image(.backgroundShop)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )


        }
        
    }
    
    private func currentImage(for card: CardOption) -> String {
        if card.selectedImage == selectedCard {
            return card.selectedImage // Отображаем "выбранный" статус
        } else if ownedCards.contains(card.closeImage) {
            return card.selectImage // Карта куплена, но не выбрана
        } else {
            return card.buyImage // Карта не куплена
        }
    }
    
    private func handleCardAction(for card: CardOption) {
        if ownedCards.contains(card.closeImage) {
            // Если карта уже куплена, просто выбираем её
            selectedCard = card.selectedImage
            saveCurrentSelectedCloseCard(card.closeImage) // Сохраняем closeImage выбранной карты
            alertMessage = "Card selected successfully!" // Сообщение об успешном выборе карты
        } else if playerBalance >= cardPrice {
            // Покупаем карту
            playerBalance -= cardPrice
            ownedCards += "," + card.closeImage // Добавляем карту в список
            selectedCard = card.selectedImage
            saveCurrentSelectedCloseCard(card.closeImage) // Сохраняем closeImage выбранной карты
            alertMessage = "Card purchased successfully!" // Сообщение об успешной покупке карты
        } else {
            alertMessage = "Not enough coins to buy this card!" // Сообщение о недостатке монет
        }
        showAlert = true
    }
    
    private func saveCurrentSelectedCloseCard(_ closeCard: String) {
        currentSelectedCloseCard = closeCard // Сохраняем в @AppStorage значение closeImage
    }
}


#Preview {
    ShopView()
}


