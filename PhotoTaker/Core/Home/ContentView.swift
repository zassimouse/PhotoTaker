//
//  ContentView.swift
//  PhotoTaker
//
//  Created by Denis Haritonenko on 25.10.24.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    @State private var showCamera = false
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(viewModel.items) { item in
                        Button {
                            viewModel.selectedId = item.id
                            self.showCamera.toggle()
                        } label: {
                            VStack {
                                HStack {
                                    Text(item.name)
                                        .font(.headline)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 15, height: 15)
                                }
                                
                                if let imageUrl = item.image {
                                    KFImage(URL(string: imageUrl))
                                        .resizable()
                                        .frame(height: 200)
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                        .clipped()
                                }
                            }
                            .padding(15)
                            .foregroundStyle(Color(.label))
                            .background(Color(.secondarySystemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .onAppear {
                            if item == viewModel.items.last && viewModel.currentPage < viewModel.totalPages {
                                Task { await viewModel.loadContent() }
                            }
                        }
                        .fullScreenCover(isPresented: self.$showCamera) {
                            AccessCameraView(selectedImage: self.$viewModel.selectedImage)
                                .background(Color.black)
                        }
                    }
                }
                .padding()
                
            }
            .onAppear {
                Task { await viewModel.loadContent(reset: true) }
            }
        }
        .navigationTitle("Photo List")
    }
}

#Preview {
    ContentView()
}
