//
//  BottomSheetConfiguration.swift
//  MSUIKit
//
//  Created by 이창준 on 2023.12.01.
//

import CoreGraphics
import Foundation

extension MSBottomSheetViewController {
    public struct Configuration {

        // MARK: Lifecycle

        // MARK: - Initializer

        public init(
            fullDimension: Dimension,
            detentDimension: Dimension,
            minimizedDimension: Dimension)
        {
            self.fullDimension = fullDimension
            self.detentDimension = detentDimension
            self.minimizedDimension = minimizedDimension
        }

        // MARK: Public

        public enum Dimension {
            case fractional(CGFloat)
            case absolute(CGFloat)
        }

        // MARK: Internal

        // MARK: - Properties

        var standardMetric: CGFloat?

        let fullDimension: Dimension
        let detentDimension: Dimension
        let minimizedDimension: Dimension

        var fullHeight: CGFloat {
            calculateHeight(for: fullDimension)
        }

        var detentHeight: CGFloat {
            calculateHeight(for: detentDimension)
        }

        var minimizedHeight: CGFloat {
            calculateHeight(for: minimizedDimension)
        }

        var fullDetentDiff: CGFloat {
            fullHeight - detentHeight
        }

        var detentMinimizedDiff: CGFloat {
            detentHeight - minimizedHeight
        }

        // MARK: Private

        // MARK: - Helpers

        private func calculateHeight(for dimension: Dimension) -> CGFloat {
            guard let standardMetric else { return .zero }

            switch dimension {
            case .fractional(let fractionalDimension):
                return standardMetric * fractionalDimension
            case .absolute(let absoluteDimension):
                return absoluteDimension
            }
        }
    }
}
