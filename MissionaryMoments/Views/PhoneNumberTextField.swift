//
//  PhoneNumberTextField.swift
//  Member_Missionary
//
//  Created by Evan Hilton on 6/25/20.
//  Copyright © 2020 Evan Hilton. All rights reserved.
//

import SwiftUI

struct PhoneNumberTextField: UIViewRepresentable {
    var placeholder: String = ""
    @Binding var text: String
    
    func makeUIView(context: UIViewRepresentableContext<PhoneNumberTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.placeholder = placeholder
        textField.keyboardType = .numberPad
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<PhoneNumberTextField>) {
        uiView.text = formatPhoneNumber(text)
        let newPosition = uiView.endOfDocument
        uiView.selectedTextRange = uiView.textRange(from: newPosition, to: newPosition)
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentCompressionResistancePriority(.required, for: .vertical)
    }

    func makeCoordinator() ->PhoneNumberTextField.Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: PhoneNumberTextField

        init(parent: PhoneNumberTextField) {
            self.parent = parent
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.parent.text = textField.text ?? ""
            }
        }
    }
}

struct PhoneNumberTextField_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberTextField(text: .constant(""))
    }
}
