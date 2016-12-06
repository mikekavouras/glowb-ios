//
//  Selectable.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/5/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

enum SelectedState {
    case selected
    case deselected
}

protocol Selectable {
    var selectedState: SelectedState { get set }
}
