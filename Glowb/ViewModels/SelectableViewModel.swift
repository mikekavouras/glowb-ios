//
//  SelectableViewModel.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/5/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

struct SelectableViewModel<T>: Selectable {
    let model: T
    var selectedState: SelectedState
    
    init(model: T, selectedState: SelectedState) {
        self.model = model
        self.selectedState = selectedState
    }
}
