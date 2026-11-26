import Foundation
import Combine

// MARK: - ViewModel
// Посередник між даними (Service) та інтерфейсом (View).
// @Published - коли значення змінюється, SwiftUI автоматично оновлює екран.
@MainActor
final class BreedsViewModel: ObservableObject {

    @Published var breeds: [CatBreed] = []      // всі породи
    @Published var isLoading = false            // чи йде завантаження
    @Published var errorMessage: String?        // текст помилки (якщо є)
    @Published var searchText = ""              // текст у полі пошуку

    private let service = CatAPIService()

    // Список порід з урахуванням пошуку
    var filteredBreeds: [CatBreed] {
        if searchText.isEmpty {
            return breeds
        }
        return breeds.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    // Завантажує породи з API
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
