//
//  FriendForm.swift
//  Member_Missionary
//
//  Created by Evan Hilton on 5/21/20.
//  Copyright © 2020 Evan Hilton. All rights reserved.
//

import SwiftUI

struct FriendForm: View {
    @State var memberDisplayed = false
    @State var genderDisplayed = false
    @State var actionSheetDisplayed = false
    @State var sheetDisplayed = false
    @State var useCamera = false
    @State private var contactId: Int? = nil
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var gender: Int = 0
    @State private var phoneNumberString: String = ""
    @State private var chosenPhoto: UIImage? = nil
    @State private var ageString: String = ""
    @State private var member: Int = 0
    var friend: FriendStruct? = nil
    var close: () -> ()
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .center) {
                    Spacer()
                    if chosenPhoto != nil {
                        Image(uiImage: chosenPhoto!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(minWidth: 100, maxWidth: 100, minHeight: 100, maxHeight: 100)
                        .foregroundColor(.gray)
                    } else {
                        Image(systemName: "person.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(minWidth: 100, maxWidth: 100, minHeight: 100, maxHeight: 100)
                        .foregroundColor(.gray)
                    }
                    Button(action: {
                        self.actionSheetDisplayed.toggle()
                    }) {
                        Text("Choose Photo")
                    }
                    .actionSheet(isPresented: self.$actionSheetDisplayed) {
                    ActionSheet(
                        title: Text("Choose Photo"),
                        message: Text("All actions"),
                        buttons: [
                            .cancel {},
                            .default(Text("From Photo Library"), action: {
                                print("Using Photo Library")
                                self.sheetDisplayed = true
                                self.useCamera = false
                            }),
                            .default(Text("Use Camera"), action: {
                                print("Using Camera")
                                self.sheetDisplayed = true
                                self.useCamera = true
                            }),
                            .default(Text("Remove Image"), action: {
                                print("Removing image")
                                self.chosenPhoto = nil
                            })
                        ]
                    )}
                }
                HStack {
                    Spacer()
                    VStack(alignment: .leading) {
                        Group {
                            Divider()
                            TextField("first name", text: $firstName)
                        }
                        Group {
                            Divider()
                            TextField("last name", text: $lastName)
                        }
                        Group {
                            Divider()
                            PhoneNumberTextField(placeholder: "phone number", text: $phoneNumberString)
                        }
                        Group {
                            Divider()
                            TextField("age", text: $ageString)
                            .keyboardType(.numberPad)
                        }
                        Group {
                            Divider()
                            Button(action: {
                                withAnimation {
                                    self.dismissKeyboard()
                                    self.memberDisplayed.toggle()
                                    self.genderDisplayed = false
                                }
                            }) { member == 1 ? Text("Member") : Text("Non-Member") }
                            if self.memberDisplayed == true {
                                Picker(selection: $member, label: Text("")) {
                                    ForEach(0 ..< 2) { index in
                                        if index == 0 {
                                            Text("Non-Member")
                                        } else {
                                            Text("Member")
                                        }
                                    }
                                }.labelsHidden()
                            }
                        }
                        Group {
                            Divider()
                            Button(action: {
                                withAnimation {
                                    self.dismissKeyboard()
                                    self.genderDisplayed.toggle()
                                    self.memberDisplayed = false
                                }
                            }) { Text(GenderEnum(rawValue: gender)!.toString()) }
                            if self.genderDisplayed == true {
                                Picker(selection: $gender, label: Text("")) {
                                    ForEach(0 ..< 2) { index in
                                        Text(GenderEnum(rawValue: index)!.toString())
                                    }
                                }.labelsHidden()
                            }
                        }
                        Spacer()
                    }
                }
                .layoutPriority(1)
            }
            .navigationBarTitle(Text(friend != nil ? "Edit Friend" : "New Friend"), displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.close()
                print("Closing for Cancel")
            }) {
                Text("Cancel")
            }, trailing: Button(action: {
                print("Closing for Done")
                var tmpId = Int()
                if let friend = self.friend  {
                    DataExchanger.shared.delFriend(delEvents: false, id: friend.id)
                    tmpId = friend.id
                } else {
                    let friends = DataExchanger.shared.getAllFriends().sorted { $0.id < $1.id }
                    tmpId = friends.count != 0 ? friends.last!.id + 1 : 0
                }
                let newFriend = FriendStruct(
                    id: tmpId,
                    contactsId: nil,
                    firstName: self.firstName,
                    lastName: self.lastName,
                    gender: GenderEnum(rawValue: self.gender)!,
                    phoneNumber: Int(self.phoneNumberString.filter("0123456789".contains)) ?? 0,
                    photo: self.chosenPhoto != nil ? self.chosenPhoto!.pngData() : nil,
                    age: Int(self.ageString),
                    member: self.member == 0 ? false : true
                )
                print("newFriend: \(newFriend)")
                DataExchanger.shared.addFriend(friend: newFriend)
                self.close()
            }) {
                Text("Done")
            })
        }.onAppear() {
            if let friend = self.friend {
                self.contactId = friend.contactsId
                self.firstName = friend.firstName
                self.lastName = friend.lastName
                self.phoneNumberString = formatPhoneNumber(String(friend.phoneNumber))
                self.gender = friend.gender.rawValue
                self.chosenPhoto = friend.photo != nil ? UIImage(data: friend.photo!) : nil
                self.ageString = friend.age == nil ? "" : String(friend.age!)
                self.member = friend.member == true ? 1 : 0
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (notification) in
                self.memberDisplayed = false
                self.genderDisplayed = false
            }
        }
        .sheet(isPresented: $sheetDisplayed
        ) {
            ImagePicker(image: self.$chosenPhoto, useCamera: self.useCamera)
        }
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
    }
    
    private func checkPhotoLibraryAuthorizationStatus() -> Bool {
       return true
    }
    
    private func checkCameraAuthorizationStatus() -> Bool {
        return true
    }
}

struct FriendForm_Previews: PreviewProvider {
    static var previews: some View {
        FriendForm(close: {})
    }
}
