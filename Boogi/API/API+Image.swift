//
//  API+Image.swift
//  Boogi
//
//  Created by 김덕환 on 2022/05/29.
//

import Foundation
import UIKit

extension WebService {
    func makeBody(boundary: String, images: [UIImage]) -> Data? {
        guard let boundaryPrefix = "\r\n--\(boundary)\r\n".data(using: .utf8) else { return nil }
        guard let boundarySuffix = "\r\n--\(boundary)--\r\n".data(using: .utf8) else { return nil }
        
        var body = Data()
        
        for (i, image) in images.enumerated() {
            // (boundary)로 시작.
            body.append(boundaryPrefix)
            
            // 헤더 정의 - 문자열로 작성 후 UTF8로 인코딩해서 Data타입으로 변환해야 함
            body.append("Content-Disposition: form-data; name=\"image\"; filename=\"img\(i)\"\r\n".data(using: .utf8)!)
            
            // 헤더 정의 2 - 문자열로 작성 후 UTF8로 인코딩해서 Data타입으로 변환해야 함, 구분은 \r\n으로 통일.
            body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            
            // 내용 붙이기
            body.append(image.pngData()!)
        }
        
        // 내용 끝나는 곳에 (boundary)로 표시해준다.
        body.append(boundarySuffix)
        
        return body
    }
    
    func createPostwithImage(images: [UIImage]) async throws -> [String] {
        guard let url = URL(string: "\(imgBase)/images/post") else { throw URLError.init(.badURL) }
        let boundary = UUID().uuidString
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = makeBody(boundary: boundary, images: images)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let res = try JSONDecoder().decode(PostImage.self, from: data)
        
        return res.postMediaIds
    }
}
