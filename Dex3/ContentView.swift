//
//  ContentView.swift
//  Dex3
//
//  Created by NazarStf on 19.07.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
	
	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
		animation: .default) private var pokedex: FetchedResults<Pokemon>
	
	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
		predicate:  NSPredicate(format: "favorite = %d", true),
		animation: .default) private var favorites: FetchedResults<Pokemon>
	
	
	@State private var filterByFavorites = false
	@StateObject private var pokemonVM = PokemonViewModel(controller: FetchController())
	
	var body: some View {
//        switch pokemonVM.status {
//        case .success:
			NavigationStack {
				List(filterByFavorites ? favorites : pokedex) { pokemon in
					NavigationLink(value: pokemon) {
						AsyncImage(url: pokemon.sprite) { image in
							image
								.resizable()
								.scaledToFit()
						} placeholder: {
							ProgressView()
						}
						.frame(width: 100, height: 100)
						Text(pokemon.name!.capitalized)
						
						if pokemon.favorite {
							Image(systemName: "star.fill")
								.foregroundColor(.yellow)
						}
					}
				}
				.navigationTitle("Pokemon Dex")
				.navigationDestination(for: Pokemon.self, destination: { pokemon in
					PokemonDetail()
						.environmentObject(pokemon)
					
				})
				.toolbar {
					ToolbarItem(placement: .navigationBarTrailing) {
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
//        default:
//            ProgressView()
//        }
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
