//
//  TempPokemon.swift
//  Dex3
//
//  Created by NazarStf on 19.07.2023.
//

import Foundation

// MARK: - TempPokemon

// This struct is a temporary model for decoding the Pokemon data from the API.
// It holds all the necessary fields required by the application.
struct TempPokemon: Codable {
	
	// Basic details
	let id: Int
	let name: String
	let types: [String]
	
	// Stat attributes
	var hp = 0
	var attack = 0
	var defense = 0
	var specialAttack = 0
	var specialDefense = 0
	var speed = 0
	
	// Image URLs
	let sprite: URL
	let shiny: URL
	
	// MARK: - Coding Keys
	
	// The PokemonKeys enumeration is used to map the JSON keys to Swift variable names.
	enum PokemonKeys: String, CodingKey {
		case id
		case name
		case types
		case stats
		case sprites
		
		// Nested keys for the type
		enum TypeDictionaryKeys: String, CodingKey {
			case type
			
			enum TypeKeys: String, CodingKey {
				case name
			}
		}
		
		// Nested keys for the stats
		enum StatDictionaryKeys: String, CodingKey {
			case value = "base_stat"
			case stat
				
			enum StatKeys: String, CodingKey {
				case name
			}
		}
		
		// Nested keys for the sprites
		enum SpriteKeys: String, CodingKey {
			case sprite = "front_default"
			case shiny = "front_shiny"
		}
	}
	
	// MARK: - Initializer
	
	// Custom initializer for decoding from a JSON object.
	// This initializer manually decodes each nested structure in the JSON.
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: PokemonKeys.self)
		
		// Decode the simple properties
		id = try container.decode(Int.self, forKey: .id)
		name = try container.decode(String.self, forKey: .name)
		
		// Decode the array of types
		var decodedTypes: [String] = []
		var typesContainer = try container.nestedUnkeyedContainer(forKey: .types)
		while !typesContainer.isAtEnd {
			let typesDictionaryContainer = try typesContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.self)
			let typeContainer = try typesDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.TypeKeys.self, forKey: .type)
			
			let type = try typeContainer.decode(String.self, forKey: .name)
			decodedTypes.append(type)
		}
		
		types = decodedTypes
		
		// Decode the stats
		var statusContainer = try container.nestedUnkeyedContainer(forKey: .stats)
		while !statusContainer.isAtEnd {
			let statsDictionaryContainer = try statusContainer.nestedContainer(keyedBy: PokemonKeys.StatDictionaryKeys.self)
			let statContainer = try statsDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.StatDictionaryKeys.StatKeys.self, forKey: .stat)
			
			switch try statContainer.decode(String.self, forKey: .name) {
			case "hp":
				hp = try statsDictionaryContainer.decode(Int.self, forKey: .value)
			case "attack":
				attack = try statsDictionaryContainer.decode(Int.self, forKey: .value)
			case "defense":
				defense = try statsDictionaryContainer.decode(Int.self, forKey: .value)
			case "special-attack":
				specialAttack = try statsDictionaryContainer.decode(Int.self, forKey: .value)
			case "special-defense":
				specialDefense = try statsDictionaryContainer.decode(Int.self, forKey: .value)
			case "speed":
				speed = try statsDictionaryContainer.decode(Int.self, forKey: .value)
			default: print("Unexpected stat encountered.")
			}
		}
		
		// Decode the sprite URLs
		let spriteContainer = try container.nestedContainer(keyedBy: PokemonKeys.SpriteKeys.self, forKey: .sprites)
		sprite = try spriteContainer.decode(URL.self, forKey: .sprite)
		shiny = try spriteContainer.decode(URL.self, forKey: .shiny)
	}
}
