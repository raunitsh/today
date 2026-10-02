//
//  exercisesinv.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

struct ExercisesInv: View
{
    @Binding
    var activities: [ListItemContent];
    
    var body: some View
    {
        ListWithTitle (contents: activities, title: "\(activities.count) activities")
        {id in
            activities.removeAll {$0.id == id}
        }
    }
}
