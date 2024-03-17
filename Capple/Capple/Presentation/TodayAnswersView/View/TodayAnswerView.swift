//
//  TodayAnswer.swift
//  Capple
//
//  Created by ShimHyeonhee on 3/3/24.
//

import Foundation
import SwiftUI
struct TodayAnswerView: View {
    @EnvironmentObject var pathModel: PathModel
    @ObservedObject var viewModel: TodayAnswersViewModel
    @Binding var tab: Tab
    var questionContent: String
    var questionId: Int
   
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  
    init(questionId: Int?, tab: Binding<Tab>, questionContent: String) {
        self.viewModel = TodayAnswersViewModel(questionId: questionId ?? 1, questionContent: questionContent)
        self._tab = tab
        self.questionContent = questionContent
        self.questionId = questionId ?? 2
    }

     
    var body: some View {
        @ObservedObject var sharedData = SharedData()
        
        VStack(alignment: .leading) {
            CustomNavigationView()
           // KeywordScrollView(viewModel: viewModel)
            Spacer()
                .frame(height: 16)
           
            FloatingQuestionCard(questionId: questionId, tab: $tab, questionContent: questionContent)
            Spacer()
                .frame(height: 32)
            AnswerScrollView(viewModel: viewModel, tab: $tab)
        }
        .navigationBarBackButtonHidden()
        .background(Color.Background.first)
    }
}

// MARK: - 커스텀 네비게이션
private struct CustomNavigationView: View {
    var body: some View {
        CustomNavigationBar(
            leadingView:{
                CustomNavigationBackButton(buttonType: .arrow)
            },
            principalView: {
                Text("오늘의 답변")
                    .font(Font.pretendard(.semiBold, size: 15))
                    .foregroundStyle(TextLabel.main)
            },
            trailingView: {},
            backgroundColor: .clear
        )
    }
}

// MARK: - 키워드 스크롤 뷰
private struct KeywordScrollView: View {
    
    @ObservedObject var viewModel: TodayAnswersViewModel
    
    fileprivate init(viewModel: TodayAnswersViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(viewModel.keywords, id: \.self) { keyword in
                    KeywordSelector(
                        keywordText: keyword,
                        keywordCount: 13) {
                            // TODO: 키워드 선택
                        }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - 플로팅 질문 카드
private struct FloatingQuestionCard: View {
    var questionContent: String
    var questionId: Int?  // 추가됨
    @Binding var tab: Tab
    @ObservedObject var viewModel: TodayAnswersViewModel
    @State private var isCardExpanded = true
    
  
    init(questionId: Int?, tab: Binding<Tab>, questionContent: String) {
           self.viewModel = TodayAnswersViewModel(questionId: questionId ?? 1, questionContent: questionContent)
           self._tab = tab
           self.questionContent = questionContent
       }
    var body: some View {
        HStack {
            Text(questionContent)
                .font(.pretendard(.semiBold, size: 15))
                .foregroundStyle(TextLabel.main)
                .lineLimit(isCardExpanded ? 3 : 0)
            Spacer() // 화살표를 오른쪽으로 밀어내기 위해 Spacer 추가
            
            Button {
                withAnimation {
                    isCardExpanded.toggle() // 버튼 클릭 시 카드 확장/축소 상태 토글
                }
            } label: {
                Image(isCardExpanded ? .arrowUp : .arrowDown)
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundColor(.white)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .background(GrayScale.secondaryButton)
        .cornerRadius(15)
        .padding(.horizontal, 20)
    }
    
}

// MARK: - 답변 스크롤 뷰
private struct AnswerScrollView: View {
 //   @ObservedObject var sharedData = SharedData()
    
    @Binding var tab: Tab
   
    let seeMoreAction: () -> Void
    
    @EnvironmentObject var pathModel: PathModel
    @ObservedObject var viewModel: TodayAnswersViewModel
    @State private var isBottomSheetPresented = false
  
    init(viewModel: TodayAnswersViewModel, tab: Binding<Tab>) {
        self.viewModel = viewModel
        //sharedData = SharedData()
        self.seeMoreAction = {}
        self.isBottomSheetPresented = false
        self._tab = tab
       
    }
  
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack{
                ForEach(Array(viewModel.answers.enumerated()), id: \.offset) { index, answer in
                        SingleAnswerView(answer: answer, seeMoreAction: {
                            print(index)
                            isBottomSheetPresented.toggle()
                        }, seeMoreReport: {
                            tab = .answering
                            return CGPoint(x: 10.0, y: CGFloat(index * 100)) // 단순 예시
                        })
                    /*
                        .onTapGesture {self.sharedData.reportButtonPosition = CGPoint(x: 270, y: -index * 100)            }
                     */
                        .sheet(isPresented: $isBottomSheetPresented) {
                            SeeMoreView(isBottomSheetPresented: $isBottomSheetPresented)
                                .presentationDetents([.height(84)])
                        }
                    }
                    
                
        }
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding(.vertical, 20)
                }
            }
        .padding(.horizontal,24)
    }
}

struct TodayAnswerView_Previews: PreviewProvider {
    static var previews: some View {
        TodayAnswerView(questionId: 1, tab: .constant(.answering), questionContent: "디폴트")
    }
}
