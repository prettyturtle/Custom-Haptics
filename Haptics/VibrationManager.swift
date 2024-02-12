//
//  VibrationManager.swift
//  Haptics
//
//  Created by yc on 2/12/24.
//

import CoreHaptics

struct Haptic {
    let type: HapticType
    let duration: Double
    
    enum HapticType {
        case ring
        case wait
    }
}

class VibrationManager {

    static let shared = VibrationManager()
    
    private let hapticEngine: CHHapticEngine
    private var hapticAdvancedPlayer: CHHapticAdvancedPatternPlayer? = nil
    
    init?() {
        let hapticCapability = CHHapticEngine.capabilitiesForHardware()
        
        guard hapticCapability.supportsHaptics else {
            print("Haptic engine Creation Error: Not Support")
            return nil
        }
        
        do {
            hapticEngine = try CHHapticEngine()
        } catch let error {
            print("Haptic engine Creation Error: \(error)")
            return nil
        }
    }


    func stopHapric() {
        do {
            try hapticAdvancedPlayer?.stop(atTime: 0)
        } catch {
            print("Failed to stopHapric: \(error)")
        }
    }
    
    
    func playHaptic(haptics: [Haptic], intense: Float, sharp: Float) {
        do {
            try hapticAdvancedPlayer?.stop(atTime: 0)
            
            let pattern = try makePattern(haptics: haptics, intense: intense, sharp: sharp)
            
            try hapticEngine.start()
            hapticAdvancedPlayer = try hapticEngine.makeAdvancedPlayer(with: pattern)
            hapticAdvancedPlayer?.loopEnabled = true
            hapticAdvancedPlayer?.playbackRate = 1.0
            
            try hapticAdvancedPlayer?.start(atTime: 0)
        } catch {
            print("Failed to playHaptic: \(error)")
        }
    }
    
    private func makePattern(haptics: [Haptic], intense: Float, sharp: Float) throws -> CHHapticPattern {
        
        var events: [CHHapticEvent] = []
        var relativeTime = 0.0
        
        haptics.forEach { haptic in
            let duration = haptic.duration
            let intense = haptic.type == .ring ? intense : 0
            let sharp = haptic.type == .ring ? sharp : 0
            
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: intense)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: sharp)
            
            let params = [intensity, sharpness]
            
            let event = CHHapticEvent(eventType: .hapticContinuous, parameters: params, relativeTime: relativeTime, duration: duration)
            relativeTime += duration
            events.append(event)
        }
        
        return try CHHapticPattern(events: events, parameters: [])
    }
    
}
