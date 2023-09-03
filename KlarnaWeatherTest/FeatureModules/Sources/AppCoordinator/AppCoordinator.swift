//
//  File.swift
//  
//
//  Created by Igor Naumenko on 03.09.2023.
//

import Foundation
import UIKit
import ReachabilityService
import UIComponentsLibrary

public final class AppCoordinator {
    private weak var window: UIWindow?
    private lazy var warningInfoView = WarningInfoView()
    private let reachabilityService: IReachabilityService
    
    public init(window: UIWindow, reachabilityService: IReachabilityService) {
        self.window = window
        self.reachabilityService = reachabilityService
        warningInfoView.text = "Waiting for network connection"
        startObservingNetworkChanges()
    }
    
    private func startObservingNetworkChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityWasChanged), name: Notification.Name(rawValue: "NetworkStatusChanged"), object: nil)
    }
    
    @objc
    private func reachabilityWasChanged() {
        DispatchQueue.main.async {
            guard !self.reachabilityService.isConnectedToNetwork(), let window = self.window else {
                self.warningInfoView.removeFromSuperview()
                return
            }
            
            window.addSubview(self.warningInfoView)
            
            let verticalConstraint = self.warningInfoView.topAnchor.constraint(equalTo: window.topAnchor, constant: -Indents.big * 2)
            verticalConstraint.isActive = true
            self.warningInfoView.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: Indents.regular).isActive = true
            self.warningInfoView.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -Indents.regular).isActive = true
            
            window.layoutIfNeeded()
            UIView.animate(withDuration: 0.3) {
                verticalConstraint.constant = Indents.big * 2
                window.layoutIfNeeded()
            }
        }
    }
}
