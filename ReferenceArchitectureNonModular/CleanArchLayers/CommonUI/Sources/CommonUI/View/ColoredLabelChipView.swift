//
//  ColoredLabelChip.swift
//  ReferenceArchitectureNonModular
//
//  Created by Kurt Jacobs on 2022/11/07.
//

import SnapKit
import UIColorHexSwift
import UIKit

public struct ColoredLabelChipViewContentConfiguration {
    public var title: String?

    public init(title: String?) {
        self.title = title
    }
}

public struct ColoredLabelChipViewStyleConfiguration {
    public var backgroundColor: String
    public var textColor: String

    public init(backgroundColor: String, textColor: String) {
        self.backgroundColor = backgroundColor
        self.textColor = textColor
    }
}

public class ColoredLabelChipView: UIView {
    public private(set) var titleLabel = PaddingLabel()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
        updateContentConfiguration()
        updateStyleConfiguration()
        titleLabel.padding = .init(top: 20, left: 20, bottom: 20, right: 20)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureViews() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    public var contentConfiguration: ColoredLabelChipViewContentConfiguration =
    .init(title: "") {
        didSet {
            updateContentConfiguration()
        }
    }

    public var styleConfiguration: ColoredLabelChipViewStyleConfiguration =
    .init(backgroundColor: "#FFFFDA", textColor: "#000000") {
        didSet {
            updateStyleConfiguration()
        }
    }

    private func updateContentConfiguration() {
        titleLabel.text = contentConfiguration.title
    }

    private func updateStyleConfiguration() {
        backgroundColor = UIColor(styleConfiguration.backgroundColor)
        titleLabel.textColor = UIColor(styleConfiguration.textColor)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        let frameHeight = frame.height
        layer.cornerRadius = frameHeight / 2
        isHidden = titleLabel.text == "" || titleLabel.text == nil
    }
}
