import Network
import Foundation
import SwiftUI

class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    @Published var isConnected: Bool = false
    @Published var didReceiveFirstStatus: Bool = false

    private init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                print("NWPathMonitor status: \(path.status == .satisfied ? "Online" : "Offline")")
                self.isConnected = path.status == .satisfied
                self.didReceiveFirstStatus = true
            }
        }
        monitor.start(queue: queue)
    }
} 
