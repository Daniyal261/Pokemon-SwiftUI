//
//  FetchController.swift
//  Dex3
//
//  Created by Raja Adeel Ahmed on 4/7/23.
//

import Foundation
import CoreData

struct FetchController {
    enum NetworkError: Error {
        case badURL, badResponse, badData
    }
    
    private let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
    
    func fetchAllPokemon() async throws -> [TempPokemon]? {
        
        if havePokemon() {
            return nil
        }
        
        var allPokemon: [TempPokemon] = []
        
        var fetchComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        fetchComponents?.queryItems = [URLQueryItem(name: "limit", value: "386")]
        guard let fetchURL = fetchComponents?.url else {
            throw NetworkError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        
        guard let pokeDictionary = try JSONSerialization.jsonObject(with: data) as? [String:Any], let pokedex = pokeDictionary["results"] as? [[String:String]] else {
            throw NetworkError.badData
        }
        
        for pokemon in pokedex {
            if let url = pokemon["url"] {
                print( "\(String(describing: pokemon["name"])) \(String(describing: pokemon["url"]))" )
                allPokemon.append(try await fetchPokemon(from: URL(string: url)!))
            }
        }
        
        return allPokemon
    }
    
    private func fetchPokemon(from url:URL) async throws -> TempPokemon {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        
        var tempPokemon:TempPokemon!
        do {
             tempPokemon = try JSONDecoder().decode(TempPokemon.self, from: data)
            // use tempPokemon object
        } catch let error as DecodingError {
            switch error {
            case .dataCorrupted(let context):
                print("Data corrupted: \(context)")
            case .keyNotFound(let key, let context):
                print("Key not found: \(key), \(context)")
            case .typeMismatch(let type, let context):
                print("Type mismatch: \(type), \(context)")
            case .valueNotFound(let value, let context):
                print("Value not found: \(value), \(context)")
            @unknown default:
                print("Unknown error: \(error.localizedDescription)")
            }
        } catch {
            print("Unknown error: \(error.localizedDescription)")
        }
        //let tempPokemon = try JSONDecoder().decode(TempPokemon.self, from: data)
        
        print("fetched pokemon \(tempPokemon)")
        
        return tempPokemon
    }
    
    private func havePokemon() ->Bool {
        
        let context = PersistenceController.shared.container.newBackgroundContext()
        
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "id in %@", [1, 386])
        
        do {
            let checkPokemon = try context.fetch(fetchRequest)
            if checkPokemon.count  == 2 {
                return true 
            }
        } catch {
            return false
        }
        
        return false
    }
}
