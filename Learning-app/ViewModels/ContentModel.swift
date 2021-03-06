//
//  ContentModel.swift
//  Learning-app
//
//  Created by wizz on 7/16/21.
//

import Foundation

class ContentModel: ObservableObject {
    @Published var modules = [Module]()
    //Current module
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    //Current lesson
    @Published var currentLession: Lesson?
    var currentLessionIndex = 0
    //Current question
    @Published var currentQuestion: Question?
    var currentQuestionIndex = 0
    
    
    //Current lesson explanation
    @Published var codeText = NSAttributedString()
    
    var styleData: Data?
    
    //Current selected content and test
    @Published var currentContentSelected: Int?
    @Published var currentTestSelected: Int?
    
    init(){
        //Parse local included json data
        getLocalData()
        //Down remote json file and parse data
        getRemoteData()
    }
    
    //MARK:- Data methods
    func getLocalData(){
        //Get a url to the json file
        guard let jsonURL = Bundle.main.url(forResource: "data", withExtension: "json") else { return }
        
        do{
            //Read the file into a data object
            let jsonData = try Data(contentsOf: jsonURL)
            let jsonDecoder = JSONDecoder()
            //Try to decode the json
            let modules = try jsonDecoder.decode([Module].self, from: jsonData)
            self.modules = modules
        }catch{
            print(error)
        }
        
        //Parse the style data
        guard let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html") else { return }
        do{
            let styleData = try Data(contentsOf: styleUrl)
            self.styleData = styleData
        }catch{
            print(error)
        }
    }
    
    func getRemoteData(){
        let urlString = "https://wiz-boc.github.io/learningapp-data/data2.json"
        let url = URL(string: urlString)
        guard url != nil else { return }
        
        let request = URLRequest(url: url!)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, response, error in
            //Check if there's an error
            guard error == nil else {
                //There was an error
                return
            }
            guard data != nil else {
                //There was an error
                return
            }
            do{
                let decoder = JSONDecoder()
                let modules = try decoder.decode([Module].self, from: data!)
                
                DispatchQueue.main.async {
                    self.modules += modules
                }
                
            }catch{
                print(error)
            }
            
        }
        dataTask.resume()
        
        
    }
    
    //MARK: - Module navigation methods
    
    func beginModule(_ moduleid: Int){
        //FInd the index for this module id
        for index in 0..<modules.count {
            if modules[index].id == moduleid {
                currentModuleIndex = index
                break
            }
        }
        
        //Set the current module
        currentModule = modules[currentModuleIndex]
        
    }
    
    func beignLession(_ lessonIndex:Int){
        //Check that the lesson index is within range of module lessions
        
        if lessonIndex < currentModule!.content.lessons.count {
            currentLessionIndex = lessonIndex
        }else{
            currentLessionIndex = 0
        }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.currentLession = self.currentModule!.content.lessons[self.currentLessionIndex]
            self.codeText = self.addStyling(self.currentLession!.explanation)
        }
    }
    
    func hasNextLesson() -> Bool {
        guard currentModule != nil else { return false }
        return currentLessionIndex + 1 < currentModule!.content.lessons.count
    }
    
    func beginTest(_ moduledId: Int){
        //Set the current module
        beginModule(moduledId)
        //Set the current question
        currentQuestionIndex = 0
        
        //If there question set the question to the first one
        if currentModule?.test.questions.count ?? 0 > 0 {
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
        }
    }
    
    func nextQuestion() {
        //Advance next question
        currentQuestionIndex += 1
        
        if currentQuestionIndex < currentModule!.test.questions.count {
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
        }else{
            currentQuestionIndex = 0
            currentQuestion = nil
        }
        
    }
    
    
    func nextLession() {
        //Adance the lesson index
        currentLessionIndex += 1
        
        //Check that it is within range
        if currentLessionIndex < currentModule!.content.lessons.count {
            //Set the current lesson property
            currentLession = currentModule!.content.lessons[currentLessionIndex]
            codeText = addStyling(currentLession!.explanation)
        }else{
            //Reset the lesson state
            currentLessionIndex = 0
            currentLession =  nil
            codeText = NSAttributedString()
        }
       
    }
    
    //MARK:- Code styling
    
    private func addStyling(_ htmlString: String) -> NSAttributedString {
        var resultString = NSAttributedString()
        var data = Data()
        //Add the styling data
        if styleData != nil {
            data.append(self.styleData!)
        }
        //Add the html data
        data.append(Data(htmlString.utf8))
        
        //Convert to attributed string
        
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType:NSAttributedString.DocumentType.html], documentAttributes: nil){
            resultString = attributedString
        }
        
        return resultString
    }
}
