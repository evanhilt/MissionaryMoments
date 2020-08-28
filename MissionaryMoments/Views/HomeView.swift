//
//  SwiftUIView.swift
//  Member_Missionary
//
//  Created by Evan Hilton on 5/20/20.
//  Copyright © 2020 Evan Hilton. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView() {
            FriendsView()
            TimelineView()
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
