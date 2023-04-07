//
//  TempPokemon.swift
//  Dex3
//
//  Created by Raja Adeel Ahmed on 4/7/23.
//

import Foundation

struct TempPokemon: Codable {
    let id: Int
    let name: String
    let types: [String]
    var hp = 0
    var attack = 0
    var defence = 0
    var specialAttack = 0
    var specialDefence = 0
    var speed = 0
    let sprite: URL
    let shiny: URL

    enum PokemonKeys: String, CodingKey {
        case id
        case name
        case types
        case stats
        case sprites
        
        enum TypeDictionaryKeys:String , CodingKey {
            case type
            enum TypeKeys: String, CodingKey {
                case name
            }
        }
        
        enum StatDictionaryKeys: String, CodingKey {
            case value = "base_stat"
            case stat

            enum StatKey: String, CodingKey {
                case name
            }
        }
        
        enum SpriteKeys:String, CodingKey {
            case sprite = "front_default"
            case shiny = "front_shiny"
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PokemonKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
        var decodedTypes: [String] = []
        var typesContainer = try container.nestedUnkeyedContainer(forKey: .types)
        while !typesContainer.isAtEnd {
            let typeDictionaryContainer = try typesContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.self)
            let typeContainer = try typeDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.TypeKeys.self, forKey: .type)
            let type  = try typeContainer.decode(String.self, forKey: .name)
            decodedTypes.append(type)
        }
        
        types = decodedTypes
        
        var statsContainer = try container.nestedUnkeyedContainer(forKey: .stats)
        while !statsContainer.isAtEnd {
            let statsDictionaryContainer = try statsContainer.nestedContainer(keyedBy: PokemonKeys.StatDictionaryKeys.self)
            let statContainer = try statsDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.StatDictionaryKeys.StatKey.self, forKey: .stat)
            switch try statContainer.decode(String.self, forKey: .name) {
            case "hp":
                hp = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "attack":
                attack = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "defence":
                defence = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "special-attack":
                specialAttack = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "special-defense":
                specialDefence = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "speed":
                speed = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            default:
                break
            }
        }
        
        let spriteContainer = try container.nestedContainer(keyedBy: PokemonKeys.SpriteKeys.self, forKey: .sprites)
        sprite = try spriteContainer.decode(URL.self, forKey: .sprite)
        shiny = try spriteContainer.decode(URL.self, forKey: .shiny)
        
        
    }
    
}


//JSON
//abilities
//base_experience : 64
//forms
//game_indices
//height : 7
//held_items
//id : 1
//is_default : true
//location_area_encounters : "https://pokeapi.co/api/v2/pokemon/1/encounters"
//moves
//name : "bulbasaur"
//order : 1
//past_types
//species
//sprites
//back_default : "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png"
//back_female : null
//back_shiny : "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/1.png"
//back_shiny_female : null
//front_default : "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png"
//front_female : null
//front_shiny : "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/1.png"
//front_shiny_female : null
//other
//versions
//stats
//0
//base_stat : 45
//effort : 0
//stat
//name : "hp"
//url : "https://pokeapi.co/api/v2/stat/1/"
//1
//2
//3
//4
//5
//types
//0
//slot : 1
//type
//name : "grass"
//url : "https://pokeapi.co/api/v2/type/12/"
//1
//weight : 69
