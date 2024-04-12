//
//  ReportView.swift
//  Capple
//
//  Created by 김민준 on 3/2/24.
//

import SwiftUI

struct ReportView: View {
    
    @EnvironmentObject var pathModel: PathModel
    @State private var isReportAlertPresented = false
    @State private var isReportCompleteAlertPresented = false
    @State private var reportType: ReportType = .DISTRIBUTION_OF_ILLEGAL_PHOTOGRAPHS
    
    let answerId: Int
    
    var reportList = [
        "불법촬영물 등의 유통",
        "상업적 광고 및 판매",
        "게시판 성격에 부적절함",
        "욕설/비하",
        "정당/정치인 비하 및 선거운동",
        "유출/사칭/사기",
        "낚시/놀림/도배"
    ]
    
    var body: some View {
        ZStack {
            Color(Background.first)
                .ignoresSafeArea()
            
            VStack {
                CustomNavigationBar(
                    leadingView:{
                        CustomNavigationBackButton(buttonType: .arrow)  {
                            pathModel.paths.removeLast()
                        }
                    },
                    principalView: {
                        Text("신고하기")
                            .font(Font.pretendard(.semiBold, size: 15))
                            .foregroundStyle(TextLabel.main)
                    },
                    trailingView: {},
                    backgroundColor: .clear
                )
                
                VStack {
                    ForEach(Array(reportList.enumerated()), id: \.offset) { index, report in
                        Button {
                            reportType = ReportType.allCases[index]
                            isReportAlertPresented.toggle()
                            HapticManager.shared.notification(type: .warning)
                            print("신고타입: \(reportType)")
                        } label: {
                            Text(report)
                                .font(.pretendard(.medium, size: 16))
                                .foregroundStyle(.wh)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .frame(height: 48)
                                .padding(.leading, 24)
                                .background(Background.first)
                        }
                    }
                }
                Spacer()
            }
        }
        .navigationBarBackButtonHidden()
        .alert("답변을 신고하시겠어요?", isPresented: $isReportAlertPresented) {
            Button("취소", role: .cancel) {}
            Button("신고하기", role: .destructive) {
                Task {
                    await requestReportAnswer()
                    isReportCompleteAlertPresented.toggle()
                    sendUpdateViewNotification()
                }
            }
        }
        .alert("신고가 완료됐어요", isPresented: $isReportCompleteAlertPresented) {
            Button("확인", role: .none) {
                pathModel.paths.removeLast()
            }
        } message: {
            Text("신고한 답변은 블라인드 처리 되며, 관리자 검토 후 조치 될 예정이에요.")
        }
    }
}

extension ReportView {
    
    /// 해당 답변을 신고합니다.
    @MainActor
    func requestReportAnswer() async {
        do {
            print("답변ID: \(answerId)\n신고타입: \(reportType)")
            let _ = try await NetworkManager.requestReport(
                request: .init(
                    answerId: answerId,
                    reportType: reportType.rawValue
                )
            )
        } catch {
            print("신고하기 실패")
        }
    }
    
    /// View 업데이트 Notification을 전송합니다.
    func sendUpdateViewNotification() {
        NotificationCenter.default.post(
            name: .updateViewNotification,
            object: nil
        )
    }
}

#Preview {
    ReportView(answerId: 1)
}
