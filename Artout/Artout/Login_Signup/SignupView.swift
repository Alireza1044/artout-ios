//
//  SignupView.swift
//  Artout
//
//  Created by Pooya Kabiri on 10/26/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import SwiftUI

struct SignupView: View {
//    @ObservedObject var viewModel : SignupViewModel
    var body: some View {
        VStack{
            Text("Sign Up")
                .padding(.bottom)
            
            TextField("Full Name", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                .padding(.bottom)
                .multilineTextAlignment(.center)
            
            TextField("Email", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                .padding(.bottom)
                .multilineTextAlignment(.center)
            
            TextField("Phone Number", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                .padding(.bottom)
                .multilineTextAlignment(.center)
            
            TextField("Password", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                .padding(.bottom)
                .multilineTextAlignment(.center)
            
            Button(action: {}) {
                Text("Sign Up")
            }.padding(.bottom)
        }
        
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
