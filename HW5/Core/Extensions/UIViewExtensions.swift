//
//  UIViewExtensions.swift
//  HW5
//
//  Created by Диана on 25/03/2026.
//

import UIKit

// MARK - AutoLayout Helpers (centering/sizing)
extension UIView {
    
    @discardableResult
    func addTo(_ view: UIView) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        return self
    }
    
    @discardableResult
    func centerXOn(_ view: UIView) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        return self
    }
    
    @discardableResult
    func centerYOn(_ view: UIView) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return self
    }
    
    @discardableResult
    func centerOn(_ view: UIView) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        return centerXOn(view).centerYOn(view)
    }
    
    @discardableResult
    func setDefaultFieldSize(superview: UIView) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 0.5).isActive = true
        return self
    }
    
    @discardableResult
        func setSize(width: CGFloat, height: CGFloat) -> Self {
            NSLayoutConstraint.activate([
                widthAnchor.constraint(equalToConstant: width),
                heightAnchor.constraint(equalToConstant: height)
            ])
            return self
    }
}

// MARK - AutoLayout Helpers (pinning edges)
extension UIView {
    
    @discardableResult
    func pinTop(toAnchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: toAnchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func pinBottom(toAnchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        bottomAnchor.constraint(equalTo: toAnchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func pinRight(toAnchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        rightAnchor.constraint(equalTo: toAnchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func pinLeft(toAnchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        leftAnchor.constraint(equalTo: toAnchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func pinLeading(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }

    @discardableResult
    func pinTrailing(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        trailingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }

    @discardableResult
    func pinHorizontal(to view: UIView, inset: CGFloat = 0) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset)
        ])
        return self
    }

    @discardableResult
    func pinTrailingLessThanOrEqual(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        trailingAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func pinLeadingGreaterThanOrEqual(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant).isActive = true
        return self
    }
}

extension UIView {
    @discardableResult
    func setHeight(_ h: CGFloat) -> Self {
        heightAnchor.constraint(equalToConstant: h).isActive = true
        return self
    }
    @discardableResult
    func setWidth(_ h: CGFloat) -> Self {
        widthAnchor.constraint(equalToConstant: h).isActive = true
        return self
    }
}

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach(addSubview)
    }

    func pinToSuperview(insets: UIEdgeInsets = .zero) {
        guard let superview else { return }

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom)
        ])
    }

    func applyCardStyle(
        cornerRadius: CGFloat,
        shadowOpacity: Float = NewsUIConstants.Alpha.shadowOpacity,
        shadowRadius: CGFloat = 20,
        shadowOffset: CGSize = CGSize(width: 0, height: 10)
    ) {
        layer.cornerRadius = cornerRadius
        layer.cornerCurve = .continuous
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = shadowOffset
    }
}

extension UIVisualEffectView {
    static func makeCard(
        cornerRadius: CGFloat,
        style: UIBlurEffect.Style = .systemUltraThinMaterialLight
    ) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = cornerRadius
        view.layer.cornerCurve = .continuous
        view.clipsToBounds = true
        return view
    }
}

extension UILabel {
    static func make(
        font: UIFont,
        textColor: UIColor,
        numberOfLines: Int = 1,
        textAlignment: NSTextAlignment = .natural
    ) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.textColor = textColor
        label.numberOfLines = numberOfLines
        label.textAlignment = textAlignment
        return label
    }
}

extension UIImageView {
    static func make(
        image: UIImage? = nil,
        contentMode: UIView.ContentMode = .scaleAspectFill,
        cornerRadius: CGFloat = 0,
        backgroundColor: UIColor = .clear
    ) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = contentMode
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = cornerRadius
        imageView.layer.cornerCurve = .continuous
        imageView.backgroundColor = backgroundColor
        return imageView
    }
}

extension CAGradientLayer {
    static func makeBackground(colors: [CGColor]) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.colors = colors
        layer.startPoint = NewsUIConstants.Gradient.startPoint
        layer.endPoint = NewsUIConstants.Gradient.endPoint
        return layer
    }

    static func makeShimmer() -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.locations = NewsUIConstants.Gradient.shimmerLocations
        layer.startPoint = NewsUIConstants.Gradient.shimmerStartPoint
        layer.endPoint = NewsUIConstants.Gradient.shimmerEndPoint
        return layer
    }
}
