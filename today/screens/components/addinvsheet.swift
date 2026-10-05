//
//  addinvsheet.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

struct AddInvSheet: View
{
    let actIcons: [String] = ["figure.walk", "dumbbell", "figure.badminton"];
    let mealIcons: [String] = ["frying.pan", "fork.knife", "takeoutbag.and.cup.and.straw", "cup.and.saucer.fill", "birthday.cake", "waterbottle"];
    
    @Environment(\.dismiss)
    private var dismiss;
    
    @State
    private var title: String = "";
    
    @State
    private var cals: Int32 = 500;
    
    private var iconlist: [String]
    {
        pViewType == .meals ? mealIcons : actIcons
    }
    
    @State
    private var selectedIcon: String = "";
    
    let pViewType: ViewType;
    let pSubmit: (_ pTitle: String, _ pCals: Int32, _ pIcon: String) -> Void;
    
    var body: some View
    {
        NavigationStack
        {
            VStack
            {
                HStack
                {
                    ForEach (iconlist, id: \.self)
                    {icon in
                        
                        Button ("meal", systemImage: icon)
                        {
                            selectedIcon = icon;
                        }
                        .labelStyle(.iconOnly)
                        .buttonStyle(.glass)
                        .tint(selectedIcon == icon ? .blue: nil)
                    }
                }
                .frame(maxWidth: .infinity)
                .onAppear
                {
                    selectedIcon = iconlist.first!
                }
                
                TextField ("Name", text: $title)
                    .textFieldStyle(.roundedBorder)
                
                HStack
                {
                    TextField ("Calories", value: $cals, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                    Text ("kcal")
                }
            }
            .padding(24)
            .navigationTitle ("Add new \(pViewType)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem (placement: .cancellationAction) {
                    Button ("Cancel") { dismiss () }
                }
                
                ToolbarItem (placement: .confirmationAction) {
                    Button ("Done")
                    {
                        pSubmit (title, cals, selectedIcon);
                        dismiss ()
                    }
                    .tint(.blue)
                }
            }
        }
    }
}
