//
//  ContentViewRow.swift
//  Learning-app
//
//  Created by wizz on 8/1/21.
//

import SwiftUI

struct ContentViewRow: View {
    
    @EnvironmentObject var model: ContentModel
    var index: Int
    
    var body: some View {
        let lession = model.currentModule!.content.lessons[index]
        ZStack(alignment: .leading){
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .frame(height: 66)
            
            HStack(spacing: 30){
                Text(String(index + 1))
                    .bold()
                VStack(alignment: .leading){
                    Text(lession.title)
                        .bold()
                    Text(lession.duration)
                        .font(.headline)
                }
            }
            .padding()
        }
        .padding(.bottom, 5)
    }
}


