import MultipeerConnectivity

public class JSVMultipeerSession: NSObject {
    public private(set) var session: MCSession
    public private(set) var serviceBrowser: MCNearbyServiceBrowser
    private var serviceAdvertiser: MCNearbyServiceAdvertiser
    
    public var isMaster = false
    public weak var viewController: UIViewController?

    private let connectedUserChanged: (MCPeerID?) -> Void
    private let receivedData: (Data, MCPeerID) -> Void
    private var nearbyPeers: Set<MCPeerID> = Set<MCPeerID>()
    private let nearbyPeersChanged: ([MCPeerID]) -> Void
    
    public init(_ peerID: MCPeerID, serviceType: String, connectedUserChanged: @escaping (MCPeerID?) -> Void, receivedData: @escaping (Data, MCPeerID) -> Void, nearbyPeersChanged: @escaping ([MCPeerID]) -> Void) {
        self.connectedUserChanged = connectedUserChanged
        self.receivedData = receivedData
        self.nearbyPeersChanged = nearbyPeersChanged
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        serviceBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        super.init()

        session.delegate = self
        serviceBrowser.delegate = self
        serviceAdvertiser.delegate = self
    }

    public func setupSession() {

    }

    public func invite(peer: MCPeerID) {
        isMaster = true
        serviceBrowser.invitePeer(peer, to: session, withContext: nil, timeout: 15)
    }
    
    /// Send some data to the connected peer. If no peer is connected nothing will be sent.
    /// - Parameters:
    ///   - data: The data to be sent
    ///   - priority: Choose to send the data with either a reliable connection or an unreliable one. An unreliable connection cannot guarantee the order or that the package will arrive.
    public func sendData(_ data: Data, priority: Bool = true) {
        if let connectedPeer = session.connectedPeers.first {
            do {
                try session.send(data, toPeers: [connectedPeer], with: priority ? .reliable : .unreliable)
            } catch {
                #if DEBUG
                print("Failed to send data to \(connectedPeer.displayName). Error: \(error)")
                #endif
            }
        }
    }
    
    public func sendResource(_ data: Data, withName name: String) throws {
        if let connectedPeer = session.connectedPeers.first {
            let fileName = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString)
            try data.write(to: fileName)
            session.sendResource(at: fileName, withName: name, toPeer: connectedPeer, withCompletionHandler: nil)
        }
    }
    
    public func startStream(with peer: MCPeerID) {
//        let stream = try? session.startStream(withName: "stream", toPeer: peer)
//
//        stream?.open()
//        
//        if stream?.hasSpaceAvailable ?? false {
////            stream.write(<#T##buffer: UnsafePointer<UInt8>##UnsafePointer<UInt8>#>, maxLength: <#T##Int#>)
//        }
    }

    public func startLooking() {
        serviceBrowser.startBrowsingForPeers()
        serviceAdvertiser.startAdvertisingPeer()
    }

    public func stopLooking() {
        serviceBrowser.stopBrowsingForPeers()
        serviceAdvertiser.stopAdvertisingPeer()
    }

    public func resetSession() {
        isMaster = false
        nearbyPeers = Set<MCPeerID>()
        nearbyPeersChanged(Array(nearbyPeers))
        
        stopLooking()
        session.disconnect()

        let peerID = session.myPeerID
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
    }
}

extension JSVMultipeerSession: MCNearbyServiceBrowserDelegate {
    public func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String:String]?) {
        nearbyPeers.insert(peerID)
        nearbyPeersChanged(Array(nearbyPeers))
    }
    
    public func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        nearbyPeers.remove(peerID)
        nearbyPeersChanged(Array(nearbyPeers))
    }
}

extension JSVMultipeerSession: MCNearbyServiceAdvertiserDelegate {
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        let alertTitle = NSLocalizedString("INVITATION_ALERT_TITLE", comment: "")
        let alertMessage = peerID.displayName + NSLocalizedString("INVITATION_ALERT_MESSAGE", comment: "")
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .actionSheet)
        
        let joinAction = UIAlertAction(title: NSLocalizedString("MULTIPLAYER_ACCEPT_INVITATION_TEXT", comment: ""), style: .default) { [unowned self] (_) in
            self.isMaster = false
            invitationHandler(true, self.session)
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("MULTIPLAYER_DENY_INVITATION_TEXT", comment: ""), style: .cancel) { [unowned self] (_) in
            invitationHandler(false, self.session)
        }
        
        alert.addAction(joinAction)
        alert.addAction(cancelAction)
        
        if let parentView = viewController?.view {
            alert.popoverPresentationController?.sourceView = viewController?.view
            alert.popoverPresentationController?.sourceRect = CGRect(x: parentView.bounds.midX, y: parentView.bounds.midY, width: 0, height: 0)
            alert.popoverPresentationController?.permittedArrowDirections = []
        }

        viewController?.present(alert, animated: true, completion: nil)
    }
}

extension JSVMultipeerSession: MCSessionDelegate {
    public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        // Only allow one connected peer at a time
        switch state {
        case .connecting:
            if !session.connectedPeers.isEmpty {
                session.cancelConnectPeer(peerID)
            }
        case .connected:
            connectedUserChanged(peerID)
        case .notConnected:
            if session.connectedPeers.isEmpty {
                connectedUserChanged(nil)
            }
        default:
            fatalError()
        }
    }
    
    public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard peerID == session.connectedPeers.first else { return }
        receivedData(data, peerID)
    }
    
    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("JSVKit - MultipeerSession:  Receiving resource")
    }
    
    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        guard let url = localURL else { return }

        do {
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            receivedData(data, peerID)
        } catch {
            print("JSVKit - MultipeerSession: failed to open resource")
        }
    }
}
