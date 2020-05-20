@testable import JSVKit
import XCTest

extension JSVSounds.Name {
    static let testSound1 = JSVSounds.Name("testSound1")
    static let testSound2 = JSVSounds.Name("testSound2")
}

@available(iOS 10.0, *)
class JSVAudioPlayerTests: XCTestCase {
    let audioPlayer = JSVAudioPlayer()

    func testPlaySoundThatDoesNotExists() {
        XCTAssertThrowsError(try audioPlayer.play(sound: .testSound1))
    }
}
