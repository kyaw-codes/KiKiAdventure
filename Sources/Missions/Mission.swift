import UIKit

public protocol Mission {
    
    func setupViewData()
    func setupGame(inside gameArea: UIView)
    func showMissionCompleteDialog(customAnimation: ((AnimationManager) -> Void)?)
}

public protocol MissionDelegate {
    
    // go to story
    func didBackToStoryTap()
    
    // skip
    func onMissionCompleteOrSkip(isCompleted: Bool)
}
