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
    
    //Current lesson explanation
    @Published var lessonDescription = NSAttributedString()
    
    var styleData: Data?
    
    //Current selected content and test
    @Published var currentContentSelected: Int?
    
    init(){
        getLocalData()
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
        
        currentLession = currentModule!.content.lessons[currentLessionIndex]
        lessonDescription = addStyling(currentLession!.explanation)
    }
    
    func hasNextLesson() -> Bool {
        return currentLessionIndex + 1 < currentModule!.content.lessons.count
    }
    
    func nextLession() {
        //Adance the lesson index
        currentLessionIndex += 1
        
        //Check that it is within range
        if currentLessionIndex < currentModule!.content.lessons.count {
            //Set the current lesson property
            currentLession = currentModule!.content.lessons[currentLessionIndex]
            lessonDescription = addStyling(currentLession!.explanation)
        }else{
            //Reset the lesson state
            currentLessionIndex = 0
            currentLession =  nil
            lessonDescription = NSAttributedString()
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
