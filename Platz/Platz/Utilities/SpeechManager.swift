//
//  SpeechManager.swift
//  Platz
//
//  Text-to-Speech 관리
//

import Foundation
import AVFoundation
import Combine

class SpeechManager: NSObject, ObservableObject {
    static let shared = SpeechManager()
    
    private let synthesizer = AVSpeechSynthesizer()
    @Published var isSpeaking = false
    @Published var currentlySpeakingText: String?
    
    override init() {
        super.init()
        synthesizer.delegate = self
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("SpeechManager: Failed to setup audio session: \(error)")
        }
    }
    
    func speak(_ text: String, language: String = "de-DE") {
        // Stop current speech if any
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        // Ensure audio session is active
        setupAudioSession()
        
        let utterance = AVSpeechUtterance(string: text)
        
        // Voice selection with fallback
        if let voice = AVSpeechSynthesisVoice(language: language) {
            utterance.voice = voice
        } else {
            print("SpeechManager: Voice for \(language) not found. Checking available voices...")
            if let germanVoice = AVSpeechSynthesisVoice.speechVoices().first(where: { $0.language.starts(with: "de") }) {
                utterance.voice = germanVoice
                print("SpeechManager: Falling back to \(germanVoice.language)")
            } else {
                print("SpeechManager: No German voice found! Using default voice.")
            }
        }
        
        utterance.rate = 0.5 // Slightly slower for learning
        utterance.pitchMultiplier = 1.0
        utterance.volume = 1.0
        
        currentlySpeakingText = text
        isSpeaking = true
        synthesizer.speak(utterance)
    }
    
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
        currentlySpeakingText = nil
    }
}

extension SpeechManager: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = false
            self.currentlySpeakingText = nil
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = false
            self.currentlySpeakingText = nil
        }
    }
}
