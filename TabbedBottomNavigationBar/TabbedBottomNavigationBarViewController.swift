//
//  TabbedBottomNavigationBarViewController.swift
//  TabbedBottomNavigationBar
//
//  Created by Marcin Slusarek on 16/11/2020.
//

import UIKit

class TabbedBottomNavigationBarViewController: UITabBarController {
    
    var hapticEnabled: Bool
    
    @IBInspectable var hapticFeedback: Bool = false {
        didSet {
            self.hapticEnabled = hapticFeedback
        }
    }
    
    init(hapticEnabled: Bool) {
        self.hapticEnabled = hapticEnabled
        super.init(nibName: nil, bundle: nil)
    }

    
    required init?(coder aDecoder: NSCoder) {
        self.hapticEnabled = false
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if (hapticEnabled) {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
    }

}


extension TabbedBottomNavigationBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TabBarAnimatedTransitioning(viewControllers: tabBarController.viewControllers)
    }
}

final class TabBarAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    
    let viewControllers: [UIViewController]?
    let transitionDuration: Double = 1
    
    init(viewControllers: [UIViewController]?) {
        self.viewControllers = viewControllers
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else { return }
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else { return }
        guard let destination = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        
        destination.alpha = 0.0
        let size = transitionContext.containerView.frame.size
    
        let fromIndex = getIndex(forViewController: fromVC)
        let toIndex = getIndex(forViewController: toVC)
        
        let direction = getDirection(index: fromIndex, toIndex: toIndex)
        
        destination.bounds = .init(x: size.width / 5 * CGFloat(direction), y: 0, width: size.width, height: size.height)
        
        transitionContext.containerView.addSubview(destination)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            destination.alpha = 1.0
            destination.bounds = .init(x: 0, y: 0, width: size.width, height: size.height)
        }, completion: { transitionContext.completeTransition($0)})
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.15
    }
    
    func getIndex(forViewController vc: UIViewController) -> Int? {
            guard let vcs = self.viewControllers else { return nil }
            for (index, thisVC) in vcs.enumerated() {
                if thisVC == vc { return index }
            }
            return nil
        }
    
    func getDirection(index: Int?, toIndex: Int?) -> Int {
        guard let index = index, let toIndex = toIndex else {
             return -1
        }
        
        if index > toIndex {
            return 1
        } else {
            return -1
        }
    }
}
