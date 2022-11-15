//
//  PaddedLabel.swift
//  ReferenceArchitectureNonModular
//
//  Created by Kurt Jacobs on 2022/11/07.
//

import UIKit

public class PaddingLabel: UILabel {
    var padding = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }

    override open func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: padding)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -padding.top,
                                          left: -padding.left,
                                          bottom: -padding.bottom,
                                          right: -padding.right)
        return textRect.inset(by: invertedInsets)
    }

    override public func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override public func layoutSubviews() {
        isHidden = text == "" || text == nil
    }
}
