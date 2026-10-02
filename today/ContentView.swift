//
//  ContentView.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

struct ContentView: View
{
    var body: some View
    {
        TabView
        {
            NavigationStack
            { SummaryScreen () }
                .tabItem { Label ("Today", systemImage: "house") }
            
            NavigationStack
            { InventoryScreen () }.tabItem
            { Label ("Inventory", systemImage: "house") }
            
            NavigationStack
            { SummaryScreen () }.tabItem
            { Label ("Progress", systemImage: "house") }
        }
    }
}

#Preview {
    ContentView()
}
