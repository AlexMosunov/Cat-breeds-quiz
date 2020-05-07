//
//  DataManager.swift
//  Cat-breeds-Quiz
//
//  Created by Alex Mosunov on 02.05.2020.
//  Copyright © 2020 Alex Mosunov. All rights reserved.
//

import Foundation


protocol DataManagerDelegate {
    func didReceiveBreedsData(breed: BreedModel)
    func didReceiveBreedNames(breedNames: [String])
}

class DataManager {
    
    let breedsListURL = "https://api.thecatapi.com/v1/breeds"
    let breedURL = "https://api.thecatapi.com/v1/images/search?breed_ids"
    var arrayOfBreedModels: [BreedModel] = []
    var arrayOfCatNames: [String] = []
    
    var delegate: DataManagerDelegate?
    
    
    //MARK: - Fetching breeds IDs and Names
    
    func performRequest() {
        if let url = URL(string: breedsListURL) {
            var request = URLRequest(url: url)
            request.addValue( K.APIKey, forHTTPHeaderField: "x-api-key")
            request.httpMethod = "GET"
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("error request1 : \(error!.localizedDescription)")
                    return
                }
                if let safeData = data {
                    if let breeds = self.parseJSON(breedsList: safeData) {
                        
                        let (breedIDs, catNames) = breeds
                        // fetching each breed to get image
                        self.fetchBreed(breedIDs: breedIDs)
                        // passing all cat names to VC
                        self.delegate?.didReceiveBreedNames(breedNames: catNames)
                        
                    }
                }
            }
            
            task.resume()
        }
    }
    
    
    func parseJSON(breedsList: Data) -> ([String], [String])? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([BreedsList].self, from: breedsList)
            var arrayOfBreedIDs: [String] = []
            for breed in decodedData {
                let id = breed.id
                arrayOfBreedIDs.append(id)
                let name = breed.name
                arrayOfCatNames.append(name)
            }
            
            return (arrayOfBreedIDs, arrayOfCatNames)
            
        } catch {
            print("error parsing 1: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    //MARK: - fetching breed data and getting images
    
    func fetchBreed (breedIDs: [String]) {
        for breedID in breedIDs {
            let urlString = "\(breedURL)=\(breedID)"
            performRequest(with: urlString)
        }
    }
    
    
    func performRequest(with urlString: String) {
        
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.addValue( K.APIKey, forHTTPHeaderField: "x-api-key")
            request.httpMethod = "GET"
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("error request 2: \(error!.localizedDescription)")
                    return
                }
                if let safeData = data {
                    if let breed = self.parseJSON(breedData: safeData) {
                        
                        self.delegate?.didReceiveBreedsData(breed: breed)
                        self.arrayOfBreedModels.append(breed)
                        
                    }
                }
                
            }
            task.resume()
        }
    }
    
    
    func parseJSON(breedData: Data) -> BreedModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([BreedData].self, from: breedData)
            let url = decodedData[0].url
            let name = decodedData[0].breeds[0].name
            let temperament = decodedData[0].breeds[0].temperament
            let description = decodedData[0].breeds[0].description
            let wikipedia_url = decodedData[0].breeds[0].wikipedia_url
            
            let breed = BreedModel(name: name, temperament: temperament, description: description, url: url, wikipedia_url: wikipedia_url)
            
            return breed
            
        } catch {
            print("error parsing 2: \(error.localizedDescription)")
            return nil
        }
        
    }
    
    
    
    
    
    
}
