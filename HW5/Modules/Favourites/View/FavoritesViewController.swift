//
//  FavoritesViewController.swift
//  HW5
//
//  Created by Диана on 25/03/2026.
//

import UIKit

final class FavoritesViewController: UIViewController {

    private var favorites: [ArticleModel] = []

    private let backgroundGradientLayer = CAGradientLayer.makeBackground(
        colors: [
            NewsTheme.Colors.backgroundTop.cgColor,
            NewsTheme.Colors.backgroundMiddle.cgColor,
            NewsTheme.Colors.backgroundBottom.cgColor
        ]
    )

    private let titleLabel = UILabel.make(
        font: .systemFont(ofSize: NewsUIConstants.Fonts.screenTitle, weight: .heavy),
        textColor: .label
    )

    private let headerContainer = UIVisualEffectView.makeCard(
        cornerRadius: NewsUIConstants.Sizes.headerCornerRadius
    )

    private let emptyLabel = UILabel.make(
        font: .systemFont(ofSize: NewsUIConstants.Fonts.emptyState, weight: .medium),
        textColor: .secondaryLabel,
        numberOfLines: NewsUIConstants.Lines.single - 1,
        textAlignment: .center
    )

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(NewsTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(
            top: NewsUIConstants.Table.topInset,
            left: NewsUIConstants.Insets.zero,
            bottom: NewsUIConstants.Table.bottomInset,
            right: NewsUIConstants.Insets.zero
        )
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = NewsUIConstants.Table.estimatedRowHeight
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Favorites are reloaded every time the screen appears,
        reloadFavorites()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradientLayer.frame = view.bounds
    }
}

// MARK: - Setup

private extension FavoritesViewController {
    func setupView() {
        titleLabel.text = AppConstants.Titles.favoritesScreen
        emptyLabel.text = AppConstants.Messages.noSavedArticles

        view.backgroundColor = .systemBackground
        navigationItem.title = ""
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .clear

        view.layer.insertSublayer(backgroundGradientLayer, at: 0)
    }

    func setupHierarchy() {
        view.addSubviews(headerContainer, tableView, emptyLabel)
        headerContainer.contentView.addSubview(titleLabel)
    }

    func setupLayout() {
        headerContainer
            .pinTop(toAnchor: view.safeAreaLayoutGuide.topAnchor, constant: NewsUIConstants.Insets.medium)
            .pinLeading(to: view.leadingAnchor, constant: NewsUIConstants.Insets.large)
            .pinTrailing(to: view.trailingAnchor, constant: -NewsUIConstants.Insets.large)

        titleLabel
            .pinTop(toAnchor: headerContainer.contentView.topAnchor, constant: NewsUIConstants.Insets.xxLarge)
            .pinLeading(to: headerContainer.contentView.leadingAnchor, constant: NewsUIConstants.Insets.xxLarge)
            .pinTrailing(to: headerContainer.contentView.trailingAnchor, constant: -NewsUIConstants.Insets.xxLarge)
            .pinBottom(toAnchor: headerContainer.contentView.bottomAnchor, constant: -NewsUIConstants.Insets.xxLarge)

        tableView
            .pinTop(toAnchor: headerContainer.bottomAnchor, constant: NewsUIConstants.Insets.regular)
            .pinLeading(to: view.leadingAnchor)
            .pinTrailing(to: view.trailingAnchor)
            .pinBottom(toAnchor: view.bottomAnchor)

        emptyLabel
            .centerOn(view)
            .pinLeadingGreaterThanOrEqual(to: view.leadingAnchor, constant: NewsUIConstants.Insets.huge)
            .pinTrailingLessThanOrEqual(to: view.trailingAnchor, constant: -NewsUIConstants.Insets.huge)
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    func reloadFavorites() {
        favorites = FavoritesStorage.shared.getFavorites()
        emptyLabel.isHidden = !favorites.isEmpty
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: NewsTableViewCell.identifier,
                for: indexPath
            ) as? NewsTableViewCell
        else {
            return UITableViewCell()
        }

        let article = favorites[indexPath.row]
        cell.configure(
            with: NewsCellViewModel(
                title: article.displayTitle,
                description: article.description,
                imageURL: article.imageURL
            )
        )
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = favorites[indexPath.row]
        let controller = ArticleDetailsViewController(article: article)
        navigationController?.pushViewController(controller, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let removeAction = UIContextualAction(
            style: .destructive,
            title: AppConstants.Titles.remove
        ) { [weak self] _, _, completion in
            guard let self else {
                completion(false)
                return
            }

            FavoritesStorage.shared.remove(self.favorites[indexPath.row])
            self.reloadFavorites()
            completion(true)
        }

        let configuration = UISwipeActionsConfiguration(actions: [removeAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}
