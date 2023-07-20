//
//  SamplePokemon.swift
//  Dex3
//
//  Created by NazarStf on 20.07.2023.
//

import Foundation
import CoreData

struct SamplePokemon {
	static let samplePokemon = {
		let context = PersistenceController.preview.container.viewContext
		
		let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
		fetchRequest.fetchLimit = 1
		
		let results = try! context.fetch(fetchRequest)
		
		return results.first!
	}()
}
