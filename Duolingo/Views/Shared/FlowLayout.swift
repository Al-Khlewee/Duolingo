//
//  FlowLayout.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//


// Views/Shared/FlowLayout.swift
import SwiftUI

struct FlowLayout: Layout {
    var spacing: CGFloat
    var lineSpacing: CGFloat

    init(spacing: CGFloat = 8, lineSpacing: CGFloat = 35) {
        self.spacing = spacing
        self.lineSpacing = lineSpacing
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var height: CGFloat = 0
        var currentX: CGFloat = 0
        var currentRow: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > maxWidth {
                currentX = 0
                currentRow += lineSpacing
            }
            if currentX == 0 {
                height = currentRow + size.height // Only update height at the start of a new row
            }
            currentX += size.width + spacing
        }
        return CGSize(width: maxWidth, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var currentX: CGFloat = bounds.minX
        var currentRow: CGFloat = bounds.minY

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > bounds.maxX {
                currentX = bounds.minX // Reset X to start of bounds
                currentRow += lineSpacing // Move to the next row
            }
            subview.place(
                at: CGPoint(x: currentX, y: currentRow),
                proposal: ProposedViewSize(size)
            )
            currentX += size.width + spacing
        }
    }
}