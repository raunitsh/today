//
//  inventory.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

struct InventoryScreen: View
{
    @Bindable
    var vm = InventoryViewModel.shared;
    
    @State
    var showSheet: Bool = false;
    
    var body: some View
    {
        NavigationStack
        {
            ScrollView
            {
                VStack (alignment: .leading)
                {
                    InvSwitchView (pViewType: $vm.viewType, meals: $vm.meals, activities: $vm.activities)
                }
                
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.all)
            }
        }
        .navigationTitle("Inventory")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing)
            {
                Button ("add", systemImage: "plus")
                {
                    showSheet = true;
                }
                .labelStyle(.iconOnly)
                .tint(.blue)
                .sheet (isPresented: $showSheet, onDismiss: onDismiss)
                {
                    AddInvSheet (pViewType: vm.viewType, pSubmit: vm.addItem)
                        .presentationDetents([.fraction(0.25), .medium])
                        .presentationDragIndicator(.visible)
                }
            }
        }
    }
    
    private func onDismiss () -> Void
    {
        showSheet = false;
    }
}
