//
//  ActivityView.swift
//
//  A SwiftUI replacement for UIActivityIndicatorView
//
//  Carson Rau - 6/9/23
//

#if canImport(SwiftUI)
import SwiftUI

// MARK: ActivityView

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public struct ActivityView: View {
    
    public enum IndicatorType {
        case arcs(count: Int = 3, lineWidth: CGFloat = 2)
        case `default`(count: Int = 8)
        case equalizer(count: Int = 5)
        case flickeringDots(count: Int = 8)
        case gradient(_ colors: [Color], lineCap: CGLineCap = .butt, lineWidth: CGFloat = 4)
        case growingArcs(color: Color = .black, lineWidth: CGFloat = 4)
        case growingCircle
    }
    
    @Binding private var isVisible: Bool
    private var type: IndicatorType
    
    public init(isVisible: Binding<Bool>, type: IndicatorType) {
        self._isVisible = isVisible
        self.type = type
    }
    
    public var body: some View {
        if isVisible { indicator }
        else { EmptyView() }
    }
    
    private var indicator: some View {
        ZStack {
            switch type {
            case .arcs(let count, let lineWidth):
                ArcsIndicator(count: count, lineWidth: lineWidth)
            case .default(let count):
                DefaultIndicator(count: count)
            case .equalizer(let count):
                EqualizerIndicator(count: count)
            case .flickeringDots(let count):
                FlickeringDotsIndicator(count: count)
            case .gradient(let colors, let lineCap, let lineWidth):
                GradientIndicator(colors: colors, lineCap: lineCap, lineWidth: lineWidth)
            case .growingArcs(let color, let lineWidth):
                GrowingArcsIndicator(color: color, lineWidth: lineWidth)
            case .growingCircle:
                GrowingCircleIndicator()
                
            }
        }
    }
}

// MARK: ArcsIndicator

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension ActivityView {
    struct ArcsIndicator: View {
        let count: Int
        let lineWidth: CGFloat
        var body: some View {
            GeometryReader { geo in
                ForEach(0..<count, id: \.self) { idx in
                    ItemView(lineWidth: lineWidth, index: idx, count: count, size: geo.size)
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
        }
        struct ItemView: View {
            let lineWidth: CGFloat
            let index: Int
            let count: Int
            let size: CGSize
            @State private var rotation: Double = 0
            var body: some View {
                let animation = Animation.default
                    .speed(.random(in: 0.2...0.5))
                    .repeatForever(autoreverses: false)
                return Group {
                    var p = Path()
                    p.addArc(
                        center: .init(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2 - .init(index) * .init(count),
                        startAngle: .degrees(0),
                        endAngle: .degrees(Int.random(in: 120...300)),
                        clockwise: true
                    )
                    return p.strokedPath(.init(lineWidth: lineWidth))
                }
                .frame(width: size.width, height: size.height)
                .rotationEffect(.degrees(rotation))
                .onAppear {
                    rotation = 0
                    DispatchQueue.main.asyncAfter(delay: 0.01) {
                        withAnimation(animation) { rotation = 360 }
                    }
                }
            }
        }
    }
}

// MARK: DefaultIndicator
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension ActivityView {
    struct DefaultIndicator: View {
        let count: Int
        var body: some View {
            GeometryReader { geo in
                ForEach(0..<count, id: \.self) { idx in
                    ItemView(index: idx, count: count, size: geo.size)
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
        }
        struct ItemView: View {
            let index: Int
            let count: Int
            let size: CGSize
            
            @State var opacity: Double = 0.0
            
            var body: some View {
                let height = size.height / 3.2
                let width = height / 2
                let angle = 2 * .pi / CGFloat(count) * CGFloat(index)
                let x = (size.width / 2 - height / 2) * cos(angle)
                let y = (size.height / 2 - height / 2) * sin(angle)
                
                let animation = Animation.default
                    .repeatForever(autoreverses: true)
                    .delay(Double(index) / Double(count) / 2)
                
                return RoundedRectangle(cornerRadius: width / 2 + 1)
                    .frame(width: width, height: height)
                    .rotationEffect(.init(radians: angle + .pi / 2))
                    .offset(x: x, y: y)
                    .opacity(opacity)
                    .onAppear {
                        opacity = 1
                        withAnimation(animation) { opacity = 0.3 }
                    }
            }
        }
    }
}

// MARK: - EqualizerIndicator

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension ActivityView {
    struct EqualizerIndicator: View {
        let count: Int
        var body: some View {
            GeometryReader { geo in
                ForEach(0..<count, id: \.self) { idx in
                    ItemView(index: idx, count: count, size: geo.size)
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
        }
        
        struct ItemView: View {
            let index: Int
            let count: Int
            let size: CGSize
            @State private var scale: CGFloat = 0
            var body: some View {
                let itemSize = size.width / .init(count) / 2
                let animation = Animation.easeOut.delay(0.2)
                    .repeatForever(autoreverses: true)
                    .delay(.init(index) / .init(count) / 2)
                return RoundedRectangle(cornerRadius: 3)
                    .frame(width: itemSize, height: size.height)
                    .scaleEffect(x: 1, y: scale, anchor: .center)
                    .onAppear {
                        scale = 1
                        withAnimation(animation) { scale = 0.4 }
                    }
                    .offset(x: 2 * itemSize * .init(index) - size.width / 2 + itemSize / 2)
            }
        }
    }
}

// MARK: - FlickeringDotsIndicator

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension ActivityView {
    struct FlickeringDotsIndicator: View {
        let count: Int
        var body: some View {
            GeometryReader { geo in
                ForEach(0..<count, id: \.self) { idx in
                    ItemView(index: idx, count: count, size: geo.size)
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
        }
    }
    struct ItemView: View {
        let index: Int
        let count: Int
        let size: CGSize
        
        @State private var scale: CGFloat = 0
        @State private var opacity: Double = 0
        
        var body: some View {
            let duration = 0.5
            let itemSize = size.height / 5
            let angle = 2 * CGFloat.pi / .init(count) * .init(index)
            let x = (size.width / 2 - itemSize / 2) * cos(angle)
            let y = (size.height / 2 - itemSize / 2) * sin(angle)
            
            let animation = Animation.linear(duration: duration)
                .repeatForever(autoreverses: true)
                .delay(duration * .init(index) / .init(count) * 2)
            
            return Circle()
                .frame(width: itemSize, height: itemSize)
                .scaleEffect(scale)
                .opacity(opacity)
                .onAppear {
                    scale = 1
                    opacity = 1
                    withAnimation(animation) {
                        scale = 0.5
                        opacity = 0.3
                    }
                }
                .offset(x: x, y: y)
        }
    }
}

// MARK: - GradientIndicator

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension ActivityView {
    struct GradientIndicator: View {
        let colors: [Color]
        let lineCap: CGLineCap
        let lineWidth: CGFloat
        
        @State private var rotation: Double = 0
        
        var body: some View {
            let conic = AngularGradient(gradient: .init(colors: colors), center: .center, startAngle: .zero, endAngle: .degrees(360))
            let animation = Animation.linear(duration: 1.5)
                .repeatForever(autoreverses: false)
            
            return ZStack {
                Circle()
                    .stroke(colors.first ?? .white, lineWidth: lineWidth)
                Circle()
                    .trim(from: lineWidth / 500, to: 1 - lineWidth / 500)
                    .stroke(conic, style: .init(lineWidth: lineWidth, lineCap: lineCap))
                    .rotationEffect(.degrees(rotation))
                    .onAppear {
                        rotation = 0
                        DispatchQueue.main.asyncAfter(delay: 0.01) {
                            withAnimation(animation) { rotation = 360 }
                        }
                    }
            }
        }
    }
}

// MARK: GrowingArcsIndicator

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension ActivityView {
    struct GrowingArcsIndicator: View {
        let color: Color
        let lineWidth: CGFloat
        @State private var arcParam: Double = 0
        
        var body: some View {
            let animation = Animation.easeIn(duration: 2)
                .repeatForever(autoreverses: false)
            return GrowingArc(p: arcParam)
                .stroke(color, lineWidth: lineWidth)
                .onAppear {
                    arcParam = 0
                    DispatchQueue.main.asyncAfter(delay: 0.01) {
                        withAnimation(animation) { arcParam = 1 }
                    }
                }
        }
        
        struct GrowingArc: Shape {
            var maxLength = 2 * Double.pi - 0.7
            var lag = 0.35
            var p: Double
            var animatableData: Double {
                get { return p }
                set { p = newValue }
            }
            func path(in rect: CGRect) -> Path {
                let h = p * 2
                var len = h * maxLength
                if h > 1 && h < lag + 1 { len = maxLength }
                if h > lag + 1 {
                    let coeff = 1 / (1 - lag)
                    let n = h - 1 - lag
                    len = (1 - n * coeff) * maxLength
                }
                let first = Double.pi / 2
                let second = 4 * Double.pi - first
                var end = h * first
                if h > 1 { end = first + (h - 1) * second }
                let start = end + len
                
                var p = Path()
                
                p.addArc(
                    center: .init(x: rect.size.width / 2, y: rect.size.height / 2),
                    radius: rect.size.width / 2,
                    startAngle: .init(radians: start),
                    endAngle: .init(radians: end),
                    clockwise: true
                )
                
                return p
            }
        }
    }
}

// MARK: GrowingCircleIndicator

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension ActivityView {
    struct GrowingCircleIndicator: View {
        @State private var scale: CGFloat = 0
        @State private var opacity: Double = 0
        
        var body: some View {
            let animation = Animation.easeIn(duration: 1.1)
                .repeatForever(autoreverses: false)
            
            return Circle()
                .scaleEffect(scale)
                .opacity(opacity)
                .onAppear {
                    scale = 0
                    opacity = 1
                    DispatchQueue.main.asyncAfter(delay: 0.01) {
                        withAnimation(animation) {
                            scale = 1
                            opacity = 0
                        }
                    }
                }
        }
    }
}

#endif
