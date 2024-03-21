//
//  AppleLoginButton.swift
//  Capple
//
//  Created by kyungsoolee on 3/9/24.
//

import SwiftUI
import AuthenticationServices

struct AppleLoginButton: View {
    
    @EnvironmentObject var pathModel: PathModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        HStack {
            Image(.appleIDLoginButton)
        }
        .overlay {
            SignInWithAppleButton(
                onRequest: { request in
                    Task {
                        authViewModel.isSignInLoading = true
                        await authViewModel.appleLogin(request: request)
                    }
                },
                onCompletion: { result in
                    Task {
                        await authViewModel.appleLoginCompletion(result: result)
                    }
                }
            )
        }
    }
}

#Preview {
    AppleLoginButton()
}
