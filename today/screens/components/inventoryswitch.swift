//
//  inventoryswitch.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

enum ViewType: String, CaseIterable, Identifiable
{
    case meals = "Meals";
    case exercises = "Exercises";
    
    var id: String {rawValue}
}

struct InvSwitchView: View
{
    @State
    private var viewType: ViewType = .meals
    
    var body: some View
    {
        VStack
        {
            Picker("Select category", selection: $viewType) {
                ForEach(ViewType.allCases) { type in
                    Text("\(type.rawValue)").tag(type)
                }
            }
            .pickerStyle(.segmented)
            
            switch viewType {
            case .meals:
                MealsInv ()
                
            case .exercises:
                ExercisesInv ()
            }
        }
        .debug()
    }
}
