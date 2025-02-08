//
//  ContentView.swift
//  LoginApp
//
//  Created by Petar  on 8.2.25..
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - Properties
    @StateObject private var loginVM = LoginViewModel(service: Webservice())
    @State private var message: String = ""
    
    //MARK: - Body
    var body: some View {
        let _ = Self._printChanges()
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                
                HStack() {
                    Spacer()
                    Text("Login")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                
                TextField("User name", text: $loginVM.username)
                    .modifier(TextFieldModifier())
                    .accessibilityIdentifier("usernameTextField")
                
                TextField("Password", text: $loginVM.password)
                    .modifier(TextFieldModifier())
                    .accessibilityIdentifier("passwordTextField")
                
                HStack {
                    Spacer()
                    Button {
                        loginVM.login()
                    } label: {
                        Text("Login")
                            .foregroundColor(.orange)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(.white)
                            )
                            .accessibilityIdentifier("loginButton")
                    }
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    Text(loginVM.errorMessage)
                        .accessibilityIdentifier("messageText")
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Hints")
                    Text("Usrname: JohnDoe")
                    Text("Password: Password")
                }
                .padding(.horizontal, 30)
                
            }
            .navigationDestination(isPresented: .constant(loginVM.loginStatus == .authenticated)) {
                HomeView()
            }
            .padding(.bottom, 100)
        }
        .accentColor(.white)
    }
    
}

//MARK: - Preview
#Preview {
    ContentView()
}
