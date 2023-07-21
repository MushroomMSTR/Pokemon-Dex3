//  PokemonDetail.swift
//  Dex3
//
//  Created by NazarStf on 20.07.2023.
//

import SwiftUI
import CoreData

// MARK: - PokemonDetail
struct PokemonDetail: View {
	
	// Core Data view context
	@Environment(\.managedObjectContext) private var viewContext
	// Current Pokemon object
	@EnvironmentObject var pokemon: Pokemon
	// State for switching between shiny and regular sprite
	@State var showShiny = false
	
	// MARK: - Body
	var body: some View {
		// Scrollable layout for the Pokemon details
		ScrollView {
			// Stack for the Pokemon sprite and background
			ZStack {
				// Background image
				Image(pokemon.background)
					.resizable()
					.scaledToFit()
					.shadow(color: .black,radius: 6)
				
				// Async image for shiny/regular sprite
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
			
			// Horizontal stack for the Pokemon types and favorite button
			HStack {
				// For each type, display a colored label
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
				
				// Button for favoriting Pokemon
				Button{
					withAnimation {
						pokemon.favorite.toggle()
						
						do {
							try viewContext.save()
						} catch {
							let nsError = error as NSError
							fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
						}
					}
				} label: {
					if pokemon.favorite {
						Image(systemName: "star.fill")
					} else {
						Image(systemName: "star")
					}
				}
				.font(.largeTitle)
				.foregroundColor(.yellow)
			}
			.padding()
			
			// Title for the stats section
			Text("Stats")
				.font(.title)
				.padding(.bottom, -10)
			
			// Stats view
			Stats()
				.environmentObject(pokemon)
		}
		// Navigation title and toolbar
		.navigationTitle(pokemon.name!.capitalized)
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				// Button for toggling shiny/regular sprite
				Button {
					showShiny.toggle()
				} label: {
					if showShiny {
						Image(systemName: "wand.and.stars")
							.foregroundColor(.yellow)
					} else {
						Image(systemName: "wand.and.stars.inverse")
					}
				}
			}
		}
	}
}

// MARK: - Previews
struct PokemonDetail_Previews: PreviewProvider {
	static var previews: some View {
		PokemonDetail()
			.environmentObject(SamplePokemon.samplePokemon)
	}
}
