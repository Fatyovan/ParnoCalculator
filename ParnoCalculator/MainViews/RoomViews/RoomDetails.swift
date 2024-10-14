//
//  RoomDetails.swift
//  ParnoCalculator
//
//  Created by Ivan Jovanovik on 10.10.24.
//

import SwiftUI
import CoreData

struct RoomDetails: View {
    @ObservedObject var room: RoomEntity
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var wallManager: WallManager
    @State private var selectedWall: WallEntity?
    @State private var isAddWallPresented = false
    
    init(room: RoomEntity) {
        self.room = room
        self._wallManager = StateObject(wrappedValue: WallManager(context: CoreDataStack.shared.persistentContainer.viewContext))
    }
    
    var body: some View {
        VStack {
            
            if !wallManager.walls.isEmpty {
                List {
                    ForEach(wallManager.walls.sorted(by: {$0.wallDateCreated > $1.wallDateCreated }), id: \.self) { wall in
                        HStack {
                            Text(wall.side ?? "Unnamed Wall")
                            Spacer()
                            Text("Power: \(String(wall.power))")
                                .foregroundColor(.gray)
                        }.onTapGesture {
                            selectedWall = wall
                            isAddWallPresented.toggle()
                        }
                    }
                    .onDelete(perform: deleteWall)
                }
                .listStyle(PlainListStyle())
            } else {
                Text("No walls created for this room.")
                    .foregroundColor(.gray)
                    .padding()
            }
            
            HStack {
                Button(action: {
                    calculateRoomPower()
                }) {
                    Text("Calculate Room Power")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .onAppear {
            wallManager.fetchWalls(for: room)
        }
        .navigationTitle(room.roomName ?? "Room")
        .navigationBarItems(trailing: Button(action: {
            isAddWallPresented.toggle()
        }) {
            Image(systemName: "plus")
                .font(.title)
        })
        .sheet(isPresented: $isAddWallPresented) {
            AddWallView(room: room, wall: selectedWall)
        }
    }
    
    private func deleteWall(at offsets: IndexSet) {
        offsets.forEach { index in
            let wall = wallManager.walls[index]
            wallManager.deleteWall(wall: wall)
        }
    }
    
    private func calculateRoomPower() {
        guard let wallsArray = room.walls as? Set<WallEntity> else {
            return
        }

        // Calculate the total power from all walls
        let totalPower = wallsArray.reduce(0) { (currentTotal, wall) -> Float in
            currentTotal + (wall.power ?? 0.0) // Use 0.0 if wall.power is nil
        }

        // Assign the total power to the room's power property
        room.roomPower = totalPower

        // Save the changes to the view context
        do {
            try viewContext.save() // Ensure your viewContext is correctly referenced
        } catch {
            print("Failed to save room power: \(error)")
        }
    }
}
