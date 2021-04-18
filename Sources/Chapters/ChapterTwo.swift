import Foundation

public class ChapterTwo: BaseChapter {
    
    public override func setupViewData() {
        self.titleText = "Chapter 2"
        self.firstParagraphText = "The political unrest is getting worse."
        self.middleParagraphText = "The armed forces of the junta are now raiding and shooting unarmed civilians. Some of the houses are igniting 🔥 into ashes and lots of innocent people become homeless."
        self.lastParagraphText = "KiKi's house is not safe anymore. So, KiKi has no choice but to pack important things and prepare to leave the house at any time."
        
        self.navigateToNextVC = {
            PageTransitionManager.navigate(to: MissionTwo(), from: self)
        }
    }
    
}
