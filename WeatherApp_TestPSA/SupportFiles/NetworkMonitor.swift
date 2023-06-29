//
//  NetworkMonitor.swift
//  WeatherApp_TestPSA
//
//  Created by WG CONSULTING on 29/06/2023.
//

import Foundation
import Network

/// Monitor internet availability
final class NetworkMonitor{
    static let shared = NetworkMonitor()
    
    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
    var isReachableOnCellular: Bool = true
    
    //Vérifiez si Internet est disponible
    func isInternetAvailable() -> Bool {
        return monitor.currentPath.status == .satisfied
    }
    
    //commencer à surveiller la disponibilité d'Internet
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.isReachableOnCellular = path.isExpensive

            if path.status != .satisfied {
                print("No internet connection!")
            }
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
