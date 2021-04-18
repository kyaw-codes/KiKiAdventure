import UIKit

public class AnimationManager {
    
    public static let shared = AnimationManager()

    private init() {}
    
    public func typeWritingAnimation(for label: UILabel, with text: String, duration: Double) -> AnimationManager {
        return typeWritingAnimation(for: label, with: text, duration: duration, textShouldFadeIn: false)
    }
    
    public func typeWritingAnimation(for textView: UITextView, with text: String, duration: Double) -> AnimationManager {
        // Empty the original label's text
        textView.text = ""
        
        let wordCount: Double = Double(text.count)
        
        let typingSpeed = duration / wordCount
        
        UIView.animate(withDuration: duration) {
            text.forEach { (char) in
                textView.text?.append(char)
                RunLoop.current.run(until: Date() + typingSpeed)                
            }
        }
        return AnimationManager.shared
    }
    
    public func typeWritingAnimation(for label: UILabel, with text: String, duration: Double, textShouldFadeIn: Bool) -> AnimationManager {
        // Empty the original label's text
        label.text = ""
        label.alpha = textShouldFadeIn ? 0 : 1
        
        let wordCount: Double = Double(text.count)
        
        let typingSpeed = duration / wordCount
        
        UIView.animate(withDuration: duration) {
            text.forEach { (char) in
                label.text?.append(char)
                RunLoop.current.run(until: Date() + typingSpeed)
                if textShouldFadeIn {
                    label.alpha += min(CGFloat(typingSpeed), 1)
                }
            }
        }
        
        return AnimationManager.shared
    }
    
    public func scaleUp(view: UIView, scale: (CGFloat, CGFloat), duration: TimeInterval = 0.5, delay: TimeInterval = 0, shouldFadeIn: Bool = true, onCompletion: ((Bool) -> Void)? = nil) -> AnimationManager {
        view.alpha = shouldFadeIn ? 0 : 1

        UIView.animate(
            withDuration: duration,
            delay: delay,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
            options: .curveEaseInOut,
            animations: {
                if shouldFadeIn {
                    view.alpha = 1
                }
                view.transform = CGAffineTransform(scaleX: scale.0, y: scale.1)
            },
            completion: onCompletion
        )
        
        return AnimationManager.shared
    }
    
    public func fadeOutAndScaleDown(view: UIView, scale: (CGFloat, CGFloat) = (0, 0), duration: TimeInterval = 0.5, onCompletion: ((Bool) -> Void)? = nil) -> AnimationManager {
        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
            options: .curveEaseInOut,
            animations: {
                view.alpha = 0
                view.transform = CGAffineTransform(scaleX: scale.0, y: scale.1)
            },
            completion: onCompletion
        )
        
        return AnimationManager.shared
    }
}

