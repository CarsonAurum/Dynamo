//
//  Bundle+.swift
//
//  Extensions to the Foundation Bundle type.
//
//  Carson Rau - 6/9/23
//

#if canImport(Foundation) && canImport(Darwin)
import Foundation
import Darwin

extension Bundle {
    private static let cache = NSCache<NSNumber, Bundle>()
    
    public static var current: Bundle? {
        let caller = Thread.callStackReturnAddresses[1]
        
        if let bundle = cache.object(forKey: caller) { return bundle }
        var info  = Dl_info(dli_fname: nil, dli_fbase: nil, dli_sname: nil, dli_saddr: nil)
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
