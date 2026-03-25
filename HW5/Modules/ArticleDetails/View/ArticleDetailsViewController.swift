//
//  ArticleDetailsViewController.swift
//  HW5
//
//  Created by Диана on 24/03/2026.
//

import UIKit
import WebKit

final class ArticleDetailsViewController: UIViewController, WKNavigationDelegate {

    private let article: ArticleModel

    private let backgroundGradientLayer = CAGradientLayer.makeBackground(
        colors: [
            NewsTheme.Colors.backgroundTop.cgColor,
            NewsTheme.Colors.backgroundMiddle.cgColor,
            NewsTheme.Colors.backgroundBottom.cgColor
        ]
    )

    private let headerCard = UIVisualEffectView.makeCard(
        cornerRadius: NewsUIConstants.Sizes.cardCornerRadius
    )

    private let titleLabel = UILabel.make(
        font: .systemFont(ofSize: NewsUIConstants.Fonts.articleTitle, weight: .heavy),
        textColor: .label,
        numberOfLines: NewsUIConstants.Lines.three
    )

    private let descriptionLabel = UILabel.make(
        font: .systemFont(ofSize: NewsUIConstants.Fonts.articleDescription, weight: .medium),
        textColor: .secondaryLabel,
        numberOfLines: NewsUIConstants.Lines.two
    )

    private let shareButton = UIButton.makeFilled(
        title: AppConstants.Titles.share,
        imageSystemName: AppConstants.Symbols.share
    )

    private let vkButton = UIButton.makeFilled(
        title: "VK",
        imageSystemName: AppConstants.Symbols.vk
    )

    private let favoriteButton = UIButton.makeFilled(
        title: AppConstants.Titles.save,
        imageSystemName: AppConstants.Symbols.heart
    )

    private let webContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground.withAlphaComponent(NewsUIConstants.Alpha.webContainerBackground)
        view.applyCardStyle(cornerRadius: NewsUIConstants.Sizes.cardCornerRadius)
        return view
    }()

    private let webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.layer.cornerRadius = NewsUIConstants.Sizes.detailWebCornerRadius
        webView.clipsToBounds = true
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.isOpaque = false
        webView.backgroundColor = .clear
        return webView
    }()

    private let loadingCard = UIVisualEffectView.makeCard(
        cornerRadius: NewsUIConstants.Sizes.loadingCardCornerRadius
    )

    private let loadingTitleLabel = UILabel.make(
        font: .systemFont(ofSize: NewsUIConstants.Fonts.loadingTitle, weight: .bold),
        textColor: .label
    )

    private let loadingSubtitleLabel = UILabel.make(
        font: .systemFont(ofSize: NewsUIConstants.Fonts.loadingSubtitle, weight: .medium),
        textColor: .secondaryLabel,
        numberOfLines: NewsUIConstants.Lines.two,
        textAlignment: .center
    )

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = NewsTheme.Colors.accent
        indicator.hidesWhenStopped = true
        return indicator
    }()

    init(article: ArticleModel) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
        setupActions()
        loadArticlePage()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradientLayer.frame = view.bounds
        webContainer.layer.shadowPath = UIBezierPath(
            roundedRect: webContainer.bounds,
            cornerRadius: webContainer.layer.cornerRadius
        ).cgPath
    }
}

// MARK: - Setup

private extension ArticleDetailsViewController {
    func setupView() {
        titleLabel.text = article.displayTitle
        descriptionLabel.text = article.description
        loadingTitleLabel.text = AppConstants.Titles.loadingArticle
        loadingSubtitleLabel.text = AppConstants.Messages.pleaseWait

        view.backgroundColor = .systemBackground
        title = AppConstants.Titles.articleScreen
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.isTranslucent = true
        view.layer.insertSublayer(backgroundGradientLayer, at: 0)

        webView.navigationDelegate = self
        loadingIndicator.startAnimating()
        updateFavoriteButton()
    }

    func setupHierarchy() {
        view.addSubviews(headerCard, webContainer)

        headerCard.contentView.addSubviews(
            titleLabel,
            descriptionLabel,
            shareButton,
            vkButton,
            favoriteButton
        )

        webContainer.addSubviews(webView, loadingCard)
        loadingCard.contentView.addSubviews(
            loadingTitleLabel,
            loadingSubtitleLabel,
            loadingIndicator
        )
    }

    func setupLayout() {
        headerCard
            .pinTop(toAnchor: view.safeAreaLayoutGuide.topAnchor, constant: NewsUIConstants.Insets.medium)
            .pinLeading(to: view.leadingAnchor, constant: NewsUIConstants.Insets.large)
            .pinTrailing(to: view.trailingAnchor, constant: -NewsUIConstants.Insets.large)

        titleLabel
            .pinTop(toAnchor: headerCard.contentView.topAnchor, constant: NewsUIConstants.Insets.xLarge)
            .pinLeading(to: headerCard.contentView.leadingAnchor, constant: NewsUIConstants.Insets.xLarge)
            .pinTrailing(to: headerCard.contentView.trailingAnchor, constant: -NewsUIConstants.Insets.xLarge)

        descriptionLabel
            .pinTop(toAnchor: titleLabel.bottomAnchor, constant: NewsUIConstants.Insets.small)
            .pinLeading(to: titleLabel.leadingAnchor)
            .pinTrailing(to: titleLabel.trailingAnchor)

        shareButton
            .pinTop(toAnchor: descriptionLabel.bottomAnchor, constant: NewsUIConstants.Insets.large)
            .pinLeading(to: titleLabel.leadingAnchor)
            .pinBottom(toAnchor: headerCard.contentView.bottomAnchor, constant: -NewsUIConstants.Insets.xLarge)
            .setHeight(NewsUIConstants.Sizes.buttonHeight)

        vkButton
            .pinTop(toAnchor: descriptionLabel.bottomAnchor, constant: NewsUIConstants.Insets.large)
            .pinLeading(to: shareButton.trailingAnchor, constant: NewsUIConstants.Insets.medium)
            .pinBottom(toAnchor: headerCard.contentView.bottomAnchor, constant: -NewsUIConstants.Insets.xLarge)
            .setHeight(NewsUIConstants.Sizes.buttonHeight)

        favoriteButton
            .pinTop(toAnchor: descriptionLabel.bottomAnchor, constant: NewsUIConstants.Insets.large)
            .pinLeading(to: vkButton.trailingAnchor, constant: NewsUIConstants.Insets.medium)
            .pinBottom(toAnchor: headerCard.contentView.bottomAnchor, constant: -NewsUIConstants.Insets.xLarge)
            .setHeight(NewsUIConstants.Sizes.buttonHeight)

        webContainer
            .pinTop(toAnchor: headerCard.bottomAnchor, constant: NewsUIConstants.Insets.regular)
            .pinLeading(to: view.leadingAnchor, constant: NewsUIConstants.Insets.large)
            .pinTrailing(to: view.trailingAnchor, constant: -NewsUIConstants.Insets.large)
            .pinBottom(toAnchor: view.safeAreaLayoutGuide.bottomAnchor, constant: -NewsUIConstants.Insets.medium)

        webView
            .pinTop(toAnchor: webContainer.topAnchor, constant: NewsUIConstants.Insets.small)
            .pinLeading(to: webContainer.leadingAnchor, constant: NewsUIConstants.Insets.small)
            .pinTrailing(to: webContainer.trailingAnchor, constant: -NewsUIConstants.Insets.small)
            .pinBottom(toAnchor: webContainer.bottomAnchor, constant: -NewsUIConstants.Insets.small)

        loadingCard
            .centerOn(webContainer)
            .pinLeadingGreaterThanOrEqual(to: webContainer.leadingAnchor, constant: NewsUIConstants.Insets.huge)
            .pinTrailingLessThanOrEqual(to: webContainer.trailingAnchor, constant: -NewsUIConstants.Insets.huge)

        loadingTitleLabel
            .pinTop(toAnchor: loadingCard.contentView.topAnchor, constant: NewsUIConstants.Insets.xxLarge)
            .pinLeading(to: loadingCard.contentView.leadingAnchor, constant: NewsUIConstants.Insets.xxLarge)
            .pinTrailing(to: loadingCard.contentView.trailingAnchor, constant: -NewsUIConstants.Insets.xxLarge)

        loadingSubtitleLabel
            .pinTop(toAnchor: loadingTitleLabel.bottomAnchor, constant: NewsUIConstants.Insets.xSmall)
            .pinLeading(to: loadingTitleLabel.leadingAnchor)
            .pinTrailing(to: loadingTitleLabel.trailingAnchor)

        loadingIndicator
            .pinTop(toAnchor: loadingSubtitleLabel.bottomAnchor, constant: NewsUIConstants.Insets.large)
            .centerXOn(loadingCard.contentView)
            .pinBottom(toAnchor: loadingCard.contentView.bottomAnchor, constant: -NewsUIConstants.Insets.xxLarge)
    }

    func setupActions() {
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        vkButton.addTarget(self, action: #selector(vkTapped), for: .touchUpInside)
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
    }

    func loadArticlePage() {
        guard let url = article.articleURL else {
            showWebLoadingError(message: AppConstants.Messages.articleLinkUnavailable)
            return
        }

        webView.load(URLRequest(url: url))
    }

    func showWebLoadingError(message: String) {
        loadingIndicator.stopAnimating()
        loadingTitleLabel.text = AppConstants.Messages.failedToLoadArticle
        loadingSubtitleLabel.text = message
        loadingCard.isHidden = false
        loadingCard.alpha = 1
    }

    func updateFavoriteButton() {
        let isFavorite = FavoritesStorage.shared.isFavorite(article)

        if isFavorite {
            favoriteButton.applyFilledStyle(
                title: AppConstants.Titles.saved,
                imageSystemName: AppConstants.Symbols.heartFill
            )
        } else {
            favoriteButton.applyFilledStyle(
                title: AppConstants.Titles.save,
                imageSystemName: AppConstants.Symbols.heart
            )
        }
    }
}

// MARK: - Actions

private extension ArticleDetailsViewController {
    @objc
    func shareTapped() {
        guard let url = article.articleURL else { return }

        let controller = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )

        if let popover = controller.popoverPresentationController {
            popover.sourceView = shareButton
            popover.sourceRect = shareButton.bounds
        }

        present(controller, animated: true)
    }

    @objc
    func vkTapped() {
        guard let url = article.articleURL else { return }

        VKShareService.shared.share(
            url: url,
            from: self,
            sourceView: vkButton,
            sourceRect: vkButton.bounds
        )
    }

    @objc
    func favoriteTapped() {
        FavoritesStorage.shared.toggle(article)
        updateFavoriteButton()
    }
}

// MARK: - WKNavigationDelegate

extension ArticleDetailsViewController {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIView.animate(withDuration: NewsUIConstants.Animation.loadingFade) {
            self.loadingCard.alpha = 0
        } completion: { _ in
            self.loadingIndicator.stopAnimating()
            self.loadingCard.isHidden = true
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showWebLoadingError(message: AppConstants.Messages.failedToLoadArticle)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        showWebLoadingError(message: AppConstants.Messages.failedToLoadArticle)
    }
}
