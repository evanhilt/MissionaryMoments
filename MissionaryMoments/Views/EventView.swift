//
//  EventView.swift
//  Member_Missionary
//
//  Created by Evan Hilton on 5/21/20.
//  Copyright © 2020 Evan Hilton. All rights reserved.
//

import SwiftUI

struct EventView: View {
    @State var event: EventStruct
    @State var eventFormDisplayed = false
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                HStack(alignment: .lastTextBaseline) {
                    self.event.eventType.getImage()
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: geo.size.width / 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.primary, lineWidth: 1)
                    )
                    Text("\(self.event.eventType.eventString()) ")
                    .font(.title)
                }
                NavigationLink(destination: FriendView(friend: DataExchanger.shared.getFriend(id: self.event.friendId)!)) { Text(nameString(self.event.friendId)).font(.headline)
                }
                Text(timeString(time: self.event.time)).font(.callout)
                Text("").font(.body).hidden()
                Text(self.event.notes).font(.body)
                    .frame(minWidth: geo.size.width - (geo.size.width / 8), alignment: .leading)
                Spacer()
            }
        }
        .navigationBarTitle(Text(self.event.title), displayMode: .large)
        .navigationBarItems(trailing: Button(action: {
            self.eventFormDisplayed = true
        }) {
            Text("Edit")
        }.sheet(isPresented: $eventFormDisplayed) {
            EventForm(event: self.event, close: {
                self.event = DataExchanger.shared.getEvent(id: self.event.id)!
                self.eventFormDisplayed = false
            })
        })
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView(event: EventStruct(id: 0, friendId: 0, time: Date(), title: "", notes: "", eventType: EventEnum(rawValue: 0)!))
    }
}
