//
//  ActivityView.swift
//
//
//  Created by Carson Rau on 6/9/23.
//

#if canImport(SwiftUI)
import SwiftUI

// MARK: ActivityView

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public struct ActivityView: View {
    
    public enum IndicatorType {
        case arcs(count: Int = 3, lineWidth: CGFloat = 2)
        case `default`(count: Int = 8)
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
#endif
