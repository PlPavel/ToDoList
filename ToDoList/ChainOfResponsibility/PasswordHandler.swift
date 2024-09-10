//
//  PasswordHandler.swift
//  ToDoList
//
//  Created by Pavel Plyago on 18.07.2024.
//

import Foundation

//MARK: реализация паттерна шаблонный метод
// мы перекладываем ответственность на другие классы, благодаря чему мы можем изменить шаги не изменяя алгоритма

//MARK: реализация паттерна Responsibility chain
// обрабатывается регистрация пользователя, если пароль не соответсвует условиям нижеприведенным
// то появляется AlertController куда передается сообщение о соответствующей ошибке
protocol ValidationHandler {
    var nextHandler: ValidationHandler? { get set }
    func validate(input: String) -> String?
}


class EmptyInputValidation : ValidationHandler {
    var nextHandler: ValidationHandler?
    
    func validate(input: String) -> String? {
        if input.isEmpty {
            return "Input is empty"
        } else {
            return nextHandler?.validate(input: input)
        }
    }
}

class MinimumLengthHandler : ValidationHandler {
    var nextHandler: ValidationHandler?
    private let minLength: Int
    
    init(minLength: Int) {
        self.minLength = minLength
    }
    
    func validate(input: String) -> String? {
        if input.count < minLength {
            return "Input is too short. Minimum length is \(minLength)"
        } else {
            return nextHandler?.validate(input: input)
        }
    }
}

class SpecialCharacterHandler: ValidationHandler {
    var nextHandler: ValidationHandler?
    
    func validate(input: String) -> String? {
        let specialCharacters = CharacterSet(charactersIn: "!@#$%^&*()_+=-`~:;{}[]<>,/?")
        if input.rangeOfCharacter(from: specialCharacters) != nil {
            return "Input has at least one special character"
        } else {
            return nextHandler?.validate(input: input)
        }
    }
    
}
