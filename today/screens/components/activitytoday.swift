//
//  activitytoday.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

struct ActivityToday: View
{
    @Bindable
    var v = TodayViewModel.shared;
 
    var body: some View
    {
        ListWithTitle (contents: v.actToday, title: "Activity")
        {id in
            v.actToday.removeAll { $0.id == id }
        }
    }
}
