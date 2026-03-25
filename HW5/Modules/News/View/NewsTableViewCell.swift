//
//  NewsTableViewCell.swift
//  HW5
//
//  Created by Диана on 24/03/2026.
//

import UIKit

final class NewsTableViewCell: UITableViewCell {

    static let identifier = String(describing: NewsTableViewCell.self)

    private var imageTask: URLSessionDataTask?
    private var currentImageURL: URL?

    private let shimmerLayer = CAGradientLayer.makeShimmer()

    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground.withAlphaComponent(NewsUIConstants.Alpha.cardBackground)
        view.applyCardStyle(cornerRadius: NewsUIConstants.Sizes.cardCornerRadius)
        return view
    }()

    private let heroImageView = UIImageView.make(
        image: UIImage(systemName: AppConstants.Placeholders.photoSystemName),
        contentMode: .scaleAspectFill,
        cornerRadius: NewsUIConstants.Sizes.imageCornerRadius,
        backgroundColor: .secondarySystemBackground
    )

    private let imageOverlay: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(NewsUIConstants.Alpha.darkOverlayLight).cgColor,
            UIColor.black.withAlphaComponent(NewsUIConstants.Alpha.darkOverlayStrong).cgColor
        ]
        layer.locations = NewsUIConstants.Gradient.imageOverlayLocations
        return layer
    }()

    private let titleLabel = UILabel.make(
        font: .systemFont(ofSize: NewsUIConstants.Fonts.cellTitle, weight: .heavy),
        textColor: .white,
        numberOfLines: NewsUIConstants.Lines.three
    )

    private let descriptionContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let descriptionLabel = UILabel.make(
        font: .systemFont(ofSize: NewsUIConstants.Fonts.cellDescription, weight: .medium),
        textColor: .secondaryLabel,
        numberOfLines: NewsUIConstants.Lines.three
    )

    private let arrowContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = NewsTheme.Colors.accentSoft
        view.layer.cornerRadius = NewsUIConstants.Sizes.arrowContainer / 2
        view.clipsToBounds = true
        return view
    }()

    private let arrowImageView = UIImageView.make(
        image: UIImage(systemName: AppConstants.Symbols.arrowUpRight),
        contentMode: .scaleAspectFit
    )

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        setupHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        shimmerLayer.frame = heroImageView.bounds
        imageOverlay.frame = heroImageView.bounds
        cardView.layer.shadowPath = UIBezierPath(
            roundedRect: cardView.bounds,
            cornerRadius: cardView.layer.cornerRadius
        ).cgPath
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        imageTask = nil
        currentImageURL = nil
        stopShimmer()
        heroImageView.image = UIImage(systemName: AppConstants.Placeholders.photoSystemName)
        titleLabel.text = nil
        descriptionLabel.text = nil
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)

        let animations = {
            self.cardView.transform = highlighted
                ? CGAffineTransform(
                    scaleX: NewsUIConstants.Transform.highlightedScale,
                    y: NewsUIConstants.Transform.highlightedScale
                )
                : .identity
            self.cardView.layer.shadowOpacity = highlighted
                ? NewsUIConstants.Alpha.highlightedShadowOpacity
                : NewsUIConstants.Alpha.shadowOpacity
        }

        if animated {
            UIView.animate(withDuration: NewsUIConstants.Animation.highlight, animations: animations)
        } else {
            animations()
        }
    }

    func configure(with viewModel: NewsCellViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        heroImageView.image = UIImage(systemName: AppConstants.Placeholders.photoSystemName)

        imageTask?.cancel()
        currentImageURL = viewModel.imageURL

        guard let url = viewModel.imageURL else {
            stopShimmer()
            return
        }

        startShimmer()

        imageTask = ImageLoader.shared.loadImage(from: url) { [weak self] image in
            guard let self else { return }
            guard self.currentImageURL == url else { return }

            UIView.transition(
                with: self.heroImageView,
                duration: NewsUIConstants.Animation.imageTransition,
                options: .transitionCrossDissolve
            ) {
                self.heroImageView.image = image ?? UIImage(systemName: AppConstants.Placeholders.photoSystemName)
            }

            self.stopShimmer()
        }
    }
}

// MARK: - Setup

private extension NewsTableViewCell {
    func configureViews() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.backgroundColor = .clear
        arrowImageView.tintColor = NewsTheme.Colors.accent
    }

    func setupHierarchy() {
        contentView.addSubview(cardView)
        cardView.addSubviews(heroImageView, titleLabel, descriptionContainer)
        heroImageView.layer.addSublayer(imageOverlay)
        descriptionContainer.addSubviews(descriptionLabel, arrowContainer)
        arrowContainer.addSubview(arrowImageView)
    }

    func setupLayout() {
        cardView
            .pinTop(toAnchor: contentView.topAnchor, constant: NewsUIConstants.Insets.medium)
            .pinLeading(to: contentView.leadingAnchor, constant: NewsUIConstants.Insets.large)
            .pinTrailing(to: contentView.trailingAnchor, constant: -NewsUIConstants.Insets.large)
            .pinBottom(toAnchor: contentView.bottomAnchor, constant: -NewsUIConstants.Insets.bottomCard)

        heroImageView
            .pinTop(toAnchor: cardView.topAnchor, constant: NewsUIConstants.Insets.small)
            .pinLeading(to: cardView.leadingAnchor, constant: NewsUIConstants.Insets.small)
            .pinTrailing(to: cardView.trailingAnchor, constant: -NewsUIConstants.Insets.small)
            .setHeight(NewsUIConstants.Sizes.newsHeroHeight)

        titleLabel
            .pinLeading(to: heroImageView.leadingAnchor, constant: NewsUIConstants.Insets.large)
            .pinTrailing(to: heroImageView.trailingAnchor, constant: -NewsUIConstants.Insets.large)
            .pinBottom(toAnchor: heroImageView.bottomAnchor, constant: -NewsUIConstants.Insets.large)

        descriptionContainer
            .pinTop(toAnchor: heroImageView.bottomAnchor, constant: NewsUIConstants.Insets.regular)
            .pinLeading(to: cardView.leadingAnchor, constant: NewsUIConstants.Insets.large)
            .pinTrailing(to: cardView.trailingAnchor, constant: -NewsUIConstants.Insets.large)
            .pinBottom(toAnchor: cardView.bottomAnchor, constant: -NewsUIConstants.Insets.large)

        descriptionLabel
            .pinTop(toAnchor: descriptionContainer.topAnchor)
            .pinLeading(to: descriptionContainer.leadingAnchor)
            .pinBottom(toAnchor: descriptionContainer.bottomAnchor)

        arrowContainer
            .pinLeadingGreaterThanOrEqual(to: descriptionLabel.trailingAnchor, constant: NewsUIConstants.Insets.medium)
            .pinTrailing(to: descriptionContainer.trailingAnchor)
            .centerYOn(descriptionContainer)
            .setSize(
                width: NewsUIConstants.Sizes.arrowContainer,
                height: NewsUIConstants.Sizes.arrowContainer
            )

        arrowImageView
            .centerOn(arrowContainer)
            .setSize(
                width: NewsUIConstants.Sizes.arrowIcon,
                height: NewsUIConstants.Sizes.arrowIcon
            )
    }

    func startShimmer() {
        stopShimmer()

        shimmerLayer.frame = heroImageView.bounds
        shimmerLayer.cornerRadius = NewsUIConstants.Sizes.imageCornerRadius
        shimmerLayer.colors = [
            UIColor.systemGray5.cgColor,
            UIColor.systemGray4.cgColor,
            UIColor.systemGray5.cgColor
        ]

        heroImageView.layer.addSublayer(shimmerLayer)

        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = -heroImageView.bounds.width
        animation.toValue = heroImageView.bounds.width
        animation.duration = NewsUIConstants.Animation.shimmer
        animation.repeatCount = .infinity

        shimmerLayer.add(animation, forKey: "shimmer")
    }

    func stopShimmer() {
        shimmerLayer.removeAnimation(forKey: "shimmer")
        shimmerLayer.removeFromSuperlayer()
    }
}
