//
//  PassthroughView.swift
//  
//
//  Created by Carson Rau on 6/8/23.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public struct PassthroughView<Content: View>: View {
    @usableFromInline
    let content: Content
    
    @inlinable
    public init(content: Content) {
        self.content = content
    }
    
    @inlinable
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    @inlinable
    public var body: some View {
        content
    }
}
