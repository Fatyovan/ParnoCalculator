//
//  MainCalculationView.swift
//  ParnoCalculator
//
//  Created by Ivan Jovanovik on 12/10/2023.
//

import SwiftUI

struct MainCalculationView: View {
    @State var presentSideMenu = false
    @State var selectedSideMenuTab = 0
    @EnvironmentObject var userViewModel: UserViewModel
    var body: some View {
        ZStack{
            
            TabView(selection: $selectedSideMenuTab) {
                Home(presentSideMenu: $presentSideMenu).tag(0)
                Houses(presentSideMenu: $presentSideMenu).tag(1)
                Profile(presentSideMenu: $presentSideMenu).tag(2)
            }
            
            SideMenu(isShowing: $presentSideMenu, content: AnyView(SideMenuView(selectedSideMenuTab: $selectedSideMenuTab, presentSideMenu: $presentSideMenu).environmentObject(userViewModel)))
        }
    }
}

struct MainCalculationView_Previews: PreviewProvider {
    static var previews: some View {
        MainCalculationView()
    }
}
