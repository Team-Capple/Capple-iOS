//
//  NetworkManager+Answer.swift
//  Capple
//
//  Created by 김민준 on 3/14/24.
//

import Foundation

// MARK: - 답변 관련 API
extension NetworkManager {
    
    /// 특정 질문에 대한 답변을 조회합니다.
    static func fetchAnswersOfQuestion(request: AnswerRequest.AnswersOfQuestion) async throws -> AnswerResponse.AnswersOfQuestion {
        
        // URL 객체 생성
        let urlString = ApiEndpoints.basicURLString(path: .answersOfQuestion) + "/\(request.questionId)?" + "keyword=\(request.keyword ?? "")&size=\(request.size ?? 10)"
        guard let url = URL(string: urlString) else {
            print("Error: cannotCreateURL")
            throw NetworkError.cannotCreateURL
        }
        
        // 토큰 추가
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(SignInInfo.shared.accessToken())", forHTTPHeaderField: "Authorization")
        
        // URLSession 생성
        let (data, response) = try await URLSession.shared.data(for: request)
        // print(data)
        // print(response)
        
        // 에러 체크
        if let response = response as? HTTPURLResponse,
           !(200..<300).contains(response.statusCode) {
            print("Error: badRequest")
            throw NetworkError.badRequest
        }
        
        // 디코딩
        let decoder = JSONDecoder()
        let decodeData = try decoder.decode(BaseResponse<AnswerResponse.AnswersOfQuestion>.self, from: data)
        // print("AnswerResponse.AnswersOfQuestion: \(decodeData.result)")
        return decodeData.result
    }
    
    /// 답변을 등록합니다.
    static func requestRegisterAnswer(request: AnswerRequest.RegisterAnswer, questionID: Int) async throws -> AnswerResponse.RegisterAnswer {
        
        // JSON Request
        guard let requestData = try? JSONEncoder().encode(request) else {
            print("JSON Request 데이터 생성 실패")
            throw NetworkError.badRequest
        }
        
        // URL 객체 생성
        let urlString = ApiEndpoints.basicURLString(path: .answersOfQuestion) + "/\(questionID)"
        guard let url = URL(string: urlString) else {
            print("URL 객체 생성 실패")
            throw NetworkError.cannotCreateURL
        }
        
        // Request 객체 생성
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(SignInInfo.shared.accessToken())", forHTTPHeaderField: "Authorization")
        
        // URLSession 실행
        let (data, response) = try await URLSession.shared.upload(for: request, from: requestData)
        // print(response)
        
        // 에러 체크
        if let response = response as? HTTPURLResponse,
           !(200..<300).contains(response.statusCode) {
            throw NetworkError.badRequest
        }
        
        // 디코딩
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(BaseResponse<AnswerResponse.RegisterAnswer>.self, from: data)
            // print("AnswerResponse.RegisterAnswer: \(decodeData.result)")
            return decodeData.result
        } catch {
            throw NetworkError.decodeFailed
        }
    }
}
