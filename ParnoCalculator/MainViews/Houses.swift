//
//  Houses.swift
//  ParnoCalculator
//
//  Created by Ivan Jovanovik on 12/10/2023.
//

import SwiftUI

struct Houses: View {
    @Binding var presentSideMenu: Bool
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject private var houseManager: HouseManager
    @State private var newHouseName: String = ""
    @State private var isAddHousePresented: Bool = false
    
    init(presentSideMenu: Binding<Bool>) {
        self._presentSideMenu = presentSideMenu
        self._houseManager = StateObject(wrappedValue: HouseManager(context: CoreDataStack.shared.persistentContainer.viewContext))
    }
    
    var body: some View {
        NavigationView {
           
            List(houseManager.houses, id: \.self) { house in
                Text(house.houseName ?? "Unknown House")
            }
            .navigationTitle("Houses")
            .navigationBarItems(leading: Button(action: {
                presentSideMenu.toggle()
            }) {
                Image("menu")
                    .resizable()
                    .frame(width: 32, height: 32)
            },
            
            trailing: Button(action: {
                isAddHousePresented = true
            }) {
                Image(systemName: "plus")
            })
            .onAppear {
                if let userId = userViewModel.currentUser?.userId {
                    houseManager.fetchAllHouses(for: userId)
                }
                
            }
            .sheet(isPresented: $isAddHousePresented) {
                VStack {
                    TextField("House Name", text: $newHouseName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button("Add House") {
                        if let user = userViewModel.currentUser {
                            houseManager.createHouse(houseName: newHouseName, owner: user)
                        }
                        newHouseName = "" // Reset the text field
                        isAddHousePresented = false // Dismiss the modal
                    }
                    .padding()
                }
                .padding()
            }
        }
    }
}
