//
//  MCSecretService.swift
//  KeyChainX
//
//  Created by softphone on 15/06/21.
//  Copyright © 2021 Bartolomeo Sorrentino. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import SwiftUI


class MCSecretService : NSObject {
    
    typealias InvitePeerAction = (MCPeerID, _ info:[String : String]?) -> Bool
    typealias AcceptPeerInvitationAction = (MCPeerID, _ context:Data?) -> Bool

    // Service type must be a unique string, at most 15 characters long
    // and can contain only ASCII lowercase letters, numbers and hyphens.
    private let ServiceType = "my-secrets"

    
    #if os(iOS)
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    private let serviceBrowser : MCNearbyServiceBrowser
    #elseif os(macOS)
    private let myPeerId = MCPeerID(displayName: Host.current().name ?? "Unknow Host")
    private let serviceAdvertiser : MCNearbyServiceAdvertiser
    #endif

    var invitePeer:InvitePeerAction?
    var acceptPeerInvitation:AcceptPeerInvitationAction?

    lazy var session : MCSession = {
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()

    
    fileprivate override init() {
        #if os(iOS)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: ServiceType)
        #else
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: ServiceType)
        #endif
        super.init()
        #if os(iOS)
        self.serviceBrowser.delegate = self
        #else
        self.serviceAdvertiser.delegate = self
        #endif

    }

    func start() {
        #if os(iOS)
        self.serviceBrowser.startBrowsingForPeers()
        #else
        self.serviceAdvertiser.startAdvertisingPeer()
        #endif
        
    }
    
    func stop() {
        #if os(iOS)
        self.serviceBrowser.stopBrowsingForPeers()
        #else
        self.serviceAdvertiser.stopAdvertisingPeer()
        #endif
    }

    
    deinit {
        self.stop()
    }

}


extension MCSecretService : MCNearbyServiceAdvertiserDelegate {

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        logger.trace("didNotStartAdvertisingPeer: \(error.localizedDescription)")
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        logger.trace("didReceiveInvitationFromPeer \(peerID)")
        
        if let acceptPeerInvitation = self.acceptPeerInvitation {
            invitationHandler( acceptPeerInvitation(peerID,context), self.session )
        }

    }
    
}

extension MCSecretService : MCNearbyServiceBrowserDelegate {

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        logger.trace("didNotStartBrowsingForPeers: \(error.localizedDescription)")
    }

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        logger.trace("foundPeer: \(peerID)")
        
        if let invitePeer = self.invitePeer, invitePeer(peerID, info) {
            browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
        }
        
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        logger.trace("lostPeer: \(peerID)")
    }

}


extension MCSecretService : MCSessionDelegate {

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        logger.trace("peer \(peerID) didChangeState: \(state.rawValue)")
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        logger.trace("didReceiveData: \(data)")
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        logger.trace("didReceiveStream")
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        logger.trace("didStartReceivingResourceWithName")
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        logger.trace("didFinishReceivingResourceWithName")
    }

}


extension Shared  {

    
    static let mcSecretService = MCSecretService()
    
}

// MARK: Custom @Environment  MCSecretService Session
// @see https://medium.com/@SergDort/custom-environment-keys-in-swiftui-49f54a13d140

//struct MCSecretServiceSessionKey: EnvironmentKey {
//    //static let defaultValue: Keychain = Keychain(service: "keychainx.userpreferences")
//    static let defaultValue:MCSession = {
//        Shared.mcSecretService.session
//    }()
//}
//
//extension EnvironmentValues {
//    var MCSecretServiceSession: MCSession {
//        get {
//            return self[MCSecretServiceSessionKey.self]
//        }
//        set {
//            self[MCSecretServiceSessionKey.self] = newValue
//        }
//    }
//}
