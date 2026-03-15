import SwiftUI
import SwiftData

struct MyBucketListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(
        filter: #Predicate<BucketListItem> { item in
            item.sharedByFriend == nil && item.isCompleted == false
        },
        sort: \BucketListItem.createdDate,
        order: .reverse
    ) private var myItems: [BucketListItem]

    @State private var showingAddItem = false
    @State private var searchText = ""
    @State private var selectedCategory: ItemCategory?

    var filteredItems: [BucketListItem] {
        var items = myItems
        if !searchText.isEmpty {
            items = items.filter { item in
                item.title.localizedCaseInsensitiveContains(searchText) ||
                item.itemDescription.localizedCaseInsensitiveContains(searchText) ||
                (item.address?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
        if let category = selectedCategory {
            items = items.filter { $0.category == category }
        }
        return items
    }

    var body: some View {
        NavigationStack {
            Group {
                if myItems.isEmpty {
                    emptyStateView
                } else {
                    listView
                }
            }
            .navigationTitle("My Bucket List")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddItem = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $showingAddItem) {
                AddItemView()
            }
            .searchable(text: $searchText, prompt: "Search your bucket list...")
        }
    }

    private var emptyStateView: some View {
        ContentUnavailableView {
            Label("No Bucket List Items", systemImage: "list.bullet.clipboard")
        } description: {
            Text("Start adding places to visit and things you want to do!")
        } actions: {
            Button("Add Your First Item") {
                showingAddItem = true
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private var listView: some View {
        List {
            categoryFilterSection

            ForEach(filteredItems) { item in
                NavigationLink(destination: ItemDetailView(item: item)) {
                    BucketListItemRow(item: item)
                }
                .swipeActions(edge: .trailing) {
                    Button {
                        markAsCompleted(item)
                    } label: {
                        Label("Done", systemImage: "checkmark.circle")
                    }
                    .tint(.green)

                    Button(role: .destructive) {
                        deleteItem(item)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                .swipeActions(edge: .leading) {
                    Button {
                        item.isSharedWithFriends.toggle()
                    } label: {
                        Label(
                            item.isSharedWithFriends ? "Unshare" : "Share",
                            systemImage: item.isSharedWithFriends ? "person.2.slash" : "person.2"
                        )
                    }
                    .tint(.blue)
                }
            }
        }
    }

    private var categoryFilterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(title: "All", isSelected: selectedCategory == nil) {
                    selectedCategory = nil
                }
                ForEach(ItemCategory.allCases) { category in
                    FilterChip(
                        title: category.rawValue,
                        icon: category.icon,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal)
        }
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.clear)
    }

    private func markAsCompleted(_ item: BucketListItem) {
        withAnimation {
            item.isCompleted = true
            item.completedDate = Date()
        }
    }

    private func deleteItem(_ item: BucketListItem) {
        withAnimation {
            modelContext.delete(item)
        }
    }
}

struct FilterChip: View {
    let title: String
    var icon: String? = nil
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if let icon {
                    Image(systemName: icon)
                        .font(.caption)
                }
                Text(title)
                    .font(.caption)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? Color.accentColor : Color(.systemGray5))
            .foregroundStyle(isSelected ? .white : .primary)
            .clipShape(Capsule())
        }
    }
}

struct BucketListItemRow: View {
    let item: BucketListItem

    var body: some View {
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
                    if let address = item.address, !address.isEmpty {
                        Label(address, systemImage: "mappin")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }

                    if item.isSharedWithFriends {
                        Label("Shared", systemImage: "person.2.fill")
                            .font(.caption)
                            .foregroundStyle(.blue)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    MyBucketListView()
        .modelContainer(for: [BucketListItem.self, Friend.self], inMemory: true)
}
