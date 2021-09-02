//
//  ContentView.swift
//  Learning-app
//
//  Created by wizz on 7/16/21.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        NavigationView{
            VStack(alignment: .leading){
                Text("What do you want to do today?")
                    .padding(.leading, 20)
                ScrollView{
                    LazyVStack{

                        ForEach(model.modules){ module in
                            VStack(spacing: 20){
                                NavigationLink(
                                    destination: ContentView().onAppear{
                                        model.beginModule(module.id)
                                    },
                                    tag: module.id,
                                    selection: $model.currentContentSelected,
                                    label: {
                                        HomeViewRow(image: module.content.image, title: "Learn \(module.category)", description: module.content.description, count: "\(module.content.lessons.count) Lessions", time: module.content.time)
                                    })
                                
                                //Test Card
                                NavigationLink(
                                    destination: TestView().onAppear(perform: {
                                        model.beginTest(module.id)
                                    }),
                                    tag: module.id,
                                    selection: $model.currentTestSelected,
                                    label: {
                                        
                                        HomeViewRow(image: module.test.image, title: "\(module.category) Test", description: module.test.description, count: "\(module.test.questions.count) Test", time: module.test.time)
                                    })
                                NavigationLink(
                                    destination: EmptyView(),
                                    label: {
                                        EmptyView()
                                    })
                                
                        }
                    }
                }
                .accentColor(.black)
                .padding()
            }
        }
        .navigationTitle("Get Started")
    }
}
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ContentModel())
    }
}
