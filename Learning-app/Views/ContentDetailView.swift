//
//  ContentDetailView.swift
//  Learning-app
//
//  Created by wizz on 8/1/21.
//

import SwiftUI
import AVKit

struct ContentDetailView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        let lesson = model.currentLession
        let url = URL(string: Constants.videoHostUrl + (lesson?.video ?? ""))
        
        VStack{
            if url != nil {
                VideoPlayer(player: AVPlayer(url: url!))
            }
            //TODO: Description
            CodeTextView()
            //Next lesson button
            if  model.hasNextLesson() {
                Button(action: {
                    model.nextLession()
                }, label: {
                    ZStack{
                        RectangleCard(color: .green)
                            .frame(height: 48)
                        Text("Next Lesson: \(model.currentModule!.content.lessons[model.currentLessionIndex + 1].title)")
                            .bold()
                            .foregroundColor(.white)
                        
                    }
                })
            }
            else{
                Button(action: {
                    //Take the user back to the homeView
                    model.currentContentSelected = nil
                }, label: {
                    ZStack{
                        Rectangle()
                            .foregroundColor(Color.green)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .frame(height: 48)
                        
                        Text("Complete")
                            .bold()
                            .foregroundColor(.white)
                        
                    }
                })
            }
        }
        .padding()
        .navigationTitle(lesson?.title ?? "")
    }
    
    
}

struct ContentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentDetailView()
    }
}
