//
//  NavigationEnums.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 04/11/25.
//

enum Route: Hashable {
    case create
    case join
    case session(id: String, name: String?)
    case session(id: String)
    case comment(ideaId: Int64)
}
