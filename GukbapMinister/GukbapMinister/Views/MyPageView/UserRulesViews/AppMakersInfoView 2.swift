//
//  AppMakersInfoView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/03/08.
//

import SwiftUI
import Kingfisher

struct MakersInfo: Identifiable, Hashable {
    var id: Self { self }
    var name: String
    var nickName: String?
    var imageUrl: String
    var links: [String: String]
}

struct MakersNameCard: View {
    var info: MakersInfo
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                KFImage.url(URL(string:info.imageUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80)
                    .clipShape(Circle())
                    .padding(.trailing, 20)
                VStack(alignment: .leading) {
                    HStack(alignment: .bottom, spacing:3) {
                        Text(info.name)
                            .font(.headline)
                            .bold()
                        if let nickname = info.nickName {
                            Text(nickname)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.top, 10)
                    Spacer()
                    HStack(spacing: 5) {
                        ForEach(Array(info.links.keys), id: \.self) { linkName in
                            Link(destination: URL(string: info.links[linkName] ?? "")!) {
                                HStack(spacing: 0) {
                                    Image(systemName: "link")
                                        .padding(.trailing, 5)
                                    Text(linkName)
                                }
                                .font(.caption)
                                .padding(3)
                                .padding(.horizontal, 5)
                                .background {
                                    Capsule()
                                        .fill(Color.accentColor.opacity(0.1))
                                }
                            }
                        }
                    }
                    .padding(.bottom, 15)
                    Divider()
                }
                
                Spacer()
            }
            .padding()
            
        }
    }
    
}

struct AppMakersInfoView: View {
    var members: [MakersInfo] =
    [
        MakersInfo(name: "이석준", nickName:"MartinLee", imageUrl: "https://avatars.githubusercontent.com/u/76909552?v=4", links: ["github" : "https://github.com/MartinLeeSJ"]),
        MakersInfo(name: "박성민", nickName:"TED", imageUrl: "https://avatars.githubusercontent.com/u/108975398?v=4", links: ["github" : "https://github.com/teddy5518"]),
        MakersInfo(name: "이원형", nickName:"Circle Bro", imageUrl: "https://avatars.githubusercontent.com/u/67450169?v=4", links: ["github" : "https://github.com/whl0526"]),
        MakersInfo(name: "전혜성", nickName: "Halley's Comet", imageUrl: "https://avatars.githubusercontent.com/u/98198645?v=4", links: ["github" : "https://github.com/angry-dev"]),
        MakersInfo(name: "박정선", nickName: "써니", imageUrl: "https://avatars.githubusercontent.com/u/91583287?v=4", links: ["github" : "https://github.com/JSPark0099"]),
    ]
    
    var previousMembers: [MakersInfo] =
    [
        MakersInfo(name: "기태욱", imageUrl: "https://avatars.githubusercontent.com/u/79833715?v=4", links: ["github" : "https://github.com/KiTaeUk"]),
        MakersInfo(name: "이영우", imageUrl: "https://avatars.githubusercontent.com/u/114223605?v=4", links: ["github" : "https://github.com/Lee-Youngwoo"]),
    ]
    
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(members.shuffled()) { member in
                    MakersNameCard(info: member)
                }
                
                DisclosureGroup("~23.02.17") {
                    ForEach(previousMembers.shuffled()) { member in
                        MakersNameCard(info: member)
                    }
                }
            }
            .padding()
            .padding(.bottom, 50)
        }
    }
}

struct AppMakersInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AppMakersInfoView()
    }
}
