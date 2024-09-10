//
//  ProductThemed.swift
//  ToDoList
//
//  Created by Pavel Plyago on 14.07.2024.
//

import Foundation
import UIKit

protocol ThemedTextView {
    func create() -> UITextView
}

protocol ThemedTextField {
    func create() -> UITextField
}

class LightThemedTextView: ThemedTextView {
    func create() -> UITextView {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        
        return textView
    }
}
