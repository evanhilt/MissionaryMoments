//
//  ListItemView.swift
//  Member_Missionary
//
//  Created by Evan Hilton on 7/8/20.
//  Copyright © 2020 Evan Hilton. All rights reserved.
//

import SwiftUI


struct ListItemView: View {
    var image: Image
    var titleString: String
    var subTitleString: String
    var body: some View {
        GeometryReader { geo in
            HStack() {
                self.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.gray)
                .frame(width: geo.size.width / 8)
                VStack(alignment: .leading) {
                    Text(self.titleString)
                    Text(self.subTitleString)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                Spacer()
            }.frame(width: geo.size.width)
        }
    }
}

struct ListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ListItemView(image: Image(systemName: "person.fill"), titleString: "Title", subTitleString: "Sub")
    }
}
