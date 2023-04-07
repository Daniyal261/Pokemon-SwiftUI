//
//  WidgetPokemon.swift
//  Dex3
//
//  Created by Raja Adeel Ahmed on 4/8/23.
//

import SwiftUI

enum widgetSize {
    case small, medium, large
}

struct WidgetPokemon: View {
    @EnvironmentObject var pokemon:Pokemon
    let widgetSize: widgetSize
    
    var body: some View {
        ZStack {
            Color((pokemon.types?.first!.capitalized)!)
            switch widgetSize {
            case .small:
                //samll
                FetchedImage(url: pokemon.sprite)

            case .medium:
                //medium
                HStack {
                    FetchedImage(url: pokemon.sprite)
                    VStack (alignment: .leading) {
                        Text(pokemon.name!.capitalized)
                            .font(.title)
                        
                        Text((pokemon.types?.joined(separator: ", ").capitalized)!)
                    }
                    .padding(.trailing, 30)
                }

            case .large:
                //large
                FetchedImage(url: pokemon.sprite)
                VStack {
                    HStack {
                        Text(pokemon.name!.capitalized)
                            .font(.title)
                        Spacer()
                    }
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Text((pokemon.types?.joined(separator: ", ").capitalized)!)

                    }
                }
                .padding()
            }
        }
    }
}

struct WidgetPokemon_Previews: PreviewProvider {
    static var previews: some View {
        WidgetPokemon( widgetSize: .large)
            .environmentObject(SamplePokemon.samplePokemon)
    }
}
