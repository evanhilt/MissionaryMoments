//
//  FriendView.swift
//  Member_Missionary
//
//  Created by Evan Hilton on 5/21/20.
//  Copyright © 2020 Evan Hilton. All rights reserved.
//

import SwiftUI

struct FriendView: View {
    @State var friend: FriendStruct
    @State var actionSheetDisplayed = false
    @State var sheetDisplayed = false
    @State var friendFormDisplayed = false
    @State var eventFormDisplayed = false
    @State var messagerDisplayed = false
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                HStack() {
                    if self.friend.photo != nil {
                        Image(uiImage: UIImage(data: self.friend.photo!)!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: geo.size.width / 3, height: geo.size.width / 2)
                        .foregroundColor(.gray)
                    } else {
                        self.getPhotoImage()
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: geo.size.width / 3, height: geo.size.width / 2)
                        .foregroundColor(.gray)
                    }
                    VStack() {
                        Text("\(self.friend.firstName) \(self.friend.lastName)")
                            .font(.title)
                        if self.friend.phoneNumber != 0 {
                            Button(action: {
                                self.actionSheetDisplayed = true
                            }) {
                                Text(formatPhoneNumber(String(self.friend.phoneNumber)))
                            }
                            .actionSheet(isPresented: self.$actionSheetDisplayed) {
                            ActionSheet(
                                title: Text(formatPhoneNumber(String(self.friend.phoneNumber))),
                                message: Text("All actions"),
                                buttons: [
                                    .cancel { self.actionSheetDisplayed = false },
                                    .default(Text("Call"), action: {
                                        print("Calling")
                                        let telephone = "tel://"
                                        let formattedString = telephone + String(self.friend.phoneNumber)
                                        guard let url = URL(string: formattedString) else { return }
                                        UIApplication.shared.open(url)
                                    }),
                                    .default(Text("Text"), action: {
                                        self.messagerDisplayed.toggle()
                                        self.sheetDisplayed.toggle()
                                    })
                                ]
                            )}
                        } else {
                            Text("phone number")
                        }
                        Text(memberString(self.friend.member))
                        Text(self.friend.gender.toString())
                        Text(self.friend.age != nil ? self.ageString(age: self.friend.age!) : "")
                    }
                }
                Divider()
                if self.sheetDisplayed == false {
                    EventListView(update: {
                        return DataExchanger.shared.getAllFriendsEvents(friendId: self.friend.id)
                    })
                } else {
                    Spacer()
                }
            }
            .sheet(isPresented: self.$sheetDisplayed, onDismiss: {
                self.falseifyDisplays()
            }) {
                if self.messagerDisplayed == true {
                    MessageComposeView(phoneNumbers: [ String(self.friend.phoneNumber)], message: "", didFinishWithResult: { result in
                        self.falseifyDisplays()
                        if(result.rawValue == 0) {
                            print("Cancelled")
                        } else if(result.rawValue == 1) {
                            print("Success")
                        } else {
                            print("Failed")
                        }
                    })
                } else if self.eventFormDisplayed == true {
                    EventForm(friend: self.friend, event: nil, close: {
                        self.falseifyDisplays()
                    })
                } else if self.friendFormDisplayed == true {
                    FriendForm(friend: self.friend, close: {
                        self.friend = DataExchanger.shared.getFriend(id: self.friend.id)!
                        self.falseifyDisplays()
                    })
                } else {
                    EmptyView()
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(trailing:
            HStack {
                Button(action: {
                    self.friendFormDisplayed = true
                    self.sheetDisplayed = true
                }) {
                    Text("Edit Friend")
                }
                Button(action: {
                    self.eventFormDisplayed = true
                    self.sheetDisplayed = true
                }) {
                    Text("Add Event")
                }
            }
        )
    }
    
    private func falseifyDisplays() {
        self.sheetDisplayed = false
        self.friendFormDisplayed = false
        self.eventFormDisplayed = false
        self.messagerDisplayed = false
    }
    
    private func getPhotoImage() -> Image {
        if let photo = self.friend.photo {
            if let uiImage = UIImage(data: photo) {
                return Image(uiImage: uiImage)
            }
        }
        return Image(systemName: "person.fill")
    }
    
    private func ageString(age: Int) -> String {
        if(age == 1) {
            return "\(age) year old"
        } else {
            return "\(age) years old"
        }
    }
}

struct FriendView_Previews: PreviewProvider {
    static var previews: some View {
        FriendView(friend: FriendStruct(id: 0, contactsId: 0, firstName: "", lastName: "", gender: .male, phoneNumber: 0, photo: nil, age: 0, member: false))
    }
}
