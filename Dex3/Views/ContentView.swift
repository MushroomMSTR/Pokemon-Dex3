//
//  ContentView.swift
//  Dex3
//
//  Created by NazarStf on 19.07.2023.
//

import SwiftUI
import CoreData

// MARK: - ContentView
struct ContentView: View {
	
	// FetchRequest to get all Pokemon, sorted by ID
	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
		animation: .default) private var pokedex: FetchedResults<Pokemon>
	
	// FetchRequest to get all favorite Pokemon, sorted by ID
	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
		predicate:  NSPredicate(format: "favorite = %d", true),
		animation: .default) private var favorites: FetchedResults<Pokemon>
	
	// State to toggle between all Pokemon and favorites
	@State private var filterByFavorites = false
	// ViewModel to handle fetching Pokemon
	@StateObject private var pokemonVM = PokemonViewModel(controller: FetchController())
	
	// MARK: - Body
	var body: some View {
		// NavigationStack contains all Pokemon or favorites, depending on the toggle
		NavigationStack {
			List(filterByFavorites ? favorites : pokedex) { pokemon in
				// Each Pokemon is represented by an image and its name
				NavigationLink(value: pokemon) {
					// Asynchronously loads the Pokemon's sprite
					AsyncImage(url: pokemon.sprite) { image in
						image
							.resizable()
							.scaledToFit()
					} placeholder: {
						ProgressView()
					}
					.frame(width: 100, height: 100)
					Text(pokemon.name!.capitalized)
					
					// If the Pokemon is a favorite, show a filled star
					if pokemon.favorite {
						Image(systemName: "star.fill")
							.foregroundColor(.yellow)
					}
				}
			}
			// Navigation title and toolbar
			.navigationTitle("Pokemon Dex")
			.navigationDestination(for: Pokemon.self, destination: { pokemon in
				PokemonDetail()
					.environmentObject(pokemon)
				
			})
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					// Button toggles the filterByFavorites state
					Button{
						withAnimation{
							filterByFavorites.toggle()
						}
					} label: {
						Label("Filter By Favorites", systemImage: filterByFavorites ? "star.fill" : "star")
					}
					.font(.title2)
					.foregroundColor(.yellow)
				}
			}
		}
	}
}

// MARK: - Previews
struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
