//
//  ScrollTransitionSwiftUIView.swift
//  SwiftUI101
//
//  Created by chenyilong on 2026/1/26.
//
import SwiftUI
import SwiftUI

// MARK: - Model
enum LazyVGridCarouselImage: String, CaseIterable, Identifiable {
    case iteatime
    case iteatime1
    case iteatime2
    case iteatime3
    case iteatime4

    var id: String { rawValue }

    // 1-based index for UI
    var displayIndex: Int {
        Self.allCases.firstIndex(of: self)! + 1
    }

    var title: String {
        "Image \(displayIndex)"
    }

    var analyticsTag: String {
        "carousel_image_\(displayIndex)"
    }
}

// MARK: - Image convenience init
extension Image {
    init(_ asset: LazyVGridCarouselImage) {
        self.init(asset.rawValue)
    }
}

// MARK: - View
struct LazyVGridScrollTransitionSwiftUIView: View {
    let images = LazyVGridCarouselImage.allCases

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(images) { image in
                    VStack(spacing: 12) {
                        Image(image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 12.0))
                            .shadow(radius: 20)

                        Text(image.title)
                            .font(.headline)
                            .foregroundStyle(.primary)
                    }
                }
            }
            .padding(16)
        }
    }
}

// MARK: - Preview
#Preview {
    LazyVGridScrollTransitionSwiftUIView()
}
