//
//  addinvsheet.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

struct AddInvSheet: View
{
    let actIcons: [String] = ["🚶", "💪", "🏸", "🏋"];
    let mealIcons: [String] = ["🌯", "🍝", "🧆", "🥞", "🥘", "🧋", "🥪", "🍬", "🍫", "🧃", "🫓", "🍽️", "🍦"];
    
    @Environment(\.dismiss)
    private var dismiss;
    
    @State
    private var title: String = "";
    
    @State
    private var cals: Int32 = 500;
    
    @State
    private var protein: Int32 = 24;
    
    private var iconlist: [String]
    {
        pViewType == .meals ? mealIcons : actIcons
    }
    
    @State
    private var selectedIcon: String = "";
    
    let pViewType: ViewType;
    let pSubmit: (_ pTitle: String, _ pCals: Int32, _ pProtein: Int32, _ pIcon: String) -> Void;
    
    var body: some View
    {
        NavigationStack
        {
            VStack
            {
                ScrollView (.horizontal)
                {
                    HStack
                    {
                        ForEach (iconlist, id: \.self)
                        {icon in
                            
                            Button
                            {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedIcon = icon
                                }
                            }
                            label: {
                                Text(icon)
                                    .font(.system(size: 26))
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Circle()
                                            .stroke(selectedIcon == icon ? Color.blue : Color.clear, lineWidth: 2)
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(2)
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
                    HStack
                    {
                        TextField ("Calories", value: $cals, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                        Text ("kcal")
                    }
                    
                    if (pViewType == .meals)
                    {
                        Spacer ()
                        
                        HStack
                        {
                            TextField ("Protein", value: $protein, format: .number)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.numberPad)
                            Text ("gm")
                        }
                    }
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
                        pSubmit (title, cals, protein, selectedIcon);
                        dismiss ()
                    }
                    .tint(.blue)
                }
            }
        }
    }
}
