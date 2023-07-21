//
//  FetchController.swift
//  Dex3
//
//  Created by NazarStf on 20.07.2023.
//

import Foundation
import CoreData

struct FetchController {
	
	// MARK: - Network Error Enum
	// Represents the different types of errors that can occur when fetching Pokemon
	enum NetworkError: Error {
		case badURL, badResponse, badData
	}
	
	// MARK: - Properties
	// The base URL for the Pokemon API
	private let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
	
	// MARK: - Fetch All Pokemon
	func fetchAllPokemon() async throws -> [TempPokemon]? {
		
		// Check if the Pokemon already exist in the database
		if havePokemon() {
			return nil
		}
		
		var allPokemon: [TempPokemon] = []
		
		// Prepare the URL for the API request
		var fetchComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
		fetchComponents?.queryItems = [URLQueryItem(name: "limit", value: "386")]
		
		guard let fetchURL = fetchComponents?.url else {
			throw NetworkError.badURL
		}
		
		// Make the API request
		let (data, response) = try await URLSession.shared.data(from: fetchURL)
		
		// Check the response status
		guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
			throw NetworkError.badResponse
		}
		
		// Decode the response data
		guard let pokeDictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any], let pokedex = pokeDictionary["results"] as? [[String: String]] else {
			throw NetworkError.badData
		}
		
		// Fetch each Pokemon from the pokedex
		for pokemon in pokedex {
			if let url = pokemon["url"] {
				allPokemon.append(try await fetchPokemon(from: URL(string: url)!))
			}
		}
		
		return allPokemon
	}
	
	// MARK: - Fetch Single Pokemon
	private func fetchPokemon(from url: URL) async throws -> TempPokemon {
		// Make the API request
		let (data, response) = try await URLSession.shared.data(from: url)
		
		// Check the response status
		guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
			throw NetworkError.badResponse
		}
		
		// Decode the response data into a TempPokemon object
		let tempPokemon = try JSONDecoder().decode(TempPokemon.self, from: data)
		
		print("Fetched \(tempPokemon.id): \(tempPokemon.name)")
		
		return tempPokemon
	}
	
	// MARK: - Check Database for Pokemon
	private func havePokemon() -> Bool{
		// Create a new background context for CoreData
		let context = PersistenceController.shared.container.newBackgroundContext()
		
		// Prepare a fetch request for Pokemon with specific ids
		let fetchRequest: NSFetchRequest<Pokemon>  = Pokemon.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "id IN %@", [1, 386])
		
		do{
			// Attempt to fetch the Pokemon
			let checkPokemon = try context.fetch(fetchRequest)
			
			// If both Pokemon were found, return true
			if checkPokemon.count == 2 {
				return true
			}
		}catch{
			print("fetch faild: \(error)")
			return false
		}
		return false
	}
}
