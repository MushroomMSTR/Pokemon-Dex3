//
//  PokemonViewModel.swift
//  Dex3
//
//  Created by NazarStf on 20.07.2023.
//

import Foundation

// MainActor to ensure that the changes to the @Published properties are performed on the main thread
@MainActor
class PokemonViewModel: ObservableObject {
	
	// MARK: - Status Enum
	// Represents the different states that fetching the Pokemon can be in
	enum Status {
		case notStarted
		case fetching
		case success
		case failed(error: Error)
	}
	
	// Published property for the status, will automatically notify the view when changed
	@Published private(set) var status = Status.notStarted
	
	// MARK: - Properties
	private let controller: FetchController
	
	// MARK: - Initializer
	init(controller: FetchController){
		self.controller = controller
		
		// Starts fetching the Pokemon as soon as the ViewModel is created
		Task{
			await getPokemon()
		}
	}
	
	// MARK: - Fetch Pokemon
	private func getPokemon() async {
		// Set the status to fetching at the start
		status = .fetching
		
		do {
			// Fetch all the Pokemon from the controller
			guard var pokeDex = try await controller.fetchAllPokemon() else {
				print("using core data pokemon")
				status = .success
				return
			}
			
			// Sort the fetched Pokemon by id
			pokeDex.sort{$0.id < $1.id}
			
			// Loop through the fetched Pokemon
			for pokemon in pokeDex {
				// Create a new Pokemon in the CoreData context
				let newPokemon = Pokemon(context: PersistenceController.shared.container.viewContext)
				newPokemon.id = Int16(pokemon.id)
				newPokemon.name = pokemon.name
				newPokemon.types = pokemon.types
				newPokemon.organizeTypes()
				newPokemon.hp = Int16(pokemon.hp)
				newPokemon.attack = Int16(pokemon.attack)
				newPokemon.defense = Int16(pokemon.defense)
				newPokemon.specialAttack = Int16(pokemon.specialAttack)
				newPokemon.specialDefense = Int16(pokemon.specialDefense)
				newPokemon.speed = Int16(pokemon.speed)
				newPokemon.sprite = pokemon.sprite
				newPokemon.shiny = pokemon.shiny
				newPokemon.favorite = false
				
				// Save the new Pokemon to the CoreData context
				try PersistenceController.shared.container.viewContext.save()
			}
			// Set the status to success after all Pokemon have been fetched and saved
			status = .success
		} catch {
			// If there was an error fetching the Pokemon, set the status to failed and store the error
			status = .failed(error: error)
		}
	}
}
