//
//  recipeGridView.swift
//  RecepiePlan
//
//  Created by Kamil Klimacki on 18/02/2025.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Meal Type", selection: $viewModel.selectedMealType) {
                    ForEach(viewModel.mealTypes) { type in
                        Text(type.rawValue.capitalized).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                switch viewModel.state {
                case .loading:
                    ProgressView()
                case .success:
                    ScrollView {
//                        LazyVStack{
                            ForEach(viewModel.recipes) { recipe in
                                //                                                                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                RecipeCard(recipe: recipe)
                                    .onAppear {
                                        if recipe == viewModel.recipes.last {
                                            Task {
                                                await viewModel.loadMoreRecipes()
                                                //                                            }
                                            }
                                        }
                                    }
                                if viewModel.isLoadingMore != false {
                                    ProgressView()
                                        .padding()
                                }
                            }
                            
//                        }
                    }
                case .error:
                    Text(viewModel.errorMessage)
                        .foregroundStyle(Color.red)
                        .font(.title2)
                }
            }
            .navigationTitle("Recipes")
           
        }
        .task {
            await viewModel.fetchRecipes()
        }
    }
}
