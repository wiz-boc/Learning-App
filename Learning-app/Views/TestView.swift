//
//  TestView.swift
//  Learning-app
//
//  Created by wizz on 9/1/21.
//

import SwiftUI

struct TestView: View {
    
    @EnvironmentObject var model:ContentModel
    @State var selectedAnswerIndex: Int?
    @State var numCorrect = 0
    @State var submitted = false
    @State var showResults = false
    
    var body: some View {
        if model.currentQuestion != nil && showResults == false {
            VStack(alignment: .leading){
                //Question number
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                    .padding(.leading, 20)

                //Question
                CodeTextView()
                    .padding(.leading, 20)

                //Answer
                ScrollView{
                    VStack {
                        ForEach(0..<model.currentQuestion!.answers.count, id: \.self){
                            index in
                            
                            
                            Button{
                                // track the selected index
                                selectedAnswerIndex = index
                            }label: {
                                ZStack{
                                    if submitted == false{
                                        RectangleCard(color: index == selectedAnswerIndex ? .gray : .white)
                                            .frame(height: 48)
                                    }else{
                                        if (index == selectedAnswerIndex && index == model.currentQuestion!.correctIndex) {
                                            
                                            //User selected the correct answer
                                            RectangleCard(color: .green)
                                                .frame(height: 48)
                                        }else if index == selectedAnswerIndex{
                                            //User selected the wrong answer
                                            RectangleCard(color: .red)
                                                .frame(height: 48)
                                        }else if index == model.currentQuestion!.correctIndex {
                                            RectangleCard(color: .green)
                                                .frame(height: 48)
                                        }else {
                                            RectangleCard(color: .white)
                                                .frame(height: 48)
                                        }
                                    }
                                    Text(model.currentQuestion!.answers[index])
                                }
                                
                            }.disabled(submitted)
                        }
                    }
                    .accentColor(.black)
                    .padding()
                }

                //Button
                Button(action: {
                    
                    if submitted == true {
                        
                        //Check if its the last question
                        if model.currentQuestionIndex + 1 == model.currentModule!.test.questions.count {
                            showResults = true
                        }else{
                            model.nextQuestion()
                            //Reset properties
                            submitted = false
                            selectedAnswerIndex = nil
                        }
                        
                        
                    }else{
                        submitted = true
                        if selectedAnswerIndex == model.currentQuestion!.correctIndex {
                            numCorrect += 1
                        }
                    }
                }, label: {
                    ZStack{
                        RectangleCard(color: .green)
                            .frame(height: 48)
                        Text(buttonText)
                            .bold()
                            .foregroundColor(.white)
                    }
                    .padding()
                })
                .disabled(selectedAnswerIndex == nil)
            }
            .navigationBarTitle("\(model.currentModule?.category ?? "") Test ")
        }else if showResults == true {
            TestResultView(numCorrect: numCorrect)
        }else {
            ProgressView()
        }
    }
    
    var buttonText:String {
        //Check if answer has been sumbmitted
        if submitted == true {
            if model.currentQuestionIndex + 1 == model.currentModule!.test.questions.count {
                return "Finish" // or finish
            }else{
                return "Next" // or finish
            }
        }else{
            return "Submit"
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
