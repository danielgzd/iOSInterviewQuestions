//
//  ScrollTransitionSwiftUIView.swift
//  SwiftUI101
//
//  Created by chenyilong on 2026/1/26.
//
import SwiftUI

enum CarouselImage: String, CaseIterable, Identifiable {
    case iteatime
    case iteatime1
    case iteatime2
    case iteatime3
    case iteatime4
    
    // MARK: - Identity
    var id: String { rawValue }
    
    // MARK: - Display index (1-based, for UI)
    var displayIndex: Int {
        Self.allCases.firstIndex(of: self)! + 1
    }
    
    // MARK: - Title
    var title: String {
        "Image \(displayIndex)"
    }
    
    // MARK: - Analytics tag
    var analyticsTag: String {
        "carousel_image_\(displayIndex)"
    }
}


extension CarouselImage {
    static var looped: [CarouselImage] {
        guard let first = allCases.first,
              let last = allCases.last else {
            return []
        }
        return [last] + allCases + [first]
    }
}

extension Image {
    init(_ asset: CarouselImage) {
        self.init(asset.rawValue)
    }
}

struct ScrollTransitionSwiftUIView: View {
    let images = CarouselImage.allCases
    let loopImages = CarouselImage.looped
    
    @State private var currentIndex: Int? = nil  // ✅ Initialized as nil
    @State private var hasAppeared = false       // ✅ Track first load
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(loopImages.indices, id: \.self) { index in
                            VStack {
                                Image(loopImages[index].rawValue)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geo.size.width - 32)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .scrollTransition { content, phase in
                                        content
                                            .scaleEffect(phase.isIdentity ? 1.0 : 0.9)
                                            .opacity(phase.isIdentity ? 1.0 : 0.6)
                                    }
                                    .containerRelativeFrame(.horizontal)
                                    .id(index)
                                Text("\(loopImages[index].title)")
                                    .font(.largeTitle)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.black)

                                
                            }
                        }
                    }
                    .scrollTargetLayout()
                    .contentMargins(16, for: .scrollContent)
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $currentIndex)
                .onAppear {
                    // ✅ Set to the first image (index = 1) on initial load
                    if !hasAppeared {
                        currentIndex = 1
                        hasAppeared = true
                    }
                }
                .onChange(of: currentIndex) { oldValue, newValue in
                    handleLoopingIfNeeded(newValue)
                }
                
                Spacer()
            }
        }
    }
    
    // MARK: - Infinite scroll correction logic
    private func handleLoopingIfNeeded(_ index: Int?) {
        guard let index = index, hasAppeared else { return }
        
        let lastIndex = loopImages.count - 1
        
        if index == 0 {
            // From the false head → jump to the true tail
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                currentIndex = lastIndex - 1
            }
        } else if index == lastIndex {
            // From the fake tail → jump to the real head
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                currentIndex = 1
            }
        }
    }
}

#Preview {
    ScrollTransitionSwiftUIView()
}

