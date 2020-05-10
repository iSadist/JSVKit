import Foundation
import AudioToolbox
import AVFoundation

/// The sounds that can be played through the JSVAudioPlayer. Extend this struct with strings to add more sounds.
/// The string should be the same name as the sound file, without the extension. The format of the sound file should be
/// .m4a. The extension is done in a similar way to how NotificationCenter works.
public struct JSVSounds {
    public struct Name: RawRepresentable, Equatable, Hashable, Comparable {
        public var rawValue: String
        
        public static func < (lhs: JSVSounds.Name, rhs: JSVSounds.Name) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
        
        public init(_ rawValue: String) {
            self.rawValue = rawValue
        }

        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
}

/// A protocol which allows a class to play a sound
public protocol JSVPlayable {
    func play(sound: JSVSounds.Name)
}

/// An audio player that can play various sounds at the same time.
@available(iOS 10.0, *)
public class JSVAudioPlayer: NSObject, JSVPlayable {
    fileprivate var audio: [String : AVAudioPlayer]
    public static let instance = JSVAudioPlayer()
    
    /// Creates the audio player with all sounds available from the Sound enum
    override init() {
        audio = [String : AVAudioPlayer]()
        super.init()
    }
    
    /// Play a sound from an audio file (m4a) that exists in the root of the project
    /// - Parameter sound: A sound value that has the same name as the audio file (without extension). This value should come from the JSVSounds.Name struct extension.
    public func play(sound: JSVSounds.Name) {
        var audioPlayer: AVAudioPlayer? = audio[sound.rawValue]
        
        if audioPlayer == nil {
            guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "m4a") else {
                fatalError("unable to create url")
            }
            
            let player = try? AVAudioPlayer(contentsOf: url)
            player?.setVolume(0.5, fadeDuration: 0.25)
            player?.prepareToPlay()
            audio[sound.rawValue] = player
            audioPlayer = player
        }
        
        audioPlayer?.play()
    }
}
