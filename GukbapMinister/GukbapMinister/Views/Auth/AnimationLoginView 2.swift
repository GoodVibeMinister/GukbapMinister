//
//  AnimationLoginView.swift
//  GukbapMinister
//
//  Created by 전혜성 on 2023/03/07.
//

import SwiftUI

struct AnimationLoginView: View {
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
        @State private var count: CGFloat = 0
        
        public init() {}
        public var body: some View {
            GeometryReader { proxy in
                if proxy.size.width > proxy.size.height {
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            BoxTypo(title: "국밥부장관", count: $count)
                            BoxTypo(title: "국밥부장관", count: $count)
                            BoxTypo(title: "국밥부장관", count: $count)
                            BoxTypo(title: "국밥부장관", count: $count)
                        }
                        HStack(spacing: 0) {
                            BoxTypo(title: "국밥부장관", count: $count)
                            BoxTypo(title: "국밥부장관", count: $count)
                            BoxTypo(title: "국밥부장관", count: $count)
                            BoxTypo(title: "국밥부장관", count: $count)
                        }
                        HStack(spacing: 0) {
                            BoxTypo(title: "국밥부장관", count: $count)
                            BoxTypo(title: "국밥부장관", count: $count)
                            BoxTypo(title: "국밥부장관", count: $count)
                            BoxTypo(title: "국밥부장관", count: $count)
                        }
                        HStack(spacing: 0) {
                            BoxTypo(title: "국밥부장관", count: $count)
                            BoxTypo(title: "국밥부장관", count: $count)
                            BoxTypo(title: "국밥부장관", count: $count)
                            BoxTypo(title: "국밥부장관", count: $count)
                        }
                    }
                }else {
                    HStack(spacing: 0) {
                        VStack(spacing: 0) {
                            BoxTypo(title: "국밥부장관", count: $count)
                            BoxTypo(title: "국밥부장관", count: $count)
                            BoxTypo(title: "국밥부장관", count: $count)
                            BoxTypo(title: "국밥부장관", count: $count)
                            BoxTypo(title: "국밥부장관", count: $count)
                            

                        }
                        VStack(spacing: 0) {
                            BoxTypo(title: "국밥부장관", count: $count)
                            BoxTypo(title: "국밥부장관", count: $count)
                            BoxTypo(title: "국밥부장관", count: $count)
                            BoxTypo(title: "국밥부장관", count: $count)
                            BoxTypo(title: "국밥부장관", count: $count)
                            BoxTypo(title: "국밥부장관", count: $count)
                        }
                        VStack(spacing: 0) {
                            BoxTypo(title: "국밥부장관", count: $count)
                            BoxTypo(title: "국밥부장관", count: $count)
                            BoxTypo(title: "국밥부장관", count: $count)
                            BoxTypo(title: "국밥부장관", count: $count)
                            BoxTypo(title: "국밥부장관", count: $count)
                            
                        }
                        VStack(spacing: 0) {
                            BoxTypo(title: "국밥부장관", count: $count)
                            BoxTypo(title: "국밥부장관", count: $count)
                            BoxTypo(title: "국밥부장관", count: $count)
                            BoxTypo(title: "국밥부장관", count: $count)
                            BoxTypo(title: "국밥부장관", count: $count)
                            BoxTypo(title: "국밥부장관", count: $count)
                        }
                    }
                }
            }
            .onReceive(timer) { time in
                withAnimation(Animation.easeInOut(duration: 0.3)) {
                    count += 0.3
                }
            }
        }
    }

    fileprivate
    struct Line: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            return path
        }
    }

    fileprivate
    struct BoxTypo: View {
        var title: String
        @Binding var count: CGFloat
        
        var body: some View {
            GeometryReader { proxy in
                ZStack {
                    Rectangle()
                        .fill(Color.clear)
                    VStack(spacing: 0) {
                        Text(title)
                            .font(.custom("Menlo Bold", fixedSize: getFontSize(proxy)))
                            .opacity(0.6)
                            .overlay(
                                VStack(spacing: 0) {
//                                    Line()
//                                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
//                                        .frame(width: proxy.size.width , height: 1)
//                                        .opacity(0.5)
//                                    Spacer()
//                                        .frame(height: getFontSize(proxy) * 0.75)
                                }
                            )
                            .offset(x: -getFontSize(proxy) * sin(count))
                            .transformEffect(CGAffineTransform(a: 1, b: 1, c: -0.6, d: 2, tx: 1, ty: 1))
                            .rotationEffect(Angle(degrees: -70))
                        
                        Text(title)
                            .font(.custom("Menlo Bold", fixedSize: getFontSize(proxy)))
                            .opacity(0.3)
                            .overlay(
                                VStack(spacing: 0) {
//                                    Spacer()
//                                        .frame(height: getFontSize(proxy) * 0.75)
//                                    Line()
//                                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
//                                        .frame(width: proxy.size.width, height: 1)
//                                        .opacity(0.5)
                                }
                            )
                            .offset(x: -getFontSize(proxy) * cos(count))
                            .transformEffect(CGAffineTransform(a: 1, b: 1, c: -1.7, d: 0.5, tx: 1, ty: 1))
                            .rotationEffect(Angle(degrees: -70))
                            .offset(x: getFontSize(proxy) * 0.54, y: getFontSize(proxy) * 0.2)
                        
                        
                    }
                    .offset(x: -getFontSize(proxy) * 3, y: -getFontSize(proxy) * 2)
                }
            }
        }
        
        private func getFontSize(_ proxy: GeometryProxy) -> CGFloat {
            return proxy.size.width / 2 * 0.2
        }
    }

struct AnimationLoginView_Previews: PreviewProvider {
    static var previews: some View {
        AnimationLoginView()
    }
}
