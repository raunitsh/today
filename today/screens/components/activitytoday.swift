//
//  activitytoday.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

struct ActivityToday: View
{
    let activities: [ListItemContent] = [
        ListItemContent (title: "Walk, 10 km", footnote: "+460 kcal"),
        ListItemContent (title: "Badminton", footnote: "+120 kcal"),
    ];
 
    var body: some View
    {
        ListWithTitle (contents: activities, title: "Activity")
    }
}
