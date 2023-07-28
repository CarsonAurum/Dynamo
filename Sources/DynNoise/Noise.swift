//
//  Noise.swift
//
//
//  Carson Rau - 6/14/23
//

import Dynamo

public enum Noise {
    public static var noiseX = 1619
    public static var noiseY = 31337
    public static var noiseZ = 6971
    public static var noiseSeed = 1013
    public static var noiseShift = 8
    public enum Quality {
        case fast, standard, best
    }
    // MARK: Gradient Noise
    public static func gradientCoherentNoise3D(
        _ x: Double, _ y: Double, _ z: Double,
        seed: Int, quality: Quality
    ) -> Double {
        let x0: Int = x > 0.0 ? .init(x) : .init(x - 1),
            x1 = x0 + 1,
            y0: Int = y > 0.0 ? .init(y) : .init(y - 1),
            y1 = y0 + 1,
            z0: Int = z > 0.0 ? .init(z) : .init(z - 1),
            z1 = z0 + 1
        var xs, ys, zs: Double
        switch quality {
        case .fast:
            xs = x - .init(x0)
            ys = y - .init(y0)
            zs = z - .init(z0)
        case .standard:
            xs = sCurve3(x - .init(x0))
            ys = sCurve3(y - .init(y0))
            zs = sCurve3(z - .init(z0))
        case .best:
            xs = sCurve5(x - .init(x0))
            ys = sCurve5(y - .init(y0))
            zs = sCurve5(z - .init(z0))
        }
        var n0, n1, ix0, ix1, iy0, iy1: Double
        n0 = gradientNoise3D(x, y, z, x0, y0, z0, seed: seed);
        n1 = gradientNoise3D(x, y, z, x1, y0, z0, seed: seed);
        ix0 = linearInterp(n0, n1, xs);
        n0 = gradientNoise3D(x, y, z, x0, y1, z0, seed: seed)
        n1 = gradientNoise3D(x, y, z, x1, y1, z0, seed: seed)
        ix1 = linearInterp(n0, n1, xs)
        iy0 = linearInterp(ix0, ix1, ys)
        n0 = gradientNoise3D(x, y, z, x0, y0, z1, seed: seed)
        n1 = gradientNoise3D(x, y, z, x1, y0, z1, seed: seed)
        ix0 = linearInterp(n0, n1, xs)
        n0 = gradientNoise3D(x, y, z, x0, y1, z1, seed: seed)
        n1 = gradientNoise3D(x, y, z, x1, y1, z1, seed: seed)
        ix1 = linearInterp(n0, n1, xs)
        iy1 = linearInterp(ix0, ix1, ys)
        return linearInterp(iy0, iy1, zs)
        
    }
    public static func gradientNoise3D(
        _ fx: Double, _ fy: Double, _ fz: Double,
        _ ix: Int, _ iy: Int, _ iz: Int,
        seed: Int
    ) -> Double {
        var vectorIndex = (noiseX * ix + noiseY * iy + noiseZ * iz + noiseSeed * seed)
        vectorIndex ^= (vectorIndex >> noiseShift)
        vectorIndex &= 0xff

        let xvGradient = randomVectors[vectorIndex << 2],
            yvGradient = randomVectors[(vectorIndex << 2) + 1],
            zvGradient = randomVectors[(vectorIndex << 2) + 2]
        let xvPoint = (fx - .init(ix)), yvPoint = (fy - .init(iy)), zvPoint = (fz - .init(iz))
        return ((xvGradient * xvPoint) + (yvGradient * yvPoint) + (zvGradient * zvPoint)) * 2.12
    
    }
    // MARK: Value Noise
    public static func valueCoherentNoise3D(
        _ x: Double, _ y: Double, _ z: Double,
        seed: Int, quality: Quality
    ) -> Double {
        let x0: Int = x > 0.0 ? .init(x) : .init(x - 1),
            x1 = x0 + 1,
            y0: Int = y > 0.0 ? .init(y) : .init(y - 1),
            y1 = y0 + 1,
            z0: Int = z > 0.0 ? .init(z) : .init(z - 1),
            z1 = z0 + 1
        
        var xs, ys, zs: Double
        switch quality {
        case .fast:
            xs = x - .init(x0)
            ys = y - .init(y0)
            zs = z - .init(z0)
        case .standard:
            xs = sCurve3(x - .init(x0))
            ys = sCurve3(y - .init(y0))
            zs = sCurve3(z - .init(z0))
        case .best:
            xs = sCurve5(x - .init(x0))
            ys = sCurve5(y - .init(y0))
            zs = sCurve5(z - .init(z0))
        }
        var n0, n1, ix0, ix1, iy0, iy1: Double
        n0 = valueNoise3D(x0, y0, z0, seed: seed)
        n1 = valueNoise3D(x1, y0, z0, seed: seed)
        ix0 = linearInterp(n0, n1, xs)
        n0 = valueNoise3D(x0, y1, z0, seed: seed)
        n1 = valueNoise3D(x1, y1, x0, seed: seed)
        ix1 = linearInterp(n0, n1, xs)
        iy0 = linearInterp(ix0, ix1, ys)
        n0 = valueNoise3D(x0, y0, z1, seed: seed)
        n1 = valueNoise3D(x1, y0, z1, seed: seed)
        ix0 = linearInterp(n0, n1, xs)
        n0 = valueNoise3D(x0, y1, z1, seed: seed)
        n1 = valueNoise3D(x1, y1, z1, seed: seed)
        ix1 = linearInterp(n0, n1, xs)
        iy1 = linearInterp(ix0, ix1, ys)
        return linearInterp(iy0, iy1, zs)
    }
    public static func valueNoise3D(_ x: Int, _ y: Int, _ z: Int, seed: Int) -> Double {
        func noise3D(_ x: Int, _ y: Int, _ z: Int, seed: Int) -> Int {
            var n = (noiseX * x + noiseY * y + noiseZ * z + noiseSeed * seed) & 0x7fffffff
            n = (n >> 13) ^ n
            return (n * (n * n * 60493 + 19990303) + 1376312589) & 0x7fffffff
        }
        return 1.0 - (.init(noise3D(x, y, z, seed: seed)) / 1073741824.0)
    }
}

extension Noise {
    public static func gradientCoherentNoise3D(point: Point3D, seed: Int, quality: Quality) -> Double {
        gradientCoherentNoise3D(point.x, point.y, point.z, seed: seed, quality: quality)
    }
    public static func valueCoherentNoise3D(point: Point3D, seed: Int, quality: Quality) -> Double {
        valueCoherentNoise3D(point.x, point.y, point.z, seed: seed, quality: quality)
    }
    public static func valueNoise3D(point: Point3D, seed: Int) -> Double {
        valueNoise3D(.init(point.x), .init(point.y), .init(point.z), seed: seed)
    }
}
