//
//  TextView.swift
//  Member_Missionary
//
//  Created by Evan Hilton on 6/11/20.
//  Copyright © 2020 Evan Hilton. All rights reserved.
//

import SwiftUI

struct TextView: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.font = .systemFont(ofSize: 17)
        view.delegate = context.coordinator
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.isScrollEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = true
        view.sizeToFit()
        view.textContainer.lineBreakMode = .byWordWrapping
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator($text)
    }
    
    class Coordinator : NSObject, UITextViewDelegate {
        var text: Binding<String>
        init(_ text: Binding<String>) {
            self.text = text
        }
        func textViewDidChange(_ textView: UITextView) {
            self.text.wrappedValue = textView.text
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = .label
    }
}

struct TextView_Previews: PreviewProvider {
    static var previews: some View {
        TextView(text: .constant(""))
    }
}
