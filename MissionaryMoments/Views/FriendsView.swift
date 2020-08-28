//
//  FriendsView.swift
//  Member_Missionary
//
//  Created by Evan Hilton on 5/20/20.
//  Copyright © 2020 Evan Hilton. All rights reserved.
//

import SwiftUI

struct FriendsView: View {
    @State var friends = [FriendStruct]()
    @State var friendFormDisplayed = false
    var body: some View {
        NavigationView() {
            VStack(alignment: .center, spacing: 0) {
                if friendFormDisplayed == false {
                    List {
                        ForEach(friends, id: \.self) { friend in
                            NavigationLink(destination: FriendView(friend: friend)) {
                                ListItemView(
                                    image: self.getPhoto(friend: friend),
                                    titleString: "\(friend.firstName) \(friend.lastName)",
                                    subTitleString: "\(memberString(friend.member)), \(String(friend.age ?? Int()))"
                                )
                            }
                        }
                        .onDelete { (indexSet) in
                            withAnimation() {
                                self.delete(offsets: indexSet)
                            }
                        }
                    }
                    .onAppear() {
                        self.friends = self.update()
                    }
                }
            }
            .navigationBarTitle("Friends")
            .navigationBarItems(trailing: Button(action: { self.friendFormDisplayed = true }) {
                Text("Add Friend")
            }
            .sheet(isPresented: $friendFormDisplayed) {
                FriendForm(close: { self.friendFormDisplayed = false })
            })
        }
        .tabItem {
            Image(systemName: "person.2.fill")
            Text("Friends")
        }
    }
    
    private func delete(offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let friendId = self.friends[index].id
        let events = DataExchanger.shared.getAllFriendsEvents(friendId: friendId)
        for event in events {
            _ = DataExchanger.shared.delEvent(id: event.id)
        }
        _ = DataExchanger.shared.delFriend(id: friendId)
        self.friends.remove(atOffsets: offsets)
    }
    
    private func getPhoto(friend: FriendStruct) -> Image {
        var photo: Image
        if friend.photo != nil {
            photo = Image(uiImage: UIImage(data: friend.photo!)!)
        } else {
            photo = Image(systemName: "person.fill")
        }
        return photo
    }
    
    private func update() -> [FriendStruct] {
        return DataExchanger.shared.getAllFriends().sorted { $0.firstName < $1.firstName }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
