//
//  inventory.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

struct InvHeader: View
{
    @State
    var showSheet: Bool = false;
    var pViewType: ViewType;
    
    let pAddNewItem: (_ pTitle: String, _ pCals: Int32) -> Void;
    
    var body: some View
    {
        HStack
        {
            Text ("Inventory").font(.largeTitle).bold()
            Spacer()
            Button ("add", systemImage: "plus")
            {
                showSheet = true;
            }
            .labelStyle(.iconOnly)
            .sheet (isPresented: $showSheet, onDismiss: onDismiss) {
                AddInvSheet (pViewType: pViewType, pSubmit: pAddNewItem)
                    .presentationDetents([.fraction(0.25), .medium])
                    .presentationDragIndicator(.visible)
            }
        }
        .frame(maxWidth: .infinity)
        .debug()
    }
    
    private func onDismiss () -> Void
    {
        showSheet = false;
    }
}

struct InventoryScreen: View
{
    @Bindable
    var vm = InventoryViewModel.shared;
    
    var body: some View
    {
        ScrollView
        {
            VStack (alignment: .leading)
            {
                InvHeader (pViewType: vm.viewType, pAddNewItem: vm.addItem(_:_:))
                InvSwitchView (pViewType: $vm.viewType, meals: $vm.meals, activities: $vm.activities)
            }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.all)
        }
    }
}
