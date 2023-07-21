//
//  Stats.swift
//  Dex3
//
//  Created by NazarStf on 20.07.2023.
//

import SwiftUI
import Charts

// MARK: - Stats
struct Stats: View {
	
	// The Pokemon object, provided by an ancestor view
	@EnvironmentObject var pokemon: Pokemon
	
	// MARK: - Body
	var body: some View {
		// Chart view taking an array of BarChartDataEntry objects, which are created from the pokemon's stats
		Chart(pokemon.stats) { stat in
			// BarMark represents a single bar in the chart
			BarMark(
				x: .value("Value", stat.value),  // X position is determined by the stat's value
				y: .value("Stat", stat.label)    // Y position is determined by the stat's label
			)
			// Annotation for the BarMark, placed at the trailing end
			.annotation(position: .trailing) {
				Text("\(stat.value)")             // The annotation is the value of the stat
					.padding(.top, -5)             // Shift the annotation up slightly
					.foregroundColor(.secondary)   // Use secondary (i.e., less prominent) color for the annotation
					.font(.subheadline)            // Use subheadline (i.e., smaller) font size for the annotation
			}
		}
		.frame(height: 200)                       // Set the height of the chart
		.padding([.leading, .bottom, .trailing])  // Add padding on three sides of the chart
		.foregroundColor(Color(pokemon.types![0].capitalized))  // Set the color of the chart elements based on the pokemon's type
		.chartXScale(domain: 0...pokemon.highestStat.value+5)   // Set the scale of the x-axis
	}
}

// MARK: - Previews
struct Stats_Previews: PreviewProvider {
	static var previews: some View {
		Stats()
			.environmentObject(SamplePokemon.samplePokemon)
	}
}
