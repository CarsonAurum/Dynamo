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

/// A SwiftUI replacement for `UIActivityIndicatorView`.
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public struct ActivityView: View {
    /// An enumeration containing information regarding the type of indicator to display.
    ///
    /// Each case of this type provides various parameters to modify the exact mechanics of the selected indicator type.
    public enum IndicatorType {
        /// Semi-circular arcs rotate around a circle.
        /// - Parameters:
        ///   - count: The number of arcs to render.
        ///   - lineWidth: The width of the lines that compose each arc.
        case arcs(count: Int = 3, lineWidth: CGFloat = 2)
        /// The indicator similar to `UIActivityIndicatorView`.
        /// - Parameter count: Control the number of dashes.
        case `default`(count: Int = 8)
        /// A sound-EQ inspired indicator.
        /// - Parameter count: Control the number of lines.
        case equalizer(count: Int = 5)
        /// A circle of dots with varying opacity to emulate movement.
        /// - Parameter count: The number of dots to display.
        case flickeringDots(count: Int = 8)
        /// A gradient circle with angular passes to change the color.
        /// - Parameters:
        ///   - colors: The colors of the gradient.
        ///   - lineCap: The end of  the line in the gradient.
        ///   - lineWidth: The line width of the gradient.
        case gradient(_ colors: [Color], lineCap: CGLineCap = .butt, lineWidth: CGFloat = 4)
        /// An arc expands in length and completes a circle briefly, before animating away.
        /// - Parameters:
        ///   - color: The color of the arc.
        ///   - lineWidth: The width of the line that composes the arc.
        case growingArcs(color: Color = .black, lineWidth: CGFloat = 4)
        /// A circle expands in size while fading in opacity.
        case growingCircle
    }
    @Binding private var isVisible: Bool
    private var type: IndicatorType
    /// Construct a new indicator of the given type, with a binding to a boolean to toggle visibility.
    /// - Parameters:
    ///   - isVisible: A binding to a boolean to toggle the visibility of the indicator.
    ///   - type: The type of indicator to display.
    public init(isVisible: Binding<Bool>, type: IndicatorType) {
        self._isVisible = isVisible
        self.type = type
    }
    /// The content and behavior of the view.
    public var body: some View {
        if isVisible { indicator }
        else { EmptyView() }
    }
    private var indicator: some View {
        ZStack {
            switch type {
            case let .arcs(count, lineWidth):
                ArcsIndicator(count: count, lineWidth: lineWidth)
            case .default(let count):
                DefaultIndicator(count: count)
            case .equalizer(let count):
                EqualizerIndicator(count: count)
            case .flickeringDots(let count):
                FlickeringDotsIndicator(count: count)
            case let .gradient(colors, lineCap, lineWidth):
                GradientIndicator(colors: colors, lineCap: lineCap, lineWidth: lineWidth)
            case let .growingArcs(color, lineWidth):
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
    internal struct ArcsIndicator: View {
        internal let count: Int
        internal let lineWidth: CGFloat
        internal var body: some View {
            GeometryReader { geo in
                ForEach(0..<count, id: \.self) { idx in
                    ItemView(lineWidth: lineWidth, index: idx, count: count, size: geo.size)
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
        }
        internal struct ItemView: View {
            internal let lineWidth: CGFloat
            internal let index: Int
            internal let count: Int
            internal let size: CGSize
            @State private var rotation: Double = 0
            internal var body: some View {
                let animation: Animation =
                    .default
                    .speed(.random(in: 0.2...0.5))
                    .repeatForever(autoreverses: false)
                return Group {
                    // swiftlint:disable identifier_name
                    var p = Path()
                    p.addArc(
                        center: .init(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2 - .init(index) * .init(count),
                        startAngle: .degrees(0),
                        endAngle: .degrees(Int.random(in: 120...300)),
                        clockwise: true
                    )
                    return p.strokedPath(.init(lineWidth: lineWidth))
                    // swiftlint:enable identifier_name
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
    internal struct DefaultIndicator: View {
        internal let count: Int
        internal var body: some View {
            GeometryReader { geo in
                ForEach(0..<count, id: \.self) { idx in
                    ItemView(index: idx, count: count, size: geo.size)
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
        }
        internal struct ItemView: View {
            internal let index: Int
            internal let count: Int
            internal let size: CGSize
            @State private var opacity: Double = 0.0
            internal var body: some View {
                let height = size.height / 3.2
                let width = height / 2
                let angle = 2 * CGFloat.pi / CGFloat(count) * CGFloat(index)
                let x = (size.width / 2 - height / 2) * cos(angle)
                let y = (size.height / 2 - height / 2) * sin(angle)
                let animation: Animation =
                    .default
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
    internal struct EqualizerIndicator: View {
        internal let count: Int
        internal var body: some View {
            GeometryReader { geo in
                ForEach(0..<count, id: \.self) { idx in
                    ItemView(index: idx, count: count, size: geo.size)
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
        }
        internal struct ItemView: View {
            internal let index: Int
            internal let count: Int
            internal let size: CGSize
            @State private var scale: CGFloat = 0
            internal var body: some View {
                let itemSize = size.width / .init(count) / 2
                let animation: Animation =
                    .easeOut.delay(0.2)
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
    internal struct FlickeringDotsIndicator: View {
        internal let count: Int
        internal var body: some View {
            GeometryReader { geo in
                ForEach(0..<count, id: \.self) { idx in
                    ItemView(index: idx, count: count, size: geo.size)
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
        }
    }
    internal struct ItemView: View {
        internal let index: Int
        internal let count: Int
        internal let size: CGSize
        @State private var scale: CGFloat = 0
        @State private var opacity: Double = 0
        internal var body: some View {
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
    internal struct GradientIndicator: View {
        internal let colors: [Color]
        internal let lineCap: CGLineCap
        internal let lineWidth: CGFloat
        @State private var rotation: Double = 0
        internal var body: some View {
            let conic = AngularGradient(
                gradient: .init(colors: colors),
                center: .center,
                startAngle: .zero,
                endAngle: .degrees(360)
            )
            let animation: Animation =
                .linear(duration: 1.5)
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
    internal struct GrowingArcsIndicator: View {
        internal let color: Color
        internal let lineWidth: CGFloat
        @State private var arcParam: Double = 0
        internal var body: some View {
            let animation: Animation =
                .easeIn(duration: 2)
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
        // swiftlint:disable identifier_name
        internal struct GrowingArc: Shape {
            internal var maxLength = 2 * Double.pi - 0.7
            internal var lag = 0.35
            internal var p: Double
            internal var animatableData: Double {
                get { p }
                set { p = newValue }
            }
            internal func path(in rect: CGRect) -> Path {
                let h = p * 2.0
                var len = h * maxLength
                if h > 1.0 && h < lag + 1.0 { len = maxLength }
                if h > lag + 1.0 {
                    let coeff: Double = 1.0 / (1.0 - lag)
                    let n = h - 1.0 - lag
                    len = (1.0 - n * coeff) * maxLength
                }
                let first = Double.pi / 2.0
                let second = 4.0 * Double.pi - first
                var end = h * first
                if h > 1.0 { end = first + (h - 1.0) * second }
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
        // swiftlint:enable identifier_name
    }
}

// MARK: GrowingCircleIndicator

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension ActivityView {
    internal struct GrowingCircleIndicator: View {
        @State private var scale: CGFloat = 0
        @State private var opacity: Double = 0
        internal var body: some View {
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
