//
//  File.swift
//
//
//  Created by Kurt Jacobs on 2022/11/08.
//

import UIKit

public class CustomRefreshControl: UIView {
    private var animatedView = UIView()
    private var currentProgress: CGFloat = 0.0
    @Published public var refreshTriggered: Bool = false
    private var isAnimating: Bool = false
    private var timer: Timer?
    private var animationIndex = 0
    private let colors: [UIColor] = [
        .systemPurple,
        .systemRed,
        .systemBlue,
        .systemPink,
        .systemYellow,
        .systemOrange
    ]

    public init() {
        super.init(frame: .zero)
        addSubview(animatedView)
        animatedView.backgroundColor = .systemPurple
        animatedView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0)
        }
    }

    public func update(progress: CGFloat) {
        guard !isAnimating else { return }
        let clipping = min(progress, 1)
        animatedView.snp.remakeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(clipping)
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let topInset = scrollView.contentInset.top
        if scrollView.contentOffset.y < -topInset {
            let offset = abs(scrollView.contentOffset.y) - topInset
            if offset >= 0 {
                let clipOffset = min(offset, 100)
                let progress = 1 - (1 - (clipOffset / 100.0))
                currentProgress = progress
                update(progress: max(0, progress))
            }
        } else {
            currentProgress = 0.0
            update(progress: max(0, 0))
        }
    }

    public func scrollViewTouchesEnded() {
        if currentProgress >= 1.0 {
            startAnimating()
            refreshTriggered = true
        }
    }

    private func startAnimating() {
        isAnimating = true
        animatedView.snp.remakeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(1.0)
        }

        timer = Timer.scheduledTimer(timeInterval: 0.2,
                                     target: self,
                                     selector: #selector(animateColors),
                                     userInfo: nil,
                                     repeats: true)
    }

    @objc private func animateColors() {
        animationIndex += 1
        UIView.animate(withDuration: 0.1, delay: 0) {
            self.animatedView.backgroundColor = self.colors[self.animationIndex % self.colors.count]
        }
    }

    public func stopAnimating() {
        timer?.invalidate()
        animationIndex = 0
        isAnimating = false
        UIView.animate(withDuration: 0.25, delay: 0) {
            self.animatedView.backgroundColor = .systemPurple
            self.animatedView.snp.remakeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.centerX.equalToSuperview()
                $0.width.equalToSuperview().multipliedBy(0)
            }
            self.layoutIfNeeded()
        }
    }
}
