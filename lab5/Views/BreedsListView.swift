import SwiftUI

struct BreedsListView: View {

    @StateObject private var viewModel = BreedsViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                
                List(viewModel.filteredBreeds) { breed in
                    NavigationLink(destination: BreedDetailView(breed: breed)) {
                        BreedRowView(breed: breed)
                    }
                }
                .listStyle(.plain)

                if viewModel.isLoading && viewModel.breeds.isEmpty {
                    ProgressView("Завантаження...")
                }

                if let message = viewModel.errorMessage {
                    VStack(spacing: 12) {
                        Image(systemName: "wifi.exclamationmark")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                        Text(message)
                            .multilineTextAlignment(.center)
                        Button("Спробувати ще раз") {
                            Task { await viewModel.loadBreeds() }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                }
            }
            .navigationTitle("Породи котів")
            .searchable(text: $viewModel.searchText, prompt: "Пошук породи")
           
            .task {
                if viewModel.breeds.isEmpty {
                    await viewModel.loadBreeds()
                }
            }
        
            .refreshable {
                await viewModel.loadBreeds()
            }
        }
    }
}

struct BreedRowView: View {
    let breed: CatBreed

    var body: some View {
        HStack(spacing: 12) {
            
            AsyncImage(url: breed.imageURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                default:
                    ProgressView()
                }
            }
            .frame(width: 70, height: 70)
            .background(Color.gray.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(breed.name)
                    .font(.headline)
                
                Text(breed.origin ?? "Невідомо")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    BreedsListView()
}
