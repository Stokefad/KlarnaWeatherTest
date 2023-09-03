//
//  File.swift
//  
//
//  Created by Igor Naumenko on 03.09.2023.
//

import Foundation
import SystemConfiguration

public protocol IReachabilityService {
    func startObservingNetworkChange()
    func isConnectedToNetwork() -> Bool
}

public class ReachabilityService: IReachabilityService {
    
    private var isNetworkWasAvailableLastCall: Bool?
    
    public init() {}
    
    public func startObservingNetworkChange() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            let currentStatus = self.isConnectedToNetwork()
            if self.isNetworkWasAvailableLastCall != currentStatus {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NetworkStatusChanged"), object: nil)
            }
            self.isNetworkWasAvailableLastCall = currentStatus
            self.startObservingNetworkChange()
        }
    }

    public func isConnectedToNetwork() -> Bool {

        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret

    }
}
