//
//  PokemonDetail.swift
//  Dex3
//
//  Created by NazarStf on 20.07.2023.
//

import SwiftUI
import CoreData

struct PokemonDetail: View {
	
	@EnvironmentObject var pokemon: Pokemon
	@State var showShiny = false
	
    var body: some View {
		ScrollView {
			ZStack {
				Image("normalgrasselectricpoisonfairy")
					.resizable()
					.scaledToFit()
					.shadow(color: .black,radius: 6)
				
				AsyncImage(url: showShiny ? pokemon.shiny : pokemon.sprite) { image in
					image
						.resizable()
						.scaledToFit()
						.padding(.top, 50)
						.shadow(color: .black, radius: 6)
				} placeholder: {
					ProgressView()
				}
			}
			
			HStack {
				ForEach(pokemon.types!, id: \.self) { type in
					Text(type.capitalized)
						.font(.title2)
						.shadow(color: .white, radius: 1)
						.padding([.top, .bottom], 7)
						.padding([.leading, .trailing])
						.background(Color(type.capitalized))
						.cornerRadius(50)
				}
				
				Spacer()
			}
			.padding()
		}
		.navigationTitle(pokemon.name!.capitalized)
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button {
					showShiny.toggle()
				} label: {
					if showShiny {
						Image(systemName: "wand.and.stars")
							.foregroundColor(.yellow)
					} else {
						Image(systemName: "wand.ad.stars.inverse")
					}
				}
			}
		}
    }
}

struct PokemonDetail_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetail()
			.environmentObject(SamplePokemon.samplePokemon)
    }
}
