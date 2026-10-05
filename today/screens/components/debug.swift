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
