import SwiftUI
import MapKit

struct EditItemView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var item: BucketListItem

    @State private var title: String
    @State private var itemDescription: String
    @State private var category: ItemCategory
    @State private var address: String
    @State private var notes: String
    @State private var isSharedWithFriends: Bool
    @State private var selectedLocation: CLLocationCoordinate2D?
    @State private var searchResults: [MKMapItem] = []
    @State private var isSearching = false

    init(item: BucketListItem) {
        self.item = item
        _title = State(initialValue: item.title)
        _itemDescription = State(initialValue: item.itemDescription)
        _category = State(initialValue: item.category)
        _address = State(initialValue: item.address ?? "")
        _notes = State(initialValue: item.notes)
        _isSharedWithFriends = State(initialValue: item.isSharedWithFriends)
        if let lat = item.latitude, let lon = item.longitude {
            _selectedLocation = State(initialValue: CLLocationCoordinate2D(latitude: lat, longitude: lon))
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Title", text: $title)
                        .font(.headline)

                    TextField("Description", text: $itemDescription, axis: .vertical)
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
                        .onSubmit { searchLocation() }

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
            .navigationTitle("Edit Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
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

    private func saveChanges() {
        item.title = title.trimmingCharacters(in: .whitespaces)
        item.itemDescription = itemDescription.trimmingCharacters(in: .whitespaces)
        item.category = category
        item.address = address.isEmpty ? nil : address
        item.latitude = selectedLocation?.latitude
        item.longitude = selectedLocation?.longitude
        item.notes = notes.trimmingCharacters(in: .whitespaces)
        item.isSharedWithFriends = isSharedWithFriends
        dismiss()
    }
}

#Preview {
    EditItemView(item: BucketListItem(
        title: "Visit the Eiffel Tower",
        itemDescription: "See the iconic Parisian landmark",
        category: .place,
        latitude: 48.8584,
        longitude: 2.2945,
        address: "Paris, France"
    ))
    .modelContainer(for: BucketListItem.self, inMemory: true)
}
