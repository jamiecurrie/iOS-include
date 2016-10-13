//  Usage:
//
//  # Show Overlay
//  LoadingOverlay.shared.showOverlay(view)
//
//  # Hide Overlay
//  LoadingOverlay.shared.hideOverlayView()

import UIKit
import Foundation


class LoadingOverlay {
    
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    func showOverlay(_ view: UIView!) {
        
        if (overlayView.superview != nil) {
            hideOverlayView()
        }
        
        overlayView = UIView(frame: view.bounds)
        overlayView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicator.color = UIColor(red: 0, green: 73/255, blue: 144/255, alpha: 1)
        activityIndicator.center = overlayView.center
        overlayView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        view.addSubview(overlayView)
        
    }
    
    func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}
