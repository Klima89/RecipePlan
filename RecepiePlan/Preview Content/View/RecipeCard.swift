//
//  RecipeCard.swift
//  RecepiePlan
//
//  Created by Kamil Klimacki on 18/02/2025.
//

import SwiftUI

struct RecipeCard: View {
    var recipe: Recipe
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: recipe.image)) { image in
                image.resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text(recipe.label)
                .font(.headline)
                .padding(.horizontal)
                .padding(.bottom, 5)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 3)
    }
}
