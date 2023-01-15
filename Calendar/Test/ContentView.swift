//
//  ContentView.swift
//  Test
//
//  Created by Chen Yue on 15/01/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            CalendarView()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
