//
//  SoundsManager.swift
//  Sliding Puzzle
//
//  Created by Danilo Silveira on 2020-05-06.
//  Copyright © 2020 Danilo Silveira. All rights reserved.
//

import Foundation
import AudioToolbox

enum SoundsEffects: String, CaseIterable {
    case move_block = "Moving Sounds"
    case win_game = "Win Sounds"
}

class SoundsManager {
    
    var audiosGameLookup = [String: SystemSoundID]()
    var soundsDisabled = [SoundsEffects]()
    
    static let shared: SoundsManager = SoundsManager()
    
    func play(sound: SoundsEffects) {
        if !checkSoundEnable(sound: sound){
            return
        }
        
        if let soundID = audiosGameLookup[sound.rawValue] {
            AudioServicesPlaySystemSound(soundID)
        } else {
            if let soundURL : CFURL = Bundle.main.url(forResource: sound.rawValue, withExtension: "wav") as CFURL? {
                var soundID  : SystemSoundID = 0
                let osStatus : OSStatus = AudioServicesCreateSystemSoundID(soundURL, &soundID)
                if osStatus == kAudioServicesNoError {
                    AudioServicesPlaySystemSound(soundID);
                    audiosGameLookup[sound.rawValue] = (soundID)
                }
            }
        }
    }
    
    func setSoundEnable(sound: SoundsEffects, enable: Bool)  {
        if enable {
            soundsDisabled.removeAll(where: {$0 == sound})
        } else {
            soundsDisabled.append(sound)
        }
    }
    
    func checkSoundEnable(sound: SoundsEffects) -> Bool {
        return !soundsDisabled.contains(sound)
    }
    
    func disposeSounds() {
        for id in audiosGameLookup.values {
            AudioServicesDisposeSystemSoundID(id)
        }
    }
    
    deinit {
        disposeSounds()
    }
}
