//
//  EventListView.swift
//  Member_Missionary
//
//  Created by Evan Hilton on 5/26/20.
//  Copyright © 2020 Evan Hilton. All rights reserved.
//

import SwiftUI

struct EventListView: View {
    @State var events = [EventStruct]()
    var update: () -> [EventStruct]
    var body: some View {
        List {
            ForEach(events, id: \.self) { event in
                VStack(alignment: .leading, spacing: 0) {
                    NavigationLink(destination: EventView(event: event)) {
                        ListItemView(
                            image: event.eventType.getImage(),
                            titleString: "\(event.title): \(nameString(event.friendId))",
                            subTitleString: timeString(time: event.time)
                        )
                    }
                }
            }
            .onDelete { (indexSet) in
                withAnimation() {
                    self.delete(offsets: indexSet)
                }
            }
        }
        .onAppear() {
            self.events = self.update()
        }
    }
    
    private func delete(offsets: IndexSet) {
        DataExchanger.shared.delEvent(id: self.events[offsets.first!].id)
        self.events.remove(atOffsets: offsets)
    }
}

struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        EventListView(update: { return [] })
    }
}
