//
//  ContentView.swift
//  LoginApp
//
//  Created by Petar  on 8.2.25..
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - Properties
    @StateObject private var loginVM = LoginViewModel(service: NetworkServiceFactory.create())
    @State private var message: String = ""
    
    //MARK: - Body
    var body: some View {
        let _ = Self._printChanges() //Printing state changes!
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                HStack() {
                    Spacer()
                    Text("Login")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                } //: HStack
                
                TextField("User name", text: $loginVM.username)
                    .modifier(TextFieldModifier())
                    .accessibilityIdentifier("usernameTextField")
                
                TextField("Password", text: $loginVM.password)
                    .modifier(TextFieldModifier())
                    .accessibilityIdentifier("passwordTextField")
                
                HStack {
                    Spacer()
                    Button {
                        Task {
                            await loginVM.login()
                        }
                    } label: {
                        Group {
                            if !loginVM.isLoading {
                                Text("Login")
                                    .frame(width: 150, height: 50)
                                    .foregroundColor(.orange)
                            } else {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .frame(width: 150, height: 50)
                                    .tint(.orange)
                            }
                        }
                        .accessibilityIdentifier("loginButton")
                    } //: Button
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.white)
                    )
                    .disabled(loginVM.isLoading)
                    Spacer()
                } //: HStack
                
                HStack {
                    Spacer()
                    Text(loginVM.errorMessage)
                        .accessibilityIdentifier("messageText")
                    Spacer()
                } //: HStack
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Hints")
                    Text("Usrname: JohnDoe")
                    Text("Password: Password")
                } //: VStack
                .padding(.horizontal, 30)
                
            } //: VStack
            .navigationDestination(isPresented: .constant(loginVM.loginStatus == .authenticated)) {
                HomeView()
            } //: navigationDestination
            .padding(.bottom, 100)
        } //: NavigationStack
        .accentColor(.white)
    }
    
}

//MARK: - Preview
#Preview {
    ContentView()
}
