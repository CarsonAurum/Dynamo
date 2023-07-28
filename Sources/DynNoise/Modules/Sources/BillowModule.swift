//
//  BillowModule.swift
//
//
//  Carson Rau - 6/14/23
//

import Dynamo

public struct BillowModule: SourceModule {
    public enum Defaults {
        public static let frequency = 1.0
        public static let lacunarity = 2.0
        public static let octaveCount = 6
        public static let persistence = 0.5
        public static let quality: Noise.Quality = .standard
        public static let seed = 0
        public static let maxOctave = 30
    }
    public var frequency: Double
    public var lacunarity: Double
    public var quality: Noise.Quality
    public var persistence: Double
    public var seed: Int
    public private(set) var octaveCount: Int
    public init(
        frequency: Double? = nil,
        lacunarity: Double? = nil,
        quality: Noise.Quality? = nil,
        persistence: Double? = nil,
        seed: Int? = nil,
        octaveCount: Int? = nil
    ) {
        self.frequency = frequency ?? Defaults.frequency
        self.lacunarity = lacunarity ?? Defaults.lacunarity
        self.quality = quality ?? Defaults.quality
        self.persistence = persistence ?? Defaults.persistence
        self.seed = seed ?? Defaults.seed
        self.octaveCount = octaveCount ?? Defaults.octaveCount
    }
    // swiftlint:disable identifier_name
    @discardableResult
    public mutating func setOctaveCount(_ n: Int) throws -> Self {
        guard n.isBetween(1...Defaults.maxOctave) else {
            throw _NoiseError.invalidParameter
        }
        self.octaveCount = n
        return self
    }
    // swiftlint:enable identifier_name
    public func getValue(x: Double, y: Double, z: Double) throws -> Double {
        var initialPoint: Point3D = .init(x, y, z), clampedPoint: Point3D = .zero
        var seed = 0, value = 0.0, signal = 0.0, curPersistence = 1.0
        initialPoint *= frequency
        for x in 0 ..< octaveCount {
            clampedPoint = initialPoint.clamped()
            seed = self.seed + x
            signal = Noise.gradientCoherentNoise3D(point: clampedPoint, seed: seed, quality: quality)
            signal = 2.0 * Swift.abs(signal) - 1.0
            value += signal * curPersistence
            initialPoint *= lacunarity
            curPersistence *= persistence
        }
        value += 0.5
        return value
    }
}
