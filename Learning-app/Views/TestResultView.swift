//
//  TestResultView.swift
//  Learning-app
//
//  Created by wizz on 9/4/21.
//

import SwiftUI

struct TestResultView: View {
    
    @EnvironmentObject var model: ContentModel
    var numCorrect: Int
    
    var body: some View {
        VStack{
            Spacer()
            Text(resultHeading)
                .bold()
                .font(.title)
            Spacer()
            Text("You got \(numCorrect) out of \(model.currentModule?.test.questions.count ?? 0) questions")
            Spacer()
            Button{
                //Send the user back to the home view
                model.currentTestSelected = nil
            } label: {
                ZStack{
                    RectangleCard(color: .green)
                        .frame(height: 48)
                    
                    Text("Complete")
                        .bold()
                        .foregroundColor(.white)
                }
            }.padding()
            Spacer()
        }
    }
    
    var resultHeading: String {
        let pct = Double(numCorrect) / Double(model.currentModule!.test.questions.count)
        if pct > 0.5 {
            return "Awesome!"
        }else if pct > 0.2 {
            return "Awesome!"
        }else {
            return "keep learning"
        }
    }
}

struct TestResultView_Previews: PreviewProvider {
    static var previews: some View {
        TestResultView(numCorrect: 0)
    }
}
