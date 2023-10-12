//
//  Houses.swift
//  ParnoCalculator
//
//  Created by Ivan Jovanovik on 12/10/2023.
//

import SwiftUI

struct Houses: View {
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
            Text("Houses View")
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

struct Houses_Previews: PreviewProvider {
    static var previews: some View {
        Houses(presentSideMenu: .constant(false))
    }
}
