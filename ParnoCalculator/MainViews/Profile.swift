//
//  Profile.swift
//  ParnoCalculator
//
//  Created by Ivan Jovanovik on 12/10/2023.
//

import SwiftUI

struct Profile: View {
    @Binding var presentSideMenu: Bool
    
    var body: some View {
        VStack{
            HStack{
                Button{
                    presentSideMenu.toggle()
                } label: {
                    Image("menu")
                        .resizable()
                        .frame(width: 32, height: 32)
                }
                Spacer()
            }
            
            Spacer()
            Text("Profile View")
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile(presentSideMenu: .constant(false))
    }
}
