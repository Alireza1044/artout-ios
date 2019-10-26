//
//  ContentView.swift
//  Artout
//
//  Created by Pooya Kabiri on 10/26/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    
    var body: some View {
            VStack {
                Text("Artout")
                    .padding(.bottom)
                
                TextField("Email", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                    .padding(.bottom)
                    .border(Color.black)
                    .multilineTextAlignment(.center)
                
                TextField("Password", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                    .padding(.bottom)
                    .border(Color.black)
                    .multilineTextAlignment(.center)
                
                Button(action: {}) {
                    Text("Login")
                }.padding(.bottom)
                
                NavigationLink(destination: SignupView()) {
                    Text("Sign Up")
                }.disabled(false).padding(.bottom)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
