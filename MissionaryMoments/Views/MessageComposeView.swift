//
//  MessageComposeView.swift
//  Member_Missionary
//
//  Created by Evan Hilton on 5/27/20.
//  Copyright © 2020 Evan Hilton. All rights reserved.
//

import SwiftUI
import MessageUI

struct MessageComposeView: UIViewControllerRepresentable {
    let phoneNumbers: [String]
    let message: String
    let didFinishWithResult: (MessageComposeResult) -> ()

    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let viewController = MFMessageComposeViewController()
        viewController.messageComposeDelegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(
        _ viewController: MFMessageComposeViewController,
        context: Context
    ) {
        viewController.recipients = phoneNumbers
        viewController.body = message
        context.coordinator.didFinishWithResult = didFinishWithResult
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator : NSObject, MFMessageComposeViewControllerDelegate {
        
        var didFinishWithResult: (MessageComposeResult) -> () = { _ in }
        
        func messageComposeViewController(
            _ controller: MFMessageComposeViewController,
            didFinishWith result: MessageComposeResult
        ) {
            didFinishWithResult(result)
        }
        
    }
    
}

struct MessageComposeView_Previews: PreviewProvider {
    static var previews: some View {
        MessageComposeView(
            phoneNumbers: [""],
            message: "",
            didFinishWithResult: { result in
                print(result)
            }
        )
    }
}
