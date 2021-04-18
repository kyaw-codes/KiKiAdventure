import Foundation

public class ChapterZero: BaseChapter {
    
    public override func setupViewData() {
        self.titleText = "Chapter 0"
        self.firstParagraphText = "KiKi is a teenage iOS developer from a small country called Myanmar 🇲🇲"
        self.middleParagraphText = "Myanmar was a very lively country up until before the 1st of February where the military coup occurred and the democratically elected government was abducted by the junta."
        self.lastParagraphText = "Since then, the courageous Burmese civilians fight against the dictatorship and do whatever it takes for the restoration of Democracy."
        self.navigateToNextVC = {
            PageTransitionManager.navigate(to: ChapterOne(), from: self)
        }
    }
}

