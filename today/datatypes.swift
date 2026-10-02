//
//  datatypes.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

struct ListItem: View
{
    let pTitle: String;
    let pCals: Int32;
    
    let pAction: () -> Void;
    
    var body: some View
    {
        HStack
        {
            Image (systemName: "frying.pan")
            
            VStack (alignment: .leading)
            {
                Text (pTitle).font(.body)
                Text ("\(pCals) kcal").font(.footnote)
            }
            .debug()
            
            Spacer()
            
            Button ("delete", systemImage: "xmark", action: pAction)
                .labelStyle(.iconOnly)
                .tint(.gray)
        }
        .listRowInsets(EdgeInsets())
        .frame(maxWidth: .infinity)
        .debug()
    }
}

struct ListItemContent
{
    let id = UUID ();
    let title: String;
    let cals: Int32;
}

enum ViewType: String, CaseIterable, Identifiable
{
    case meals = "Meals";
    case exercises = "Exercises";
    
    var id: String {rawValue}
}
