//
//  Pokemon+Extension.swift
//  Dex3
//
//  Created by NazarStf on 20.07.2023.
//

import Foundation

extension Pokemon {
	
	// MARK: - Background Image Logic
	// This computed property returns the correct background image name based on the Pokemon's type
	var background: String {
		switch self.types![0] {
		case "normal", "grass", "electric", "poison", "fairy":
			return "normalgrasselectricpoisonfairy"
		case "rock", "ground", "steel", "fighting", "ghost", "dark", "psychic":
			return "rockgroundsteelfightingghostdarkpsychic"
		case "fire", "dragon":
			return "firedragon"
		case "flying", "bug":
			return "flyingbug"
		case "ice":
			return "ice"
		case "water":
			return "water"
		default:
			return ""
		}
	}
	
	// MARK: - Stat Array
	// This computed property returns an array of 'Stat' objects, which are created using the Pokemon's stats
	var stats: [Stat] {
		[
			Stat(id: 1, label: "HP", value: self.hp),
			Stat(id: 2, label: "Attack", value: self.attack),
			Stat(id: 3, label: "Defense", value: self.defense),
			Stat(id: 4, label: "Special Attack", value: self.specialAttack),
			Stat(id: 5, label: "Special Defense", value: self.specialDefense),
			Stat(id: 6, label: "Speed", value: self.speed),
		]
	}
	
	// MARK: - Highest Stat
	// This computed property returns the 'Stat' with the highest value
	var highestStat: Stat {
		stats.max { $0.value < $1.value }!
	}
	
	// MARK: - Organize Types
	// This function reorders the Pokemon's types, if necessary
	func organizeTypes(){
		if self.types?.count == 2 && self.types![0] == "normal"{
			self.types!.swapAt(0, 1)
		}
	}
}

// MARK: - Stat Struct
// This struct represents a single stat of a Pokemon
struct Stat: Identifiable {
	let id: Int
	let label: String
	let value: Int16
}
