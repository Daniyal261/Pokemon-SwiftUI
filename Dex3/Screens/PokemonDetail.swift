//
//  PokemonDetail.swift
//  Dex3
//
//  Created by Raja Adeel Ahmed on 4/8/23.
//

import SwiftUI
import CoreData

struct PokemonDetail: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var pokemon: Pokemon
    @State var showShiny = false
    var body: some View {
        ScrollView {
            ZStack {
                Image(pokemon.background)
                    .resizable()
                    .scaledToFit()
                    .shadow(color: .black,radius: 6)
                
                AsyncImage(url: showShiny ? pokemon.shiny : pokemon.sprite) { phase in
                    switch phase {
                    case .empty:
                        // show placeholder or loading view
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .padding(.top, 50)
                            .shadow(color: .black, radius: 6)
                    case .failure(_):
                        // show error view
                        Image(systemName: "error")
                    @unknown default:
                        // handle unknown case
                        fatalError()
                    }
                }
            }
            
            HStack {
                ForEach(pokemon.types!, id: \.self) { type in
                    Text(type.capitalized)
                        .font(.title2)
                        .shadow(color:.white, radius: 1)
                        .padding([.top,.bottom], 7)
                        .padding([.leading, .trailing])
                        .background(Color(type.capitalized))
                        .cornerRadius(50)
                    
                }
                Spacer()
                Button {
                    withAnimation {
                        pokemon.isFavorite.toggle()
                        do {
                            try viewContext.save()
                        } catch {
                            let errorD = error as NSError
                            fatalError("\(errorD)")
                        }
                    }
                    
                } label: {
                    if pokemon.isFavorite {
                        Image(systemName: "star.fill")
                    } else {
                        Image(systemName: "star")
                    }
                }
                .font(.largeTitle)
                .foregroundColor(.yellow)

            }
            .padding()
            
            Text("Stats")
                .font(.title)
                .padding(.bottom, -7)
            
            StatsView()
                .environmentObject(pokemon)
        }
        .navigationTitle(pokemon.name!.capitalized)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showShiny.toggle()
                } label: {
                    showShiny ? Image(systemName: "wand.and.stars") : Image(systemName: "wand.and.stars.inverse")
                }
            }
        }
    }
}

struct PokemonDetail_Previews: PreviewProvider {
    static var previews: some View {
        
        
        return PokemonDetail()
            .environmentObject(SamplePokemon.samplePokemon)
    }
}
