//
//  ViewController.swift
//  ReferenceArchitectureNonModular
//
//  Created by Kurt Jacobs on 2022/11/04.
//

import Combine
import CommonUI
import NVActivityIndicatorView
import SnapKit
import UIKit

enum Section: Hashable {
    case listing
}

public protocol FoodListingViewControllerDelegate: AnyObject {
    func didSelect(_ foodListingViewController: FoodListingViewController, foodItem: FoodListingConfiguration?)
}

typealias FoodListingDataSource = UICollectionViewDiffableDataSource<Section, FoodListingConfiguration>
// typealias FoodListingSnapshot = NSDiffableDataSourceSnapshot<Section, FoodListingConfiguration>

public class FoodListingViewController: UIViewController {
    weak var delegate: FoodListingViewControllerDelegate?
    private var viewModel: FoodListingViewModel
    private var cancelBag: Set<AnyCancellable> = []
    private var collectionView: UICollectionView = {
        let configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        return UICollectionView(frame: .zero,
                                collectionViewLayout: UICollectionViewCompositionalLayout.list(using: configuration))
    }()

    private lazy var dataSource = makeDataSource()
    private var searchBar = UISearchBar()
    private var loadingIndicator = NVActivityIndicatorView(frame: .zero, color: .systemGray)
    private var customRefreshControl = CustomRefreshControl()

    init(viewModel: FoodListingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Foods"
        configureViews()
        configureProperties()
        configureBindings()
        dataSource = makeDataSource()
        applyInitialSnapshots()
        refresh()
    }

    private func configureBindings() {
        viewModel.$foods.receive(on: DispatchQueue.main).sink { [weak self] _ in
            guard let self = self else { return }
            self.applyInitialSnapshots()
            self.customRefreshControl.stopAnimating()
        }.store(in: &cancelBag)

        viewModel.$isLoading.receive(on: DispatchQueue.main).sink { [weak self] isLoading in
            isLoading ? self?.loadingIndicator.startAnimating() : self?.loadingIndicator.stopAnimating()
        }.store(in: &cancelBag)

        customRefreshControl.$refreshTriggered.receive(on: DispatchQueue.main).sink { triggered in
            if triggered { self.refresh() }
        }.store(in: &cancelBag)
    }

    @objc func refresh() {
        Task {
            try await viewModel.refresh()
            viewModel.filter(filters: [])
            searchBar.text = nil
        }
    }

    private func configureViews() {
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        view.addSubview(loadingIndicator)
        view.addSubview(customRefreshControl)

        collectionView.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.top.equalTo(searchBar)
        }

        searchBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }

        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(50)
            $0.width.equalTo(50)
        }

        customRefreshControl.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(3)
        }
    }

    func configureProperties() {
        collectionView.delegate = self
        view.backgroundColor = .white
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
        searchBar.placeholder = "Species"
        collectionView.contentInset = .init(top: 44, left: 0, bottom: 0, right: 0)
    }

    func makeDataSource() -> FoodListingDataSource {
        let registration =
            UICollectionView.CellRegistration<UICollectionViewListCell, FoodListingConfiguration> { cell, _, item in
                var configuration = cell.defaultContentConfiguration()
                configuration.text = item.name
                configuration.secondaryText = item.species
                cell.contentConfiguration = configuration
            }

        return FoodListingDataSource(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(
                using: registration, for: indexPath, item: item
            )
        }
    }

    func applyInitialSnapshots() {
        var categorySnapshot = NSDiffableDataSourceSnapshot<Section, FoodListingConfiguration>()
        categorySnapshot.appendSections([.listing])
        categorySnapshot.appendItems(viewModel.foods, toSection: .listing)
        dataSource.apply(categorySnapshot, animatingDifferences: false)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension FoodListingViewController: UICollectionViewDelegate {
    public func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelect(self, foodItem: dataSource.itemIdentifier(for: indexPath))
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
        customRefreshControl.scrollViewDidScroll(scrollView)
    }

    public func scrollViewDidEndDragging(_: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            customRefreshControl.scrollViewTouchesEnded()
        }
    }
}

extension FoodListingViewController: UISearchBarDelegate, UITextFieldDelegate {
    public func searchBarShouldEndEditing(_: UISearchBar) -> Bool {
        return true
    }

    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        guard let search = searchBar.text
        else {
            viewModel.filter(filters: [])
            return
        }

        if !search.isEmpty || search != "" {
            viewModel.filter(filters: [.species(search)])
        } else {
            viewModel.filter(filters: [])
        }
    }

    public func textFieldShouldClear(_: UITextField) -> Bool {
        view.endEditing(true)
        viewModel.filter(filters: [])
        return true
    }
}
