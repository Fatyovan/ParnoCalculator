//
//  RoomListView.swift
//  ParnoCalculator
//
//  Created by Ivan Jovanovik on 10.10.24.
//

import SwiftUI

struct RoomsListView: View {
    @ObservedObject var house: HouseEntity
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var roomManager: RoomManager
    @State private var newRoomName: String = ""
    @State private var isAddRoomPresented: Bool = false
    
    init(house: HouseEntity) {
        self.house = house
        self._roomManager = StateObject(wrappedValue: RoomManager(context: CoreDataStack.shared.persistentContainer.viewContext))
    }
    
    var body: some View {
        List {
            ForEach(roomManager.rooms.sorted(by: { $0.roomDateCreated > $1.roomDateCreated }), id: \.self) { room in
                NavigationLink(destination: RoomDetails(room: room)) {
                    roomRow(room: room)
                }
            }
        }
        .navigationTitle(house.houseName ?? "House")
        .navigationBarItems(trailing: Button(action: {
            isAddRoomPresented = true
        }) {
            Image(systemName: "plus")
        })
        .onAppear {
            roomManager.fetchRooms(for: house)
        }
        .sheet(isPresented: $isAddRoomPresented) {
            VStack {
                TextField("Room Name", text: $newRoomName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Add Room") {
                    roomManager.createRoom(roomName: newRoomName, house: house)
                    newRoomName = "" // Reset the text field
                    isAddRoomPresented = false // Dismiss the modal
                }
                .padding()
            }
            .padding()
        }
    }
    
    private func roomRow(room: RoomEntity) -> some View {
        HStack {
            Text(room.roomName ?? "Unknown Room")
                .font(.headline) // Optional: Set font style

            Spacer()

            Text("Power: \(String(format: "%.2f", room.roomPower))")
                .foregroundColor(.gray)
                .font(.subheadline) // Optional: Set font style
        }
        .padding() // Optional: Add some padding for better spacing
    }
}


