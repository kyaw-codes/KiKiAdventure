import UIKit

public class PageTransitionManager {
    
    public static func navigate(to: UIViewController, from: UIViewController) {
        UIView.transition(from: from.view, to: to.view, duration: 0.5, options: .transitionCurlUp) { (_) in
            from.navigationController?.pushViewController(to, animated: true)
        }
    }
    
    public static func back(from: UIViewController) {
        guard let viewControllers = from.navigationController?.viewControllers else { return }
        let toVC = viewControllers[viewControllers.count - 2]
        
        UIView.transition(from: from.view, to: toVC.view, duration: 0.5, options: .transitionCurlDown) { _ in
            from.navigationController?.popViewController(animated: false)
        }
    }
    
}
