import SwiftUI
import SwiftData
import MapKit

struct AddItemView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var itemDescription = ""
    @State private var category: ItemCategory = .place
    @State private var address = ""
    @State private var notes = ""
    @State private var isSharedWithFriends = false
    @State private var selectedLocation: CLLocationCoordinate2D?
    @State private var showingMapPicker = false
    @State private var searchResults: [MKMapItem] = []
    @State private var isSearching = false

    var body: some View {
        NavigationStack {
            Form {
                Section("What's on your bucket list?") {
                    TextField("Title", text: $title)
                        .font(.headline)

                    TextField("Description (optional)", text: $itemDescription, axis: .vertical)
                        .lineLimit(3...6)
                }

                Section("Category") {
                    Picker("Category", selection: $category) {
                        ForEach(ItemCategory.allCases) { cat in
                            Label(cat.rawValue, systemImage: cat.icon)
                                .tag(cat)
                        }
                    }
                }

                Section("Location") {
                    TextField("Search for a place...", text: $address)
                        .onSubmit {
                            searchLocation()
                        }
                        .autocorrectionDisabled()

                    if isSearching {
                        HStack {
                            ProgressView()
                            Text("Searching...")
                                .foregroundStyle(.secondary)
                        }
                    }

                    if !searchResults.isEmpty {
                        ForEach(searchResults, id: \.self) { result in
                            Button {
                                selectSearchResult(result)
                            } label: {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(result.name ?? "Unknown")
                                        .font(.subheadline)
                                        .foregroundStyle(.primary)
                                    if let subtitle = result.placemark.formattedAddress {
                                        Text(subtitle)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }
                    }

                    if let location = selectedLocation {
                        Map(initialPosition: .region(MKCoordinateRegion(
                            center: location,
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        ))) {
                            Marker(title, coordinate: location)
                        }
                        .frame(height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))

                        Button("Clear Location", role: .destructive) {
                            selectedLocation = nil
                            address = ""
                        }
                    }
                }

                Section("Notes") {
                    TextField("Any additional notes...", text: $notes, axis: .vertical)
                        .lineLimit(2...4)
                }

                Section {
                    Toggle("Share with Friends", isOn: $isSharedWithFriends)
                }
            }
            .navigationTitle("New Bucket List Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        saveItem()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                    .fontWeight(.semibold)
                }
            }
        }
    }

    private func searchLocation() {
        guard !address.isEmpty else { return }
        isSearching = true
        searchResults = []

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = address

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            isSearching = false
            if let response {
                searchResults = Array(response.mapItems.prefix(5))
            }
        }
    }

    private func selectSearchResult(_ result: MKMapItem) {
        address = result.placemark.formattedAddress ?? result.name ?? ""
        selectedLocation = result.placemark.coordinate
        searchResults = []
    }

    private func saveItem() {
        let item = BucketListItem(
            title: title.trimmingCharacters(in: .whitespaces),
            itemDescription: itemDescription.trimmingCharacters(in: .whitespaces),
            category: category,
            latitude: selectedLocation?.latitude,
            longitude: selectedLocation?.longitude,
            address: address.isEmpty ? nil : address,
            isSharedWithFriends: isSharedWithFriends,
            notes: notes.trimmingCharacters(in: .whitespaces)
        )
        modelContext.insert(item)
        dismiss()
    }
}

extension CLPlacemark {
    var formattedAddress: String? {
        let components = [
            name,
            locality,
            administrativeArea,
            country
        ].compactMap { $0 }
        return components.isEmpty ? nil : components.joined(separator: ", ")
    }
}

#Preview {
    AddItemView()
        .modelContainer(for: BucketListItem.self, inMemory: true)
}
