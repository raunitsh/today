//
//  addinvsheet.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

struct AddInvSheet: View
{
    @Environment(\.dismiss)
    private var dismiss;
    
    @State
    private var title: String = "";
    
    @State
    private var cals: Int = 500;
    
    let pViewType: ViewType;
    let pSubmit: (_ pTitle: String, _ pCals: Int) -> Void;
    
    var body: some View
    {
        NavigationStack
        {
            VStack
            {
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
                        pSubmit (title, cals);
                        dismiss ()
                    }
                    .tint(.blue)
                }
            }
        }
    }
}
