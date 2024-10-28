//
//  HomeViewModel.swift
//  PhotoTaker
//
//  Created by Denis Haritonenko on 25.10.24.
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    @Published var items = [ContentItem]()
    @Published var selectedId: Int?
    @Published var isUploading = false
    @Published var errorMessage: String?
    
    @Published var selectedImage: UIImage? {
        didSet {
            self.uploadPhoto()
        }
    }
    
    var currentPage = 0
    var totalPages = 1
    
    @MainActor
    func loadContent(reset: Bool = false) async {
        if reset {
            items = []
            currentPage = 0
        } else {
            guard currentPage < totalPages else { return }
            currentPage += 1
        }
        
        do {
            let response = try await NetworkService.shared.getContent(page: currentPage)
            if let newItems = response?.content {
                if reset {
                    items = newItems
                } else {
                    items.append(contentsOf: newItems)
                }
                totalPages = response?.totalPages ?? 1
            }
        } catch {
            print("Error loading content: \(error)")
        }
    }
    
    
    func uploadPhoto() {
        if let image = selectedImage, let id = selectedId {
            let name = "Харитоненко Денис Алексеевич"
            
            NetworkService.shared.uploadPhoto(name: name, photo: image, typeId: id) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        print("Photo uploaded successfully")
                    case .failure(let error):
                        print("Error uploading photo: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
}
