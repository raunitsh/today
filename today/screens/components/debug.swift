//
//  debug.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

struct BorderModifier: ViewModifier
{
    func body (content: Content) -> some View
    {
        content
            .border(.blue)
    }
}

extension View
{
    func debug () -> some View
    {
        modifier(BorderModifier ());
    }
}

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
            )
    }
}

extension View {
    func asCard() -> some View {
        modifier(CardModifier())
    }
}
