//
//  FRPPlayerEventHandler.swift
//  flutter_radio_player
//
//  Created by Sithira Munasinghe on 2022-03-06.
//

import Foundation
import AVFoundation
import SwiftAudioEx

class FRPPlayerEventHandler: NSObject {
    
    override init() {
        print("::::: EVENT HANDLER INIT ::::")
    }
    
    static func handleMetaDataChanges(metaGroup: Array<AVTimedMetadataGroup>) {
        if (FRPCoreService.shared.useIcyData) {
            let metadata  = metaGroup.first?.items ?? []
            let title = AVMetadataItem.metadataItems(from: metadata, filteredByIdentifier: .commonIdentifierTitle).first?.stringValue ?? ""

            if !title.isEmpty {
                FRPCoreService.shared.player.nowPlayingInfoController.set(keyValue: MediaItemProperty.albumTitle(title))
                FRPNotificationUtil.shared.publish(eventData: FRPPlayerEvent(icyMetaDetails: title))
            }
        }
    }
    
    static func handleAudioPlayerStateChange(state: AudioPlayerState) {
        switch state {
        case .playing:
            print("FRP playing...")
            FRPNotificationUtil.shared.publish(eventData: FRPPlayerEvent(playbackStatus: FRPConsts.FRP_PLAYING))
            FRPCoreService.shared.playbackStatus = FRPPlaybackStatus.PLAYING
            break
        case .loading, .buffering:
            print("FRP loading...")
            FRPNotificationUtil.shared.publish(eventData: FRPPlayerEvent(playbackStatus: FRPConsts.FRP_LOADING))
            FRPCoreService.shared.playbackStatus = FRPPlaybackStatus.LOADING
            break
        case .idle:
            FRPCoreService.shared.playbackStatus = FRPPlaybackStatus.STOPPED
            FRPNotificationUtil.shared.publish(eventData: FRPPlayerEvent(playbackStatus: FRPConsts.FRP_STOPPED))
            print("FRP idle")
            break
        case .ready:
            print("FRP ready..")
            break
        case .paused:
            print("FRP paused")
            FRPCoreService.shared.playbackStatus = FRPPlaybackStatus.PAUSED
            FRPNotificationUtil.shared.publish(eventData: FRPPlayerEvent(playbackStatus: FRPConsts.FRP_PAUSED))
            break
        }
    }
}
