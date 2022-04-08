//
//  ContentView.swift
//  Learning-app
//
//  Created by wizz on 8/1/21.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        ScrollView{
            LazyVStack{
                if model.currentModule != nil {
                    ForEach(0..<model.currentModule!.content.lessons.count){ index in
                        
                        NavigationLink(
                            destination: ContentDetailView()
                                .onAppear{
                                    model.beignLession(index)
                                },
                            label: {
                                ContentViewRow(index: index)
                            })
                    }
                }
            }.accentColor(.black)
            .padding()
            .navigationBarTitle("Learn \(model.currentModule?.category ?? "")")
            
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
