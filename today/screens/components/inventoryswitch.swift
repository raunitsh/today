//
//  inventoryswitch.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

struct InvSwitchView: View
{
    @Binding
    var pViewType: ViewType;

    @Binding
    var meals: [ListItemContent];
    
    @Binding
    var activities: [ListItemContent];
    
    var body: some View
    {
        VStack
        {
            Picker("Select category", selection: $pViewType) {
                ForEach(ViewType.allCases) { type in
                    Text("\(type.rawValue)").tag(type)
                }
            }
            .pickerStyle(.segmented)
            
            switch pViewType {
            case .meals:
                MealsInv (meals: $meals)
                
            case .exercises:
                ExercisesInv (activities: $activities)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: pViewType)
        .debug()
    }
}
