//
//  NavigationEnums.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 04/11/25.
//

enum Route: Hashable {
    case create, join
    case room(id: String, name: String?)
}
