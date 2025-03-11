//
//  RecipeViewModel.swift
//  RecepiePlan
//
//  Created by Kamil Klimacki on 18/02/2025.
//

import Foundation

enum FilterMealType: String, CaseIterable, Identifiable {
    var id: String {
        rawValue
    }
    case breakfast = "breakfast"
    case lunch = "lunch"
    case dinner = "dinner"
    case snack = "snack"
}

final class RecipeViewModel: ObservableObject {
    enum State {
        case loading, success, error
    }
    
    let mealTypes = FilterMealType.allCases
    
    @Published var state: State = .loading
    @Published var errorMessage: String = ""
    @Published var recipes: [Recipe] = []
    //  @Published var selectedMealType: MealType = .breakfast
    var nextPageUri: String? = nil
    var currentFrom = 0
    let pageSize = 20
    var isLoadingMore = false
    @Published var selectedMealType: FilterMealType = .breakfast {
        didSet {
            Task {
                await fetchRecipes()
            }
        }
    }
    
    
    private let apiService: APIServiceProtocol
    //private var currentLink: Links?
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    @MainActor
    func fetchRecipes() async {
        do {
            state = .loading
            let fetchedRecepies = try await apiService.fetchRecipes(mealType: selectedMealType.rawValue)
            recipes = fetchedRecepies.hits.map { $0.recipe }
            nextPageUri = fetchedRecepies.links.next?.href
            state  = .success
        } catch {
            state = .error
            errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func loadMoreRecipes() async {
        
        guard let nextPage = nextPageUri, !isLoadingMore
        else {return}
        isLoadingMore = true
        
        
        do {
            let fetchedRecepies = try await apiService.fetchMoreRecipes(forUri: nextPage)
            //            recipes.append(contentsOf: fetchedRecepies.hits.map { $0.recipe })
            let newRecipes = fetchedRecepies.hits.map {$0.recipe}
            recipes.append(contentsOf: newRecipes)
            self.nextPageUri = fetchedRecepies.links.next?.href
            isLoadingMore = false
        } catch {
            print("Error fetching more recipes: \(error.localizedDescription)")
        }
        //        isLoadingMore = false
    }
}

//jak pobrac z url warośc query? i przekazać to fo loadMoreRecipes

