//
//  Persistence.swift
//  Dex3
//
//  Created by NazarStf on 19.07.2023.
//

import CoreData

// MARK: - Persistence Controller
// This struct is used for managing the app's Core Data stack
struct PersistenceController {

	// Shared instance of PersistenceController for use throughout the app
	static let shared = PersistenceController()
	
	// The NSPersistentContainer which sets up and manages the Core Data stack
	let container: NSPersistentContainer
	
	// A preconfigured instance of PersistenceController for use in previews and tests
	static var preview: PersistenceController = {
		let result = PersistenceController(inMemory: true)
		let viewContext = result.container.viewContext
		
		// Setup a sample Pokemon for previews
		let samplePokemon = Pokemon(context: viewContext)
		// Assign values to the Pokemon's properties
		samplePokemon.id = 1
		samplePokemon.name = "bulbasaur"
		samplePokemon.types = ["grass", "poison"]
		samplePokemon.hp = 45
		samplePokemon.attack = 49
		samplePokemon.defense = 49
		samplePokemon.specialAttack = 65
		samplePokemon.specialDefense = 65
		samplePokemon.speed = 45
		samplePokemon.sprite = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")
		samplePokemon.shiny = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/1.png")
		samplePokemon.favorite = false
		
		// Try to save the context, handle any error
		do {
			try viewContext.save()
		} catch {
			let nsError = error as NSError
			fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
		}
		return result
	}()
	
	// MARK: - Initializer
	// The initializer for this class, with an optional parameter to configure it for in-memory usage (e.g. for tests)
	init(inMemory: Bool = false) {
		container = NSPersistentContainer(name: "Dex3")
		
		// If the inMemory parameter is true, configure the persistent store to be in-memory
		if inMemory {
			container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
		} else {
			container.persistentStoreDescriptions.first!.url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.NS.Dex3Group")!.appending(path: "Dex3.sqlite")
		}
		
		// Load the persistent stores
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			// If there was an error loading the persistent stores, handle it
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		// Enable automatic merging of changes from the parent context
		container.viewContext.automaticallyMergesChangesFromParent = true
	}
}

