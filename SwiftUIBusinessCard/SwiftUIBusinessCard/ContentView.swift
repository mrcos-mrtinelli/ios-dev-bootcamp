//
//  ContentView.swift
//  SwiftUIBusinessCard
//
//  Created by Marcos Martinelli on 3/7/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(
                    colors: [Color(red: 0.10, green: 0.45, blue: 0.91, opacity: 1), Color.white]),
                startPoint: .bottom,
                endPoint: .top)
                    .edgesIgnoringSafeArea(.all)
            VStack {
                Image("swiftui")
                Text("SwiftUI")
                    .bold()
                    .padding()
                    .font(Font.custom("Fugaz One", size: 40))
                    .foregroundColor(.white)
                Text("iOS Developer")
                    .foregroundColor(.white)
                    .font(.system(size: 25))
    
                InfoView(text: "+1 999 234 7564", imageName: "phone.circle.fill")
                InfoView(text: "email@email.com", imageName: "envelope.fill")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
