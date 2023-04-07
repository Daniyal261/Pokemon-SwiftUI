//
//  FetchedImage.swift
//  Dex3
//
//  Created by Raja Adeel Ahmed on 4/8/23.
//

import SwiftUI

struct FetchedImage: View {
    
    let url: URL?
    
    var body: some View {
        if let url, let imageData = try? Data(contentsOf: url), let uiimage = UIImage(data: imageData) {
            Image(uiImage: uiimage)
                .resizable()
                .scaledToFit()
                .shadow(color: .black, radius: 6)
        } else {
            Image("bulbasaur")
        }
    }
}

struct FetchedImage_Previews: PreviewProvider {
    static var previews: some View {
        FetchedImage(url: SamplePokemon.samplePokemon.sprite)
    }
}
