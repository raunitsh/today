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
    let pOnItemTap: (_ pItem: ListItemContent) -> Void;
    
    var body: some View
    {
        VStack(alignment: .leading, spacing: 8)
        {
            Text(title)
                .font(.footnote)
                .bold()
            Divider ()
            
            ForEach (contents, id: \.compositeId)
            {item in
                ListItem (pItem: item, pOnDelete: onItemDelete)
                {item in
                    pOnItemTap (item);
                }
                
                if item.compositeId != contents.last?.compositeId
                {
                    Divider ()
                }
            }
        }
        .padding(.top)
    }
    
    private func onItemDelete (_ pItem: ListItemContent) -> Void
    {
        pOnDelete (pItem)
    }
}
