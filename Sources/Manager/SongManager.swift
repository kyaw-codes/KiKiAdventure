import AVFoundation

public struct SongManager {
    
    public static let shared = SongManager()
    
    public var introSong: AVAudioPlayer!
    public var paperFlickSong: AVAudioPlayer!
    public var successSong: AVAudioPlayer!
    public var helpPanelPopUpSong: AVAudioPlayer!
    
    public var missionOneSong: AVAudioPlayer!
    public var paperPiecesSwapSong: AVAudioPlayer!
    
    public var missionTwoSong: AVAudioPlayer!
    public var addToBackpackSong: AVAudioPlayer!
    public var removeFromBoardSong: AVAudioPlayer!
    
    public var missionThreeSong: AVAudioPlayer!
    public var boxOpenSong: AVAudioPlayer!
    public var panBangingSong: AVAudioPlayer!
    
    private init() {
        introSong = instantiateAVAudioPlayer(forResource: "intro.mp3")
        
        paperFlickSong = instantiateAVAudioPlayer(forResource: "paper_flick.mp3")
        
        successSong = instantiateAVAudioPlayer(forResource: "success.mp3")
        helpPanelPopUpSong = instantiateAVAudioPlayer(forResource: "helper_pop_up.mp3")
        
        missionOneSong = instantiateAVAudioPlayer(forResource: "mission_one.mp3")
        paperPiecesSwapSong = instantiateAVAudioPlayer(forResource: "paper_pieces_swap.mp3")
        
        missionTwoSong = instantiateAVAudioPlayer(forResource: "mission_two.mp3")
        addToBackpackSong = instantiateAVAudioPlayer(forResource: "add_to_backpack.mp3")
        removeFromBoardSong = instantiateAVAudioPlayer(forResource: "remove_from_board.mp3")
        
        missionThreeSong = instantiateAVAudioPlayer(forResource: "mission_three.mp3")
        boxOpenSong = instantiateAVAudioPlayer(forResource: "box_open.mp3")
        panBangingSong = instantiateAVAudioPlayer(forResource: "pan_banging.mp3")        
    }
    
    private func instantiateAVAudioPlayer(forResource resource: String) -> AVAudioPlayer {
        let path = Bundle.main.path(forResource: resource, ofType: nil, inDirectory: "audio")!
        let url = URL(fileURLWithPath: path)

        do {
            let player = try AVAudioPlayer(contentsOf: url)
            return player
        } catch {
            fatalError("Couldn't load file named \(resource).")
        }
    }
    
}
