//
//  AddWallView.swift
//  ParnoCalculator
//
//  Created by Ivan Jovanovik on 10.10.24.
//

import SwiftUI

struct WallData {
    let material: String
    let thickness: String
    let values: [String: Double] // Keys are "Puna cigla", "Beton", "Ytong", "Giter blok", "Podovi"
}

struct WindowsData {
    let typeOfGlass: String
    let value: Double
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct AddWallView: View {
    @ObservedObject var room: RoomEntity
    var wall: WallEntity?
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedWall: String = "North"
    @State private var selectedThermalInsulationMaterial: String = "Stiropor"
    @State private var selectedThickness: String = "5 cm"
    @State private var selectedMaterial: String = "Giter blok"
    
    @State private var coefficient: String? = nil
    
    @State private var wallHeight: String = ""
    @State private var wallWidth: String = ""
    @State private var wallArea: Float = 0.0
    
    @State private var hasWindow: Bool = false
    @State private var windowHeight: String = ""
    @State private var windowWidth: String = ""
    @State private var windowArea: Float = 0.0
    @State private var windowPower: Float = 0.0
    
    @State private var selectedWindowType: String = ""
    @State private var selectedWallType: Float = 40
    
    let wallOptions: [WallData] = [
        WallData(material: "Bez izolacije", thickness: "/", values: ["Puna cigla": 2.4, "Beton": 8, "Ytong": 0.32, "Giter blok": 1.9, "Podovi": 2.4]),
        WallData(material: "Stiropor", thickness: "5 cm", values: ["Puna cigla": 0.6, "Beton": 0.73, "Ytong": 0.23, "Giter blok": 0.56, "Podovi": 2.4]),
        WallData(material: "Stiropor", thickness: "8 cm", values: ["Puna cigla": 0.41, "Beton": 0.47, "Ytong": 0.19, "Giter blok": 0.4, "Podovi": 2.4]),
        WallData(material: "Stiropor", thickness: "10 cm", values: ["Puna cigla": 0.34, "Beton": 0.38, "Ytong": 0.18, "Giter blok": 0.33, "Podovi": 0.34]),
        WallData(material: "Stiropor", thickness: "12 cm", values: ["Puna cigla": 0.29, "Beton": 0.32, "Ytong": 0.16, "Giter blok": 0.28, "Podovi": 0.29]),
        WallData(material: "Stiropor", thickness: "15 cm", values: ["Puna cigla": 0.24, "Beton": 0.26, "Ytong": 0.15, "Giter blok": 0.24, "Podovi": 0.24]),
        
        // Trska rows
        WallData(material: "Trska", thickness: "5 cm", values: ["Puna cigla": 0.71, "Beton": 0.89, "Ytong": 0.24, "Giter blok": 0.66, "Podovi": 0.71]),
        WallData(material: "Trska", thickness: "10 cm", values: ["Puna cigla": 0.41, "Beton": 0.47, "Ytong": 0.19, "Giter blok": 0.4, "Podovi": 0.41]),
        
        // Mineralna vuna rows
        WallData(material: "Mineralna vuna", thickness: "5 cm", values: ["Puna cigla": 0.6, "Beton": 0.73, "Ytong": 0.23, "Giter blok": 0.56, "Podovi": 0.6]),
        WallData(material: "Mineralna vuna", thickness: "10 cm", values: ["Puna cigla": 0.34, "Beton": 0.38, "Ytong": 0.18, "Giter blok": 0.33, "Podovi": 0.34])
    ]
    
    let windowOptions: [WindowsData] = [
        WindowsData(typeOfGlass: "1 staklo", value: 5.3),
        WindowsData(typeOfGlass: "2 stakla", value: 2.8),
        WindowsData(typeOfGlass: "3 stakla", value: 2),
        WindowsData(typeOfGlass: "Metal - 1 staklo", value: 5.6),
        WindowsData(typeOfGlass: "Metal - 2 stakla", value: 3)
    ]
    
    let windowType = ["1 staklo", "2 stakla", "3 stakla", "Metal - 1 staklo", "Metal - 2 stakla"]
    let walls = ["Zid12", "Zid3", "Zid6", "Zid9", "Podovi", "Plafon"]
    let materials = ["Stiropor", "Trska", "Mineralna vuna", "Bez izolacije"]
    
    
    var thicknesses: [String] {
        switch selectedThermalInsulationMaterial {
        case "Stiropor":
            return ["5 cm", "8 cm", "10 cm", "12 cm", "15 cm"]
        case "Trska":
            return ["5 cm", "10 cm"]
        case "Mineralna vuna":
            return ["5 cm", "10 cm"]
        case "Bez izolacije":
            return ["/"]
        default:
            return ["/", "5 cm", "8 cm", "10 cm", "12 cm", "15 cm"]
        }
    }
    
    let columns = ["Puna cigla", "Beton", "Ytong", "Giter blok", "Podovi"]
    
    init(room: RoomEntity, wall: WallEntity? = nil) {
        self.room = room
        self.wall = wall
        
        if let wall = wall {
            _selectedWall = State(initialValue: wall.side ?? "North")
            _selectedWallType = State(initialValue: wall.deltaT)
            _wallHeight = State(initialValue: String(wall.wallHeight))
            _wallWidth = State(initialValue: String(wall.wallWidth))
            _hasWindow = State(initialValue: wall.hasWindows)
            _windowHeight = State(initialValue: String(wall.windowHeight))
            _windowWidth = State(initialValue: String(wall.windowWidth))
            _selectedThermalInsulationMaterial = State(initialValue: wall.thermalInsulationMaterial ?? "Stiropor")
            _selectedThickness = State(initialValue: wall.materialThickness ?? "5 cm")
            _selectedMaterial = State(initialValue: wall.material ?? "Giter blok")
            _coefficient = State(initialValue: wall.coefficient)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Wall Selection")) {
                        Picker("Wall", selection: $selectedWall) {
                            ForEach(walls, id: \.self) { wall in
                                Text(wall).tag(wall)
                            }
                        }
                    }
                    
                    Section(header: Text("Wall Type")) {
                        HStack {
                            RadioButton(
                                label: "Outside",
                                isSelected: selectedWallType == 40,
                                action: { selectedWallType = 40 }
                            )
                            Spacer()
                            RadioButton(
                                label: "Inside",
                                isSelected: selectedWallType == 10,
                                action: { selectedWallType = 10 }
                            )
                        }
                    }
                    
                    // Wall Area
                    Section(header: Text("Wall Area")) {
                            TextFieldWithDoneButton(placeholder: "Wall Height (m)", text: $wallHeight, keyboardType: .decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            TextFieldWithDoneButton(placeholder: "Wall Width (m)", text: $wallWidth, keyboardType: .decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    // Checkbox for Windows
                    Section {
                        Toggle(isOn: $hasWindow) {
                            Text("Has Window")
                        }
                        
                        if hasWindow {
                            // Window Area
                                TextFieldWithDoneButton(placeholder: "Window Height (m)", text: $windowHeight, keyboardType: .decimalPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                TextFieldWithDoneButton(placeholder: "Window Width (m)", text: $windowWidth, keyboardType: .decimalPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                Picker("Window Type", selection: $selectedWindowType) {
                                    ForEach(windowType, id: \.self) { glassType in
                                        Text(glassType).tag(glassType)
                                    }
                                }
                            
                        }
                    }
                    
                    Section(header: Text("Thermal Insulation")) {
                        Picker("Material", selection: $selectedThermalInsulationMaterial) {
                            ForEach(materials, id: \.self) { material in
                                Text(material).tag(material)
                            }
                        }
                    }
                    
                    Section(header: Text("Thickness")) {
                        Picker("Thickness", selection: $selectedThickness) {
                            ForEach(thicknesses, id: \.self) { thickness in
                                Text(thickness).tag(thickness)
                            }
                        }
                    }
                    
                    Section(header: Text("Wall Material")) {
                        Picker("Material", selection: $selectedMaterial) {
                            ForEach(columns, id: \.self) { column in
                                Text(column).tag(column)
                            }
                        }
                    }
                }
               
                // Calculate and Save Buttons
                HStack {
                    Button(action: {
                        calculateResult()
                    }) {
                        Text("Calculate")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        saveWall()
                    }) {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
                
                if let result = coefficient {
                    Text("Result: \(result)")
                        .font(.largeTitle)
                        .padding()
                }
            }
            .navigationTitle("Add Wall")
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    func calculateResult() {
//        if let matchingData = wallOptions.first(where: { $0.material == selectedThermalInsulationMaterial && $0.thickness == selectedThickness }) {
//            coefficient = String(format: "%.2f", matchingData.values[selectedMaterial] ?? 0.0)
//        }
    }
    
    func saveWall() {
        if let matchingData = wallOptions.first(where: { $0.material == selectedThermalInsulationMaterial && $0.thickness == selectedThickness }) {
            coefficient = String(format: "%.2f", matchingData.values[selectedMaterial] ?? 0.0)
        }
        let newWall = WallEntity(context: viewContext)
        newWall.side = selectedWall
        newWall.deltaT = selectedWallType
        newWall.materialThickness = selectedThickness
        newWall.material = selectedMaterial
        newWall.thermalInsulationMaterial = selectedThermalInsulationMaterial
        newWall.coefficient = coefficient
        
        
        // Save wall area
        if let height = Float(wallHeight.replacingOccurrences(of: ",", with: ".")),
           let width = Float(wallWidth.replacingOccurrences(of: ",", with: ".")) {
            newWall.wallHeight = height
            newWall.wallWidth = width
            wallArea = height * width
        }
        
        // Save window area if applicable
        if hasWindow, let winHeight = Float(windowHeight.replacingOccurrences(of: ",", with: ".")),
           let winWidth = Float(windowWidth.replacingOccurrences(of: ",", with: ".")) {
            newWall.windowHeight = winHeight
            newWall.windowWidth = winWidth
            newWall.hasWindows = hasWindow
            
            windowArea = winHeight * winWidth
            wallArea = wallArea - windowArea
            
            if let matchingDataWindow = windowOptions.first(where: { $0.typeOfGlass == selectedWindowType}) {
                print("Selected Window Type: \(selectedWindowType)")
                   print("Matching Data Window: \(matchingDataWindow)")
                windowPower = windowArea * 40 * Float(matchingDataWindow.value)
            }
        }
    
        if let coefficient = coefficient, let coefficientFloat = Float(coefficient.replacingOccurrences(of: ",", with: ".")) {
            newWall.power = (wallArea * selectedWallType * coefficientFloat) + windowPower
        }
        
        newWall.wallDateCreated = Date().timeIntervalSince1970
                
        // Link this wall to the room
        room.addToWalls(newWall)
        
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Failed to save wall: \(error)")
        }
    }
}
struct RadioButton: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(isSelected ? .blue : .gray)
                Text(label)
            }
            .padding()
        }
        .buttonStyle(PlainButtonStyle()) // To prevent button from showing default style
    }
}


// This struct represents the custom TextField with a toolbar
struct TextFieldWithDoneButton: UIViewRepresentable {
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: TextFieldWithDoneButton
        weak var textField: UITextField?

        init(parent: TextFieldWithDoneButton) {
            self.parent = parent
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder() // Dismiss keyboard when "Done" is pressed
            return true
        }

        @objc func doneButtonTapped() {
            textField?.resignFirstResponder() // Dismiss the keyboard when the "Done" button is pressed
        }
        
        @objc func textDidChange(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }

    var placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.keyboardType = keyboardType
        textField.delegate = context.coordinator
        
        // Store a reference to the textField in the coordinator
        context.coordinator.textField = textField

        // Create toolbar with "Done" button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: context.coordinator, action: #selector(Coordinator.doneButtonTapped))
        toolbar.setItems([doneButton], animated: true)
        
        // Attach toolbar to keyboard
        textField.inputAccessoryView = toolbar
        
        // Observe changes in text field to update the binding
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textDidChange(_:)), for: .editingChanged)

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        // Make sure to update the text field's text only if the current text is different
        if uiView.text != text {
            uiView.text = text
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func dismissKeyboard() {
        // Call dismissKeyboard from the coordinator
        if let coordinator = makeCoordinator() as? Coordinator {
            coordinator.textField?.resignFirstResponder()
        }
    }
}

