//
//  Bundle+.swift
//
//  Extensions to the Foundation Bundle type.
//
//  Carson Rau - 6/9/23
//

#if canImport(Darwin) && canImport(Foundation)
import Darwin
import Foundation

extension Bundle {
    // swiftlint:disable legacy_objc_type
    private static let cache = NSCache<NSNumber, Bundle>()
    // swiftlint:enable legacy_objc_type
    /// Access the current bundle, if it exists.
    public static var current: Bundle? {
        let caller = Thread.callStackReturnAddresses[1]
        if let bundle = cache.object(forKey: caller) { return bundle }
        var info = Dl_info(dli_fname: nil, dli_fbase: nil, dli_sname: nil, dli_saddr: nil)
        dladdr(caller.pointerValue, &info)
        let path = String(cString: info.dli_fname)
        for bundle in Bundle.allBundles + Bundle.allFrameworks {
            if let execPath = bundle.executableURL?.resolvingSymlinksInPath().path,
                path == execPath {
                cache.setObject(bundle, forKey: caller)
                return bundle
            }
        }
        return nil
    }
}

#endif
