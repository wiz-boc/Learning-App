//
//  ContentModel.swift
//  Learning-app
//
//  Created by wizz on 7/16/21.
//

import Foundation

class ContentModel: ObservableObject {
    @Published var modules = [Module]()
    var styleData: Data?
    
    init(){
        getLocalData()
    }
    
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
}
