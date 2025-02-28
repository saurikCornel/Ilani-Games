import SwiftUI

struct GameLevel4: View {
    let gridSize = 5
    let plusPositions: Set<[Int]> = [[1, 2], [3, 1], [4, 3]]
    
    @AppStorage("level") var level = 1
    @AppStorage("currentSelectedCloseCard") private var currentSelectedCloseCard: String = "background1"
    @AppStorage("bestTime") var bestTime: Int = Int.max
    
    @State private var block1Position: CGPoint = CGPoint(x: -100, y: 100) // Первый блок виден сразу
    @State private var block2Position: CGPoint = CGPoint(x: -100, y: 100)
    @State private var block3Position: CGPoint = CGPoint(x: -100, y: 200)
    @State private var hasWon: Bool = false
    @State private var elapsedTime: Int = 0
    @State private var timer: Timer? = nil
    
    @State private var showBlock1: Bool = true  // Первый блок виден изначально
    @State private var showBlock2: Bool = false // Второй блок скрыт
    @State private var showBlock3: Bool = false // Третий блок скрыт
    
    let cellSize: CGFloat = 50
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                let isLandscape = geometry.size.width > geometry.size.height
                ZStack {
                    if isLandscape {
                        ZStack {
                            TimerTemplate(elapsedTime: elapsedTime, bestTime: bestTime)
                            
                            VStack {
                                HStack {
                                    Image("back")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .padding()
                                        .foregroundStyle(.white)
                                        .onTapGesture {
                                            stopTimer()
                                            AppNavigator.shared.currentScreen = .MENU
                                        }
                                    Spacer()
                                }
                                Spacer()
                            }
                            
                            VStack {
                                Spacer()
                                HStack {
                                    BalanceTemplate()
                                    Spacer()
                                }
                            }
                            
                            ZStack {
                                // Игровое поле
                                VStack(spacing: 0) {
                                    ForEach(0..<gridSize, id: \.self) { row in
                                        HStack(spacing: 0) {
                                            ForEach(0..<gridSize, id: \.self) { col in
                                                ZStack {
                                                    Image("cell")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: cellSize, height: cellSize)
                                                    if plusPositions.contains([row, col]) {
                                                        Image("plus")
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: cellSize * 0.8, height: cellSize * 0.8)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                // Блок 1: L-форма с greenCell (появляется сразу)
                                if showBlock1 {
                                    BlockView4(shape: [[true, false], [true, true]], plusPositions: [[1, 0]], position: $block1Position, cellSize: cellSize, cellImage: "greenCell")
                                        .gesture(
                                            !hasWon ? DragGesture()
                                                .onChanged { value in
                                                    block1Position = value.location
                                                    showBlock2 = true // Показываем второй блок при захвате первого
                                                }
                                                .onEnded { _ in
                                                    snapToGrid(position: &block1Position)
                                                    if isWin() {
                                                        hasWon = true
                                                        stopTimer()
                                                    }
                                                } : nil
                                        )
                                }
                                
                                // Блок 2: линия 3 с redCell (появляется при захвате первого)
                                if showBlock2 {
                                    BlockView4(shape: [[true, true, true]], plusPositions: [[0, 1]], position: $block2Position, cellSize: cellSize, cellImage: "redCell")
                                        .gesture(
                                            !hasWon ? DragGesture()
                                                .onChanged { value in
                                                    block2Position = value.location
                                                    showBlock3 = true // Показываем третий блок при захвате второго
                                                }
                                                .onEnded { _ in
                                                    snapToGrid(position: &block2Position)
                                                    if isWin() {
                                                        hasWon = true
                                                        stopTimer()
                                                    }
                                                } : nil
                                        )
                                }
                                
                                // Блок 3: квадрат 2x2 с blueCell (появляется при захвате второго)
                                if showBlock3 {
                                    BlockView4(shape: [[true, true], [true, true]], plusPositions: [[0, 1]], position: $block3Position, cellSize: cellSize, cellImage: "blueCell")
                                        .gesture(
                                            !hasWon ? DragGesture()
                                                .onChanged { value in
                                                    block3Position = value.location
                                                }
                                                .onEnded { _ in
                                                    snapToGrid(position: &block3Position)
                                                    if isWin() {
                                                        hasWon = true
                                                        stopTimer()
                                                    }
                                                } : nil
                                        )
                                }
                                
                                if hasWon {
                                    WinView4(elapsedTime: elapsedTime)
                                }
                            }
                            .frame(width: CGFloat(gridSize) * cellSize, height: CGFloat(gridSize) * cellSize)
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .onAppear {
                            startTimer()
                        }
                        .onDisappear {
                            stopTimer()
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
                    Image(currentSelectedCloseCard)
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .scaleEffect(1.1)
                )
            }
        }
    }
    
    private func startTimer() {
        elapsedTime = 0
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            elapsedTime += 1
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func snapToGrid(position: inout CGPoint) {
        let x = round(position.x / cellSize) * cellSize
        let y = round(position.y / cellSize) * cellSize
        position = CGPoint(x: x, y: y)
        
        position.x = max(0, min(position.x, CGFloat(gridSize - 1) * cellSize))
        position.y = max(0, min(position.y, CGFloat(gridSize - 1) * cellSize))
    }
    
    private func isWin() -> Bool {
        let allBlocks = [
            (shape: [[true, false], [true, true]], plus: [[1, 0]], pos: block1Position),
            (shape: [[true, true, true]], plus: [[0, 1]], pos: block2Position),
            (shape: [[true, true], [true, true]], plus: [[0, 1]], pos: block3Position)
        ]
        
        var coveredPlus = Set<[Int]>()
        
        for block in allBlocks {
            let gridX = Int(block.pos.x / cellSize)
            let gridY = Int(block.pos.y / cellSize)
            
            for row in 0..<block.shape.count {
                for col in 0..<block.shape[row].count where block.shape[row][col] {
                    let fieldRow = gridY + row
                    let fieldCol = gridX + col
                    
                    if fieldRow >= gridSize || fieldCol >= gridSize {
                        return false
                    }
                    
                    if block.plus.contains([row, col]) {
                        coveredPlus.insert([fieldRow, fieldCol])
                    }
                }
            }
        }
        
        return coveredPlus == plusPositions
    }
}

struct BlockView4: View {
    let shape: [[Bool]]
    let plusPositions: [[Int]]
    @Binding var position: CGPoint
    let cellSize: CGFloat
    let cellImage: String
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<shape.count, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<shape[0].count, id: \.self) { col in
                        ZStack {
                            if shape[row][col] {
                                Image(cellImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: cellSize, height: cellSize)
                                if plusPositions.contains([row, col]) {
                                    Image("plus")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: cellSize * 0.8, height: cellSize * 0.8)
                                }
                            } else {
                                Color.clear
                                    .frame(width: cellSize, height: cellSize)
                            }
                        }
                    }
                }
            }
        }
        .position(x: position.x + CGFloat(shape[0].count) * cellSize / 2,
                  y: position.y + CGFloat(shape.count) * cellSize / 2)
    }
}

struct WinView4: View {
    @AppStorage("level") var level: Int = 1
    @AppStorage("coinscore") var coinscore: Int = 10
    @AppStorage("bestTime") var bestTime: Int = Int.max
    let elapsedTime: Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("winPlate")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 320, height: 320)
                    .padding(.top, 60)
                    .overlay(ZStack {
                        Text(formatTime(elapsedTime))
                            .foregroundStyle(.white)
                            .font(.system(size: 40, weight: .bold))
                            .position(x: 155, y: 170)
                    })
                    .onTapGesture {
                        level += 1
                        AppNavigator.shared.currentScreen = .MENU
                        coinscore += 2
                    }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .onAppear {
                if elapsedTime < bestTime {
                    bestTime = elapsedTime
                }
            }
        }
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
}



#Preview {
    GameLevel4()
}
