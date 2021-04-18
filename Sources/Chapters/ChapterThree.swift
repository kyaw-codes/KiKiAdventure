import Foundation

public class ChapterThree: BaseChapter {
    
    public override func setupViewData() {
        self.titleText = "Chapter 3"
        self.firstParagraphText = "In our tradition, we used to bang pots and pans to drive out the evil spirits away."
        self.middleParagraphText = "We re-practice this culture every night(8 PM local time) as a civil outcry to the military coup. It’s also a way of showing that we see them(dictators) as devils."
        self.lastParagraphText = "KiKi always participate in that banging strike. But, tonight, he forgets where he put the pan."
        
        self.navigateToNextVC = {
            PageTransitionManager.navigate(to: MissionThree(), from: self)
        }
    }
}
