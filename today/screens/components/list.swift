//
//  list.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

struct ListWithTitle: View
{
    let contents: [ListItemContent];
    let title: String;
    let pOnDelete: (_ pItem: ListItemContent) -> Void;
    let rightVal: Int32;
    let rightUnit: String;
    let pOnItemTap: (_ pItem: ListItemContent) -> Void;
    
    var body: some View
    {
        VStack(alignment: .leading, spacing: 8)
        {
            HStack
            {
                Text(title)
                    .font(.footnote)
                    .bold()
                
                Spacer()
                
                HStack
                {
                    Text("\(rightVal)")
                        .font(.footnote)
                        .contentTransition(.numericText())
                        .animation(.snappy, value: rightVal)
                    
                    Text(rightUnit)
                        .font(.footnote)
                }
                .opacity(rightVal > 0 ? 1 : 0)
                .animation(.snappy, value: rightVal > 0)
            }
            Divider ()
            
            ForEach (contents, id: \.compositeId)
            {item in
                ListItem (pItem: item, pOnDelete: onItemDelete)
                {item in
                    pOnItemTap (item);
                }
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .move(edge: .top)),
                    removal: .opacity.combined(with: .scale(scale: 0.95))
                ))
                
                if item.compositeId != contents.last?.compositeId
                {
                    Divider ()
                }
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: contents.map(\.compositeId))
        .padding(.top)
    }
    
    private func onItemDelete (_ pItem: ListItemContent) -> Void
    {
        pOnDelete (pItem)
    }
}
