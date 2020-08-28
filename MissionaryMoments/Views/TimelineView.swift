//
//  TimelineView.swift
//  Member_Missionary
//
//  Created by Evan Hilton on 5/20/20.
//  Copyright © 2020 Evan Hilton. All rights reserved.
//

import SwiftUI

struct TimelineView: View {
    @State var eventFormDisplayed = false
    var body: some View {
        NavigationView() {
            ZStack {
                if eventFormDisplayed == false {
                    EventListView(update: {
                        return DataExchanger.shared.getAllEvents().sorted { $0.time < $1.time }
                    })
                }
            }
            .navigationBarTitle("Timeline")
            .navigationBarItems(trailing: Button(action: {
                if DataExchanger.shared.getAllFriends().count != 0 {
                    self.eventFormDisplayed = true
                }
            }) {
                Text("Add Event")
            }
            .sheet(isPresented: $eventFormDisplayed) {
                EventForm(friend: nil, event: nil, close: { self.eventFormDisplayed = false })
            })
        }
        .tabItem {
            Image(systemName: "clock.fill")
            Text("Timeline")
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
    }
}
