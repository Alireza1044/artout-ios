//
//  ContentView.swift
//  Artout
//
//  Created by Pooya Kabiri on 10/26/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//
import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: LoginViewModel
    @State private var password: String = ""
    @State private var email: String = ""
    @State var isAlertShown: Bool = false
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
            VStack {
                Text("Artout")
                    .padding(.bottom)
                
                TextField("Email", text: $email)
                    .padding(.bottom)
                    .border(Color.black)
                    .multilineTextAlignment(.center)
                
                TextField("Password", text: $password)
                    .padding(.bottom)
                    .border(Color.black)
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    self.viewModel.Login(With: self.email, And: self.password)
                    self.isAlertShown.toggle()
                }) {
                    Text("Login")
                }.padding(.bottom)
                 .alert(isPresented: self.$isAlertShown) {
                    Alert(title: Text(self.viewModel.LoginMessage))
                 }
                
                NavigationLink(destination: SignupView()) {
                    Text("Sign Up")
                }.disabled(false).padding(.bottom)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: LoginViewModel(service: TokenService()))
    }
    
}

