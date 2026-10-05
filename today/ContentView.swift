//
//  ContentView.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

struct ContentView: View
{
    @Bindable
    var v = TodayViewModel.shared;
    
    var body: some View
    {
        TabView (selection: $v.activeTab)
        {
            NavigationStack
            { SummaryScreen () }.tabItem
            { Label ("Today", systemImage: "flame") }
                .tag(eTab.TODAY)
            
            NavigationStack
            { InventoryScreen () }.tabItem
            { Label ("Inventory", systemImage: "square.grid.2x2") }
                .tag(eTab.INVENTORY)
            
            NavigationStack
            { ProgressScreen () }.tabItem
            { Label ("Progress", systemImage: "chart.bar") }
                .tag(eTab.PROGRESS)
        }
        .task
        {
            InitBackend ();
        }
    }
    
    private func InitBackend () -> Void
    {
        let filemanager = FileManager.default;
        if let docsUrl = filemanager.urls(for: .documentDirectory, in: .userDomainMask).first
        {
            Task
            {
                if await !Backend.shared.Init (docsUrl)
                {
                    print ("Backend init failed");
                }
                
                UserViewModel.shared.Init ();
                TodayViewModel.shared.Init ();
                InventoryViewModel.shared.Init ();
            }
        }
    }
}

#Preview {
    ContentView()
}
