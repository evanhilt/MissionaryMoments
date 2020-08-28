//
//  EventForm.swift
//  Member_Missionary
//
//  Created by Evan Hilton on 5/21/20.
//  Copyright © 2020 Evan Hilton. All rights reserved.
//

import SwiftUI

struct EventForm: View {
    @State var friendsDisplayed = false
    @State var timeDisplayed = false
    @State var typeDisplayed = false
    @State var keyboardHeight: CGFloat = 0.0
    @State var titleEditing = false
    @State private var title: String = ""
    @State private var friendIndex: Int = 0
    @State private var time: Date = Date()
    @State private var eventType: Int = 0
    @State private var notes: String = ""
    var friend: FriendStruct?
    var event: EventStruct?
    var close: () -> ()
    var friends = DataExchanger.shared.getAllFriends().sorted { $0.firstName < $1.firstName }
    var body: some View {
        NavigationView {
            HStack {
            Spacer()
                VStack(alignment: .leading) {
                    Spacer()
                    if titleEditing == false && keyboardHeight > 0.0 { Spacer() }
                    Group {
                        TextField("Title", text: self.$title, onEditingChanged: { (editingChanged) in
                            if editingChanged {
                                self.titleEditing = true
                            } else {
                                self.titleEditing = false
                            }
                        })
                    }
                    Group {
                        Divider()
                        if self.friend == nil {
                            Button(action: {
                                withAnimation {
                                    self.titleEditing = false
                                    self.dismissKeyboard()
                                    self.friendsDisplayed.toggle()
                                    self.timeDisplayed = false
                                    self.typeDisplayed = false
                                }
                            }) { Text("\(self.friends[self.friendIndex].firstName) \(self.friends[self.friendIndex].lastName)") }
                            if self.friendsDisplayed == true {
                                Picker(selection: self.$friendIndex, label: Text("")) {
                                    ForEach(0 ..< self.friends.count) {
                                        Text("\(self.friends[$0].firstName) \(self.friends[$0].lastName)")
                                    }
                                }.labelsHidden()
                            }
                        } else {
                            Text("\(self.friend!.firstName) \(self.friend!.lastName)").foregroundColor(.primary)
                        }
                    }
                    Group {
                        Divider()
                        Button(action: {
                            withAnimation {
                                self.titleEditing = false
                                self.dismissKeyboard()
                                self.timeDisplayed.toggle()
                                self.friendsDisplayed = false
                                self.typeDisplayed = false
                            }
                        }) {
                            Text(timeString(time: self.time))
                            .transition(.move(edge: .bottom))
                        }
                        if self.timeDisplayed == true {
                            DatePicker("", selection: self.$time, in: ...Date())
                            .labelsHidden()
                        }
                    }
                    Group {
                        Divider()
                        Button(action: {
                            withAnimation {
                                self.titleEditing = false
                                self.dismissKeyboard()
                                self.typeDisplayed.toggle()
                                self.friendsDisplayed = false
                                self.timeDisplayed = false
                            }
                        }) {
                            Text(EventEnum(rawValue: self.eventType)!.eventString())
                            .transition(.move(edge: .bottom))
                        }
                        if self.typeDisplayed == true {
                            Picker(selection: self.$eventType, label: Text("")) {
                                ForEach(0 ..< EventEnum.allCases.count) {
                                    Text(EventEnum(rawValue: $0)!.eventString())
                                }
                            }.labelsHidden()
                        }
                    }
                    Group {
                        Divider()
                        Text("Notes").font(.headline)
                        TextView(text: self.$notes)
                    }
                    Spacer().frame(height: self.keyboardHeight / 2)
                }
                .offset(y: -self.keyboardHeight / 2)
            }
            .navigationBarTitle(Text(event != nil ? "Edit Event" : "New Event"), displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.close()
                print("Closing for Cancel")
            }) {
                Text("Cancel")
            }, trailing: Button(action: {
                print("Closing for Done")
                var tmpId = Int()
                if self.event != nil {
                    DataExchanger.shared.delEvent(id: self.event!.id)
                    tmpId = self.event!.id
                } else {
                    let events = DataExchanger.shared.getAllEvents().sorted { $0.id < $1.id }
                    tmpId = events.count != 0 ? events.last!.id + 1 : 0
                }
                let newEvent = EventStruct(
                    id: tmpId,
                    friendId: self.friend != nil ? self.friend!.id : self.friends[self.friendIndex].id,
                    time: self.time,
                    title: self.title,
                    notes: self.notes,
                    eventType: EventEnum(rawValue: self.eventType)!
                )
                DataExchanger.shared.addEvent(event: newEvent)
                self.close()
            }) {
                Text("Done")
            })
        }
        .onAppear {
            if let event = self.event {
                self.title = event.title
                self.friendIndex = self.friends.firstIndex(where: { $0.id == event.friendId })!
                self.time = event.time
                self.notes = event.notes
                self.eventType = event.eventType.rawValue
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (notification) in
                guard let keyboardFrame = notification.userInfo? [UIResponder.keyboardFrameEndUserInfoKey] as?
                CGRect else { return }
                self.timeDisplayed = false
                self.friendsDisplayed = false
                self.typeDisplayed = false
                if self.titleEditing == false {
                    self.keyboardHeight = keyboardFrame.height
                }
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (notification) in
                if self.titleEditing == false {
                    self.keyboardHeight = 0
                }
            }
        }
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
    }
}

struct EventForm_Previews: PreviewProvider {
    static var previews: some View {
        EventForm(event: nil, close: {})
    }
}
