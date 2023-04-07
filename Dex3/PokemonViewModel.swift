//
//  PokemonViewModel.swift
//  Dex3
//
//  Created by Raja Adeel Ahmed on 4/7/23.
//

import Foundation

@MainActor
class PokemonViewModel: ObservableObject {
    enum Status {
        case notStarted
        case fetching
        case success
        case failed(error:Error)
    }
    
    @Published private(set) var status = Status.notStarted
    
    private let controller: FetchController
    
    init(controller:FetchController) {
        self.controller = controller
        Task {
            await getPokemon()
        }
    }
    
    private func getPokemon() async {
        status = .fetching
        
        do {
            guard var pokedex = try await controller.fetchAllPokemon() else {
                status = .success
                print("Pokemon are already in DB")
                return
            }
            pokedex.sort { $0.id < $1.id}
            for pokemon in pokedex {
                let newPokemon = Pokemon(context:PersistenceController.shared.container.viewContext)
                newPokemon.id = Int16(pokemon.id)
                newPokemon.attack = Int16(pokemon.attack)
                newPokemon.name = pokemon.name
                newPokemon.types = pokemon.types
                newPokemon.organizeType()
                newPokemon.hp = Int16(pokemon.hp)
                newPokemon.defence = Int16(pokemon.defence)
                newPokemon.specialAttack = Int16(pokemon.specialAttack)
                newPokemon.specialDefence = Int16(pokemon.specialDefence)
                newPokemon.shiny = pokemon.shiny
                newPokemon.speed = Int16(pokemon.speed)
                newPokemon.sprite = pokemon.sprite
                newPokemon.isFavorite = false
                
                try PersistenceController.shared.container.viewContext.save()
            }
            
            status = .success
        } catch {
            status = .failed(error: error)
        }
    }
}
