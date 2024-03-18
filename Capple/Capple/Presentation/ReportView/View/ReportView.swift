//
//  ReportView.swift
//  Capple
//
//  Created by 김민준 on 3/2/24.
//

import SwiftUI

struct ReportView: View {
    
    @EnvironmentObject var pathModel: PathModel
    
    var moreList = [
        "불법촬영물 등의 유통", "상업적 광고 및 판매",
        "게시판 성격에 부적절함", "욕설/비하", "정당/정치인 비하 및 선거운동",
        "유출/사칭/사기", "낚시/놀림/도배"
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
                
                List(moreList, id: \.self) { more in
                    Button {
                        // TODO: 신고하기 이동
                    } label: {
                        ReportListRow(title: more)
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                .listStyle(.plain)
                .navigationBarBackButtonHidden()
            }
        }
    }
}

#Preview {
    ReportView()
}
