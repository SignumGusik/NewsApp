//
//  NewsTableViewCell.swift
//  HW5
//
//  Created by Диана on 24/03/2026.
//

import UIKit

final class NewsViewController: UIViewController, NewsViewProtocol {

    var interactor: (NewsBusinessLogic & NewsDataStore)?

    private var viewModel = NewsViewModel(cells: [])
    private let refreshControl = UIRefreshControl()

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
        interactor?.loadFreshNews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradientLayer.frame = view.bounds
    }

    func displayNews(viewModel: NewsViewModel) {
        self.viewModel = viewModel
        tableView.reloadData()
        refreshControl.endRefreshing()
    }

    func displayError(message: String) {
        refreshControl.endRefreshing()
        showAlert(title: AppConstants.Titles.error, message: message)
    }
}

// MARK: - Setup

private extension NewsViewController {
    func setupView() {
        titleLabel.text = AppConstants.Titles.newsScreen

        view.backgroundColor = .systemBackground
        navigationItem.title = ""
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .clear
        view.layer.insertSublayer(backgroundGradientLayer, at: 0)
    }

    func setupHierarchy() {
        view.addSubviews(headerContainer, tableView)
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
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        refreshControl.tintColor = NewsTheme.Colors.accent
        refreshControl.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc
    func refreshNews() {
        interactor?.loadFreshNews()
    }

    func presentShareSheet(for url: URL, sourceView: UIView, sourceRect: CGRect) {
        let controller = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )

        if let popover = controller.popoverPresentationController {
            popover.sourceView = sourceView
            popover.sourceRect = sourceRect
        }

        present(controller, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cells.count
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

        cell.configure(with: viewModel.cells[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            interactor?.didSelectArticle(at: indexPath.row)
            return
        }

        UIView.animate(withDuration: NewsUIConstants.Animation.tapDown, animations: {
            cell.transform = CGAffineTransform(
                scaleX: NewsUIConstants.Transform.selectedScale,
                y: NewsUIConstants.Transform.selectedScale
            )
            cell.alpha = NewsUIConstants.Transform.selectedAlpha
        }) { _ in
            UIView.animate(withDuration: NewsUIConstants.Animation.tapUp) {
                cell.transform = .identity
                cell.alpha = 1.0
            }
        }

        tableView.deselectRow(at: indexPath, animated: true)
        interactor?.didSelectArticle(at: indexPath.row)
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let shareAction = UIContextualAction(
            style: .normal,
            title: AppConstants.Titles.share
        ) { [weak self] _, _, completion in
            guard
                let self,
                let articleURL = self.interactor?.articles[indexPath.row].articleURL
            else {
                completion(false)
                return
            }

            self.presentShareSheet(
                for: articleURL,
                sourceView: tableView,
                sourceRect: tableView.rectForRow(at: indexPath)
            )
            completion(true)
        }

        shareAction.backgroundColor = NewsTheme.Colors.accent

        let configuration = UISwipeActionsConfiguration(actions: [shareAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        // infinite scroll trigger for the next page.
        if offsetY > contentHeight - height * 1.5 {
            interactor?.loadMoreNews()
        }
    }
}
