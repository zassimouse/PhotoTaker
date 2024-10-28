//
//  NetworkManager.swift
//  PhotoTaker
//
//  Created by Denis Haritonenko on 25.10.24.
//

import Foundation
import SwiftUI
import Alamofire

class NetworkService {
    static let shared = NetworkService()
    
    func getContent(page: Int) async throws -> ContentResponse? {
        guard let url = URL(string: "https://junior.balinasoft.com/api/v2/photo/type?page=\(page)") else {
            throw NSError(domain: "Bad URL", code: 0, userInfo: nil)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let contentResponse = try? JSONDecoder().decode(ContentResponse.self, from: data)
                
        return contentResponse
    }
    
    func uploadPhoto(name: String, photo: UIImage, typeId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
            let url = "https://junior.balinasoft.com/api/v2/photo"
            
            let parameters: [String: Any] = [
                "name": name,
                "typeId": typeId
            ]
            
            guard let imageData = photo.jpegData(compressionQuality: 1.0) else {
                completion(.failure(NSError(domain: "Image data error", code: 0, userInfo: nil)))
                return
            }
            
            AF.upload(
                multipartFormData: { multipartFormData in
                    for (key, value) in parameters {
                        multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                    }
                    multipartFormData.append(imageData, withName: "photo", fileName: "photo.jpg", mimeType: "image/jpeg")
                },
                to: url,
                method: .post
            ).response { response in
                print(response.response!)
                switch response.result {
                case .success:
                    if let httpResponse = response.response, httpResponse.statusCode == 200 {
                        completion(.success(()))
                    } else {
                        completion(.failure(NSError(domain: "Server error", code: 0, userInfo: nil)))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
}
