//
//  EnvironmentExampleSwiftUIView.swift
//  SwiftUI101
//
//  Created by chenyilong on 2026/1/21.
//

import SwiftUI
import Observation

@Observable
class PersonViewModel {
    
    var firstName: String = "Yilong"
    var lastName: String = "Chen"
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    func changePerson() {
        let names: [(String, String)] = [
            ("Elon", "Chan"),
            ("Elmo", "Lee"),
            ("Cookie", "Monster"),
            ("Oscar", "the Grouch"),
            ("Bert", ""),
            ("Ernie", "")
        ]
        
        let randomName = names.randomElement() ?? ("", "")
        firstName = randomName.0
        lastName = randomName.1
    }
}

struct EnvironmentExampleSwiftUIView: View {
    //承 🛐
    @Environment(PersonViewModel.self) private var personViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text(personViewModel.fullName)
                .font(.title)
            //转 ↩️
            Button("Change Person") {
                personViewModel.changePerson()
            }
            let url = URL(string: "https://avatars.githubusercontent.com/u/2911921")!
            ImageFromURL(url: url)
                .background(Color(UIColor(red: CGFloat(Int.random(in: 0...255)) / 255,
                                          green: CGFloat(Int.random(in: 0...255)) / 255,
                                          blue: CGFloat(Int.random(in: 0...255)) / 255,
                                          alpha: 1)))
            
        }
        .padding()
    }
}

struct ImageFromURL: View {
    
    let url: URL
    var width: CGFloat? = nil
    var height: CGFloat? = nil
    var contentMode: ContentMode = .fit
    var cornerRadius: CGFloat = 0
    var body: some View {
        
        AsyncImage(url: url) {
            phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .frame(width: width, height: height)
                    .cornerRadius(cornerRadius)
            case .failure:
                Image(systemName: "photo")
                    .imageScale(.large)
                Text("Failed to load image")
            case .empty:
                ProgressView()
            @unknown default:
                EmptyView()
            }
        }
    }
    
}

#Preview {
    //personViewModel is specific and internal to a single class, declare  personViewModel as static  at the top of the file //启 🛫
    @Previewable @State var personViewModel = PersonViewModel()
    //合 🈴
    EnvironmentExampleSwiftUIView()
        .environment(personViewModel)
}
