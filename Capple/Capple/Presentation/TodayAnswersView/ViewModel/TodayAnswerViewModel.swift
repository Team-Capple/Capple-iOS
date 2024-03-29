
//
//  TodayAnswer.swift
//  Capple
//
//  Created by ShimHyeonhee on 3/3/24.
//


import Foundation

class TodayAnswersViewModel: ObservableObject {
    
    @Published var keywords: [String] = []
    @Published var todayQuestion: String = ""
    @Published var answers: [ServerResponse.Answers.AnswersInfos] = []
    @Published var filteredAnswer: [ServerResponse.Answers.AnswersInfos] = []
    @Published var searchQuery = ""
    @Published var isLoading = false
    
    /// 답변 호출 API입니다.
    func loadAnswersForQuestion(questionId: Int) {
        
        // URL 생성
        guard let url = URL(string: "http://43.203.126.187:8080/answers/question/\(questionId)") else {
            print("유효하지 않은 URL")
            return
        }
        
        // Request 생성
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(SignInInfo.shared.accessToken())", forHTTPHeaderField: "Authorization")
        
        // URLSession 실행
        do {
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    
                    // 에러 검사
                    if let error = error {
                        print("Error submitting answer: \(error)")
                        return
                    }
                    
                    // 데이터 검사
                    guard let data = data else {
                        print("No data in response")
                        return
                    }
                    
                    // Decoding
                    do {
                        let decodedData = try JSONDecoder().decode(BaseResponse<ServerResponse.Answers>.self, from: data)
                        DispatchQueue.main.async {
                            self.answers = decodedData.result.answerInfos
                            print(self.answers)
                        }
                    } catch {
                        print("ServerResponse.Answers - Error decoding response: \(error)")
                    }
                }
            }
            .resume()
        }
    }
}
