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
            List {
                ForEach(houseManager.houses.sorted(by: { $0.dateCreated > $1.dateCreated }), id: \.self) { house in
                    NavigationLink(destination: RoomsListView(house: house)) {
                        Text(house.houseName ?? "Unknown House")
                    }
                }
                .onDelete(perform: deleteHouse)
            }
            .navigationTitle("Houses")
            .navigationBarItems(leading: Button(action: {
                presentSideMenu.toggle() // Toggle the side menu
            }) {
                Image("menu")
                    .resizable()
                    .frame(width: 32, height: 32)
            }, trailing: Button(action: {
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
                        if let currentUser = userViewModel.currentUser {
                            houseManager.createHouse(houseName: newHouseName, owner: currentUser)
                            newHouseName = ""
                            isAddHousePresented = false
                        }
                    }
                    .padding()
                }
                .padding()
            }
        }
    }
    
    private func deleteHouse(at offsets: IndexSet) {
        offsets.forEach { index in
            let house = houseManager.houses[index]
            houseManager.deleteHouse(house: house)
        }
    }
}
