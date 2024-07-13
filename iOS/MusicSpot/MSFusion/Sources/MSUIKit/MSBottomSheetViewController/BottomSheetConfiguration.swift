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
        public enum Dimension {
            case fractional(CGFloat)
            case absolute(CGFloat)
        }

        // MARK: - Properties

        var standardMetric: CGFloat?

        let fullDimension: Dimension
        let detentDimension: Dimension
        let minimizedDimension: Dimension

        var fullHeight: CGFloat {
            return self.calculateHeight(for: self.fullDimension)
        }

        var detentHeight: CGFloat {
            return self.calculateHeight(for: self.detentDimension)
        }

        var minimizedHeight: CGFloat {
            return self.calculateHeight(for: self.minimizedDimension)
        }

        var fullDetentDiff: CGFloat {
            return self.fullHeight - self.detentHeight
        }

        var detentMinimizedDiff: CGFloat {
            return self.detentHeight - self.minimizedHeight
        }

        // MARK: - Initializer

        public init(fullDimension: Dimension,
                    detentDimension: Dimension,
                    minimizedDimension: Dimension) {
            self.fullDimension = fullDimension
            self.detentDimension = detentDimension
            self.minimizedDimension = minimizedDimension
        }

        // MARK: - Helpers

        private func calculateHeight(for dimension: Dimension) -> CGFloat {
            guard let standardMetric = standardMetric else { return .zero }

            switch dimension {
            case .fractional(let fractionalDimension):
                return standardMetric * fractionalDimension
            case .absolute(let absoluteDimension):
                return absoluteDimension
            }
        }
    }
}
