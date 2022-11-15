//
//  FoodDetailViewController.swift
//  ReferenceArchitectureNonModular
//
//  Created by Kurt Jacobs on 2022/11/06.
//

import Combine
import CommonUI
import NVActivityIndicatorView
import SnapKit
import UIKit

public class FoodDetailViewController: UIViewController {
    private var cancelBag: Set<AnyCancellable> = []
    private var viewModel: FoodDetailViewModel
    private var titleLabel = ColoredLabelChipView()
    private var soilImpactLabel = ColoredLabelChipView()
    private var cultivationCategoryLabel = ColoredLabelChipView()
    private var speciesLabel = ColoredLabelChipView()
    private var labelStack = UIStackView()
    private var loadingIndicator = NVActivityIndicatorView(frame: .zero, color: .systemGray)

    init(viewModel: FoodDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Food Detail"
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureProperties()
        configureBindings()
        refresh()
    }

    private func configureViews() {
        labelStack.addArrangedSubview(titleLabel)
        labelStack.addArrangedSubview(speciesLabel)
        labelStack.addArrangedSubview(cultivationCategoryLabel)
        labelStack.addArrangedSubview(soilImpactLabel)
        labelStack.addArrangedSubview(UIView())
        view.addSubview(labelStack)
        view.addSubview(loadingIndicator)

        labelStack.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.bottom.left.right.equalToSuperview()
        }

        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(50)
            $0.width.equalTo(50)
        }
    }

    private func configureProperties() {
        titleLabel.titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        labelStack.alignment = .center
        labelStack.axis = .vertical
        labelStack.spacing = 10
        view.backgroundColor = .white
    }

    private func configureBindings() {
        viewModel.$foodDetail.receive(on: DispatchQueue.main).sink { [weak self] foodDetail in
            guard let self = self else { return }
            self.titleLabel.contentConfiguration = ColoredLabelChipViewContentConfiguration(title: foodDetail?.name)
            self.soilImpactLabel.contentConfiguration = ColoredLabelChipViewContentConfiguration(title: foodDetail?.soilImpact)
            self.cultivationCategoryLabel.contentConfiguration = ColoredLabelChipViewContentConfiguration(title: foodDetail?.cultivationCategory)
            self.speciesLabel.contentConfiguration = ColoredLabelChipViewContentConfiguration(title: foodDetail?.species)
        }.store(in: &cancelBag)

        viewModel.$isLoading.receive(on: DispatchQueue.main).sink { [weak self] isLoading in
            isLoading ? self?.loadingIndicator.startAnimating() : self?.loadingIndicator.stopAnimating()
        }.store(in: &cancelBag)
    }

    @objc func refresh() {
        Task { try await viewModel.refresh() }
    }
}
