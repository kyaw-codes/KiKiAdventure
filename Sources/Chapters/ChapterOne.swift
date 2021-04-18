import Foundation

public class ChapterOne: BaseChapter {
    
    public override func setupViewData() {
        self.titleText = "Chapter 1"
        self.firstParagraphText = "The junta is now shutting down internet access to cut off the information flow."
        self.middleParagraphText = "They already imposed a total data blackout twice since the coup, blocked social media platforms and websites, put in place a nightly internet shutdown, and banned mobile internet access."
        self.lastParagraphText = "KiKi and his friends are brung to the Stone Age. We’re about to use paper and pen for communication again. Now, the only source of internet is the FTTP service."
        self.navigateToNextVC = {
            PageTransitionManager.navigate(to: MissionOne(), from: self)
        }
    }
    
}
