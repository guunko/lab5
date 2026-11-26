import SwiftUI

struct BreedDetailView: View {
    let breed: CatBreed

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                AsyncImage(url: breed.imageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    default:
                        ProgressView()
                    }
                }
                .frame(height: 280)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 16))

                Text(breed.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                if let description = breed.description {
                    Text(description)
                        .font(.body)
                }

                Divider()

                DetailRow(title: "Походження", value: breed.origin)
                DetailRow(title: "Характер", value: breed.temperament)
                DetailRow(title: "Тривалість життя", value: breed.lifeSpan.map { "\($0) років" })
                DetailRow(title: "Вага", value: breed.weight?.metric.map { "\($0) кг" })

                Divider()

                RatingRow(title: "Ласкавість", value: breed.affectionLevel)
                RatingRow(title: "Інтелект", value: breed.intelligence)
                RatingRow(title: "Енергійність", value: breed.energyLevel)

                // Посилання на Вікіпедію (якщо є)
                if let wiki = breed.wikipediaUrl, let url = URL(string: wiki) {
                    Link(destination: url) {
                        Label("Читати у Вікіпедії", systemImage: "safari")
                    }
                    .padding(.top, 8)
                }
            }
            .padding()
        }
        .navigationTitle(breed.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Рядок "назва: значення"
struct DetailRow: View {
    let title: String
    let value: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value ?? "Невідомо")
                .font(.body)
        }
    }
}

struct RatingRow: View {
    let title: String
    let value: Int?

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            ForEach(1...5, id: \.self) { star in
                Image(systemName: star <= (value ?? 0) ? "star.fill" : "star")
                    .foregroundColor(.orange)
            }
        }
    }
}

#Preview {
    NavigationStack {
        BreedDetailView(breed: CatBreed.example)
    }
}
