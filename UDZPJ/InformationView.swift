//
//  InformationView.swift
//  UDZPJ
//
//  Created by Jeremiah Korreck on 2/3/24.
//

import SwiftUI

struct InformationView: View {
    var body: some View {
        Text("Unofficial Detroit Zoo Photo Journal\n")
            .bold()
            .padding(20)
            .underline()
        Text("Written By: Jeremiah Korreck\n\n")
        Text("Animal facts written by chatGPT 3.5\n")
            .padding(10)
        Text("This app is an experiment in getting a working image classifier to correctly label all the animals on the map of Detroit Zoo.")
            .padding(10)
        Spacer()
    }
}

#Preview {
    InformationView()
}
