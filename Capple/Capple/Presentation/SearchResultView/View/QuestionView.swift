import SwiftUI
import FlexView
import Foundation

// 하나의 질문을 보여주는 뷰를 정의합니다.
struct QuestionView: View {
    @EnvironmentObject var pathModel: PathModel
    @Binding var tab: Tab
    @State private var showingReportSheet = false // 모달 표시를 위한 상태 변수
    @State var questions: QuestionResponse.Questions.QuestionsInfos // 이 뷰에서 사용할 질문 객체입니다.
    @State private var dateString: String = "" // 상태 변수 정의
    //@ObservedObject var viewModel:TodayQuestionViewModel
    let seeMoreAction: () -> Void
    var questionStatus: String = ""
    
   
   
    func formattedDate(from dateString: String) -> String {
        print(dateString, "비동기인가요?")
        
        let inputFormatter = DateFormatter()
           inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
           
           if let date = inputFormatter.date(from: dateString) {
               let outputFormatter = DateFormatter()
               outputFormatter.dateFormat = "yyyy-MM-dd"
               return outputFormatter.string(from: date)
           } else {
               return "실패!" // 잘못된 입력 형식일 경우 처리
           }
        
    }
    // MARK: - 오전/오후 시간표현

    func getTimePeriod(from dateString: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "ko_KR") // 한국 시간으로 설정
        
        if let date = inputFormatter.date(from: dateString) {
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            
            // TODO: 로직 추가하기 (시간대에 맞추기)
            if hour < 12 {
                return "오전"
            } else {
                return "오후"
            }
        } else {
            return "잘못됨" // 잘못된 입력 형식일 경우 처리
        }
    }
    var questionStatusRawValue: String {
        switch questions.questionStatus {
        case .live:
            return QuestionStatus.live.rawValue
        /*
        case .old:
            return QuestionStatus.old.rawValue
        case .hold:
            return QuestionStatus.hold.rawValue
        case .pending:
            return QuestionStatus.pending.rawValue
         */
        default:
            return ""
        }
    }
    
    
    
    //@State private var isLike = false
    //@State private var isComment = false
    
    var body: some View {
        
        
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                
                Text("\(getTimePeriod(from: questions.livedAt ?? "default") ?? "오전")질문")
                    .font(.pretendard(.semiBold, size: 14))
                    .foregroundStyle(GrayScale.icon)
                
                Spacer()
                    .frame(width: 4)
                
                Rectangle()
                    .frame(width: 1, height: 10)
                    .foregroundStyle(GrayScale.icon)
                
                Spacer()
                    .frame(width: 4)
                
            
                Text(formattedDate(from: questions.livedAt ?? "default"))
                    .font(.pretendard(.semiBold, size: 14))
                    .foregroundStyle(GrayScale.icon)
                
                Spacer()
                    .frame(width: 8)
                
                if !questionStatusRawValue.isEmpty{
                    Text(questionStatusRawValue)
                        .font(.pretendard(.bold, size: 9))
                        .foregroundStyle(.wh)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Context.onAir)
                        .cornerRadius(18, corners: .allCorners)
                    
                }
                Spacer()
                
                HStack(alignment: .center) {
                    /*
                    Button {
                        seeMoreAction()
                        
                        //  showingReportSheet = true
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(TextLabel.sub2)
                            .frame(width: 20, height:  20)
                    }
                     */
                }
            } 
            Spacer()
                .frame(height: 16)
            
            // MARK: - 본문
            Text(questions.content ?? "Default Content") // 질문의 내용을 표시합니다.
                .font(.pretendard(.bold, size: 17))
                .foregroundStyle(TextLabel.main)
            
            Spacer()
                .frame(height: 20)
            
            HStack {
                
                Text(questions.tag?
                    .split(separator: " ")
                    .map { "#\($0)" }
                    .joined(separator: " ") ?? "#tag")
                .font(.pretendard(.semiBold, size: 14))
                .foregroundStyle(BrandPink.text)
                Spacer()
                
                
                if questions.isAnswered == false { // isAnswered가 true일 때만 표시
                       Button {
                           // TODO: 답변하기 뷰에서 id 까지 전달 => 제목 보여주기(정보는 있음)
                           pathModel.paths.append(.answer)
                       } label: {
                           Text("답변하기")
                               .font(.pretendard(.medium, size: 14))
                               .foregroundStyle(TextLabel.main)
                               .padding(.horizontal, 12)
                               .padding(.vertical, 8)
                               .background(BrandPink.button)
                               .cornerRadius(30, corners: .allCorners)
                       }
                   }
                
            }
            
            // MARK: - 좋아요, 댓글
            HStack {
                //                    Button {
                //                        isLike.toggle()
                //                        viewModel.likeButtonTapped(for: questions)
                //                        // TODO: - 좋아요 탭 기능 구현
                //                    } label: {
                //                        HStack(spacing: 6) {
                //                            Image(isLike ? .heartActive : .heart)
                //                                .resizable()
                //                                .frame(width: 24, height: 24)
                //                                .foregroundStyle(isLike ? BrandPink.button : GrayScale.secondaryButton)
                //                            Text(String(questions.likeCount ?? 0)) // 질문의 내용을 표시합니다.
                //                                .font(.pretendard(.medium, size: 15))
                //                                .foregroundStyle(TextLabel.sub3)
                //
                //                        }
                //                    }
                //
                //                    Spacer()
                //                        .frame(width: 12)
                //
                //                    Button {
                //                        isComment.toggle()
                //                        // TODO: - 댓글 창 이동
                //                    } label: {
                //                        HStack(spacing: 6) {
                //                            Image(isComment ? .commentActive : .comment)
                //                                .resizable()
                //                                .frame(width: 24, height: 24)
                //                                .foregroundStyle(isComment ? BrandPink.button : GrayScale.secondaryButton)
                //
                //                            Text(String(questions.commentCount ?? 0))
                //                                .font(.pretendard(.medium, size: 15))
                //                                .foregroundStyle(TextLabel.sub3)
                //                        }
                //                    }
            }
        }
        .background(Background.first) // 배경색을 설정하고 투명도를 조절합니다.
    }
}
 

struct DummyData {
    static let questionsInfo = QuestionResponse.Questions.QuestionsInfos(questionStatus: .live, livedAt: "2021-01-01T00:00:00Z", content: "This is a sample question", isAnswered: true)
}

// SwiftUI 프리뷰 구성
struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        // 여기서 필요한 모든 데이터를 전달합니다.
        // 예시용으로 임시 데이터를 생성하거나 기본값을 설정합니다.
        QuestionView(tab: .constant(.collecting), questions: DummyData.questionsInfo, seeMoreAction: {}).environmentObject(PathModel())
    }
}



extension Date {
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}
