//
//  Illuminotchi.swift
//  Illuminotchi
//
//  Created by Jeff Hurray on 12/20/17.
//  Copyright © 2017 Jeff Hurray. All rights reserved.
//

import Foundation
import UIKit

public protocol WindowProvider: class {
    var window: UIWindow? { get }
}

public final class Illuminotchi {

    private static let shared = Illuminotchi()
    private lazy var underlyingNotchView = UnderlyingNotchView()
    private var _theyreWatchingYourScreenshots: Bool = false


    init() {
        let notificationCenter = NotificationCenter.default
        let keyWindowSelector = #selector(handle(windowDidBecomeKeyNotification:))
        notificationCenter.addObserver(self, selector: keyWindowSelector, name: .UIWindowDidBecomeKey, object: nil)
        let screenshotSelector = #selector(handle(windowDidBecomeKeyNotification:))
        notificationCenter.addObserver(self, selector: screenshotSelector, name: .UIApplicationUserDidTakeScreenshot, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    public class func theyreWatching() {
        add(image: UIImage.illuminati)
    }

    public class func theyreWatchingYourScreenshots() {
        self.shared._theyreWatchingYourScreenshots = true
    }

    public class func add(image: UIImage, contentMode: UIViewContentMode = .scaleAspectFit) {
        let imageView = UIImageView()
        imageView.contentMode = contentMode
        imageView.image = image
        imageView.sizeToFit()
        add(customView: imageView)
    }

    public class func add(text: String) {
        add(attributedText: NSAttributedString(string: text))
    }

    public class func add(attributedText: NSAttributedString) {
        let label = UILabel()
        label.attributedText = attributedText
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        add(customView: label)
    }

    public class func add(customView view: UIView) {
        self.shared.addSubview(underNotch: view)
    }

    @objc
    private func handle(windowDidBecomeKeyNotification notification: Notification) {
        guard UIDevice.hasNotchView else {
            return
        }
        if let keyWindow = UIApplication.shared.keyWindow {
            self.underlyingNotchView.removeFromSuperview()
            keyWindow.addSubview(self.underlyingNotchView)
            keyWindow.bringSubview(toFront: self.underlyingNotchView)
        }
    }

    @objc
    private func handle(didTakeScreenshotNotification notification: Notification) {
        guard _theyreWatchingYourScreenshots else {
            return
        }
        if let keyWindow = UIApplication.shared.keyWindow {
            let imageView = UIImageView(image: UIImage.illuminati)
            imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
            imageView.center = keyWindow.centerForSubview
            imageView.alpha = 0
            imageView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            keyWindow.addSubview(imageView)
            keyWindow.bringSubview(toFront: imageView)
            UIView.animate(withDuration: 0.1, delay: 0.05, options: .curveEaseInOut, animations: {
                imageView.alpha = 1
                imageView.transform = .identity
            }, completion: { (_) in
                imageView.removeFromSuperview()
            })
        }

    }

    private func addSubview(underNotch view: UIView) {
        guard UIDevice.hasNotchView else {
            return
        }
        self.underlyingNotchView.addSubview(view)
    }

    private class UnderlyingNotchView: UIView {

        struct Constants {
            static let size = CGSize(width: 209, height: 30)
            static let origin = CGPoint(x: 83, y: 0)
        }

        weak var underlyingView: UIView?

        init() {
            let notchFrame = CGRect(origin: Constants.origin, size: Constants.size)
            super.init(frame: notchFrame)
            self.clipsToBounds = true
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func addSubview(_ view: UIView) {
            self.underlyingView?.removeFromSuperview()
            super.addSubview(view)
            self.underlyingView = view
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            guard let view = self.underlyingView else {
                return
            }
            let size = CGSize(width: min(view.bounds.width, Constants.size.width),
                              height: min(view.bounds.height, Constants.size.height))
            view.frame = CGRect(x: self.bounds.width/2 - size.width/2,
                                y: self.bounds.height - size.height,
                                width: size.width,
                                height: size.height)
        }

    }
}

extension UIView {

    var centerForSubview: CGPoint {
        return CGPoint(x: bounds.width/2, y: bounds.height/2)
    }
}

extension UIImage {

    class var illuminati: UIImage {
        let bundle = Bundle(for: Illuminotchi.self)
        return UIImage(named: "Illuminati", in: bundle, compatibleWith: nil)!
    }
}

extension UIDevice {

    class var hasNotchView: Bool {
        guard let window = UIApplication.shared.windows.first else {
            return false
        }
        return window.safeAreaInsets.bottom > 0
    }
}
