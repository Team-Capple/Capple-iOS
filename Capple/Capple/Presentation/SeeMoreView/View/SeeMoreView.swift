//
//  SeeMoreView.swift
//  Capple
//
//  Created by 김민준 on 2/28/24.
//

import SwiftUI

struct SeeMoreView: View {
    
    @EnvironmentObject var pathModel: PathModel
    @Binding var isBottomSheetPresented: Bool
    
    var body: some View {
        ZStack {
            
            Color(Background.first)
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Spacer().frame(height: 12)
                
                HStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 3)
                        .frame(width: 56, height: 4)
                        .foregroundStyle(GrayScale.secondaryButton)
                    Spacer()
                }
                
                Button {
                    isBottomSheetPresented = false
                    pathModel.paths.append(.report)
                } label: {
                    Text("신고하기")
                        .font(.pretendard(.medium, size: 16))
                        .foregroundStyle(Context.warning)
                }
                .frame(height: 40)
                .padding(.horizontal, 24)
                
                Spacer()
            }
        }
    }
}

#Preview {
    SeeMoreView(isBottomSheetPresented: .constant(false))
}
