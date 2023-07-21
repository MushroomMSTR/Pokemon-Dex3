//
//  SamplePokemon.swift
//  Dex3
//
//  Created by NazarStf on 20.07.2023.
//

import Foundation
import CoreData

// MARK: - SamplePokemon

// This struct represents a sample Pokémon for use in SwiftUI previews and for testing.
struct SamplePokemon {
	// This static property returns a sample Pokémon from the CoreData view context.
	static let samplePokemon = {
		// MARK: - Setup Context

		// This is the view context from the CoreData container.
		let context = PersistenceController.preview.container.viewContext

		// MARK: - Fetch Request

		// This is a fetch request to get a Pokémon from CoreData.
		let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()

		// We're only fetching one Pokémon.
		fetchRequest.fetchLimit = 1

		// MARK: - Fetch Pokémon

		// Fetch the Pokémon from CoreData and return the first one.
		// If there is a problem with fetching, this will cause a runtime error.
		let results = try! context.fetch(fetchRequest)

		// Return the first Pokémon from the results.
		return results.first!
	}()
}
