import Foundation
import Combine

@MainActor
final class BreedsViewModel: ObservableObject {

    @Published var breeds: [CatBreed] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""

    private let service = CatAPIService()

    
    var filteredBreeds: [CatBreed] {
        if searchText.isEmpty {
            return breeds
        }
        return breeds.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }

   
    func loadBreeds() async {
        isLoading = true
        errorMessage = nil

        do {
            breeds = try await service.fetchBreeds()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
