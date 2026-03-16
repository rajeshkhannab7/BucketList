import SwiftUI
import SwiftData

struct SharedListsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(
        filter: #Predicate<BucketListItem> { item in
            item.sharedByFriend != nil
        },
        sort: \BucketListItem.createdDate,
        order: .reverse
    ) private var sharedItems: [BucketListItem]

    @State private var selectedFriend: String?

    private var friendNames: [String] {
        Array(Set(sharedItems.compactMap { $0.sharedByFriend })).sorted()
    }

    private var filteredItems: [BucketListItem] {
        if let friend = selectedFriend {
            return sharedItems.filter { $0.sharedByFriend == friend }
        }
        return sharedItems
    }

    var body: some View {
        NavigationStack {
            Group {
                if sharedItems.isEmpty {
                    emptyStateView
                } else {
                    listView
                }
            }
            .navigationTitle("Shared With Me")
        }
    }

    private var emptyStateView: some View {
        ContentUnavailableView {
            Label("No Shared Items", systemImage: "person.2.circle")
        } description: {
            Text("When friends share their bucket list items with you, they'll show up here.")
        }
    }

    private var listView: some View {
        List {
            friendFilterSection

            ForEach(filteredItems) { item in
                NavigationLink(destination: ItemDetailView(item: item)) {
                    HStack(spacing: 12) {
                        Image(systemName: item.category.icon)
                            .font(.title2)
                            .foregroundStyle(.accent)
                            .frame(width: 36)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title)
                                .font(.headline)
                                .lineLimit(1)

                            if !item.itemDescription.isEmpty {
                                Text(item.itemDescription)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }

                            HStack(spacing: 8) {
                                if let friend = item.sharedByFriend {
                                    Label("From \(friend)", systemImage: "person.fill")
                                        .font(.caption)
                                        .foregroundStyle(.blue)
                                }

                                if let address = item.address, !address.isEmpty {
                                    Label(address, systemImage: "mappin")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(1)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                .swipeActions(edge: .leading) {
                    Button {
                        addToMyList(item)
                    } label: {
                        Label("Add to My List", systemImage: "plus.circle")
                    }
                    .tint(.green)
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        modelContext.delete(item)
                    } label: {
                        Label("Remove", systemImage: "trash")
                    }
                }
            }
        }
    }

    private var friendFilterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(title: "All Friends", isSelected: selectedFriend == nil) {
                    selectedFriend = nil
                }
                ForEach(friendNames, id: \.self) { name in
                    FilterChip(
                        title: name,
                        icon: "person.fill",
                        isSelected: selectedFriend == name
                    ) {
                        selectedFriend = name
                    }
                }
            }
            .padding(.horizontal)
        }
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.clear)
    }

    private func addToMyList(_ item: BucketListItem) {
        let newItem = BucketListItem(
            title: item.title,
            itemDescription: item.itemDescription,
            category: item.category,
            latitude: item.latitude,
            longitude: item.longitude,
            address: item.address,
            sharedByFriend: nil,
            notes: "Originally shared by \(item.sharedByFriend ?? "a friend")"
        )
        modelContext.insert(newItem)
    }
}

#Preview {
    SharedListsView()
        .modelContainer(previewContainer)
}
