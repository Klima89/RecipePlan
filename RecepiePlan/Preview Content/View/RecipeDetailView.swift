//
//  RecipeDetailView.swift
//  RecepiePlan
//
//  Created by Kamil Klimacki on 18/02/2025.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                AsyncImage(url: URL(string: recipe.image)) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding()
                
                Text(recipe.label)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Text("Ingredients")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                
                ForEach(recipe.ingredients, id: \.text) { ingredient in
                        Text("- \(ingredient.text)\n")
                            .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Recipe Details")
    }
}
