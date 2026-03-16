import SwiftUI
import SwiftData

struct FriendsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Friend.name) private var friends: [Friend]
    @State private var showingAddFriend = false
    @State private var showingLoadSample = false

    var body: some View {
        NavigationStack {
            Group {
                if friends.isEmpty {
                    emptyStateView
                } else {
                    listView
                }
            }
            .navigationTitle("Friends")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddFriend = true
                    } label: {
                        Image(systemName: "person.badge.plus")
                    }
                }
                if friends.isEmpty {
                    ToolbarItem(placement: .secondaryAction) {
                        Button("Load Sample Data") {
                            loadSampleData()
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddFriend) {
                AddFriendView()
            }
        }
    }

    private var emptyStateView: some View {
        ContentUnavailableView {
            Label("No Friends Yet", systemImage: "person.2.circle")
        } description: {
            Text("Add friends to share bucket list items with each other.")
        } actions: {
            VStack(spacing: 12) {
                Button("Add a Friend") {
                    showingAddFriend = true
                }
                .buttonStyle(.borderedProminent)

                Button("Load Sample Data") {
                    loadSampleData()
                }
                .buttonStyle(.bordered)
            }
        }
    }

    private var listView: some View {
        List {
            ForEach(friends) { friend in
                NavigationLink(destination: FriendDetailView(friend: friend)) {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(friend.color.gradient)
                                .frame(width: 44, height: 44)
                            Text(friend.initials)
                                .font(.headline)
                                .foregroundStyle(.white)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(friend.name)
                                .font(.headline)
                            Text("@\(friend.username)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        modelContext.delete(friend)
                    } label: {
                        Label("Remove", systemImage: "trash")
                    }
                }
            }
        }
    }

    private func loadSampleData() {
        for friendData in SampleData.friends {
            let friend = Friend(
                name: friendData.name,
                username: friendData.username,
                colorHex: friendData.color
            )
            modelContext.insert(friend)
        }

        for itemData in SampleData.sharedItems {
            let item = BucketListItem(
                title: itemData.title,
                itemDescription: itemData.description,
                category: itemData.category,
                latitude: itemData.lat,
                longitude: itemData.lon,
                address: itemData.address,
                sharedByFriend: itemData.friend
            )
            modelContext.insert(item)
        }
    }
}

struct FriendDetailView: View {
    @Environment(\.modelContext) private var modelContext
    let friend: Friend

    @Query private var allSharedItems: [BucketListItem]

    private var friendItems: [BucketListItem] {
        allSharedItems.filter { $0.sharedByFriend == friend.name }
    }

    init(friend: Friend) {
        self.friend = friend
        _allSharedItems = Query(
            filter: #Predicate<BucketListItem> { item in
                item.sharedByFriend != nil
            },
            sort: \BucketListItem.createdDate,
            order: .reverse
        )
    }

    var body: some View {
        List {
            Section {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(friend.color.gradient)
                            .frame(width: 60, height: 60)
                        Text(friend.initials)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(friend.name)
                            .font(.title3)
                            .fontWeight(.bold)
                        Text("@\(friend.username)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("\(friendItems.count) shared items")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 8)
            }

            Section("Shared Bucket List Items") {
                if friendItems.isEmpty {
                    ContentUnavailableView {
                        Label("No Shared Items", systemImage: "tray")
                    } description: {
                        Text("\(friend.name) hasn't shared any items yet.")
                    }
                } else {
                    ForEach(friendItems) { item in
                        NavigationLink(destination: ItemDetailView(item: item)) {
                            HStack(spacing: 12) {
                                Image(systemName: item.category.icon)
                                    .font(.title3)
                                    .foregroundStyle(.tint)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.title)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    if let address = item.address {
                                        Text(address)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                            .lineLimit(1)
                                    }
                                }
                            }
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                addToMyList(item)
                            } label: {
                                Label("Add to My List", systemImage: "plus.circle")
                            }
                            .tint(.green)
                        }
                    }
                }
            }
        }
        .navigationTitle(friend.name)
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

struct AddFriendView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var username = ""
    @State private var selectedColor = "007AFF"

    let colorOptions = [
        "007AFF", "FF6B6B", "4ECDC4", "FFE66D", "A78BFA",
        "FF9F43", "EE5A24", "10AC84", "5F27CD", "01a3a4"
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section("Friend Info") {
                    TextField("Name", text: $name)
                    TextField("Username", text: $username)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }

                Section("Avatar Color") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 12) {
                        ForEach(colorOptions, id: \.self) { hex in
                            Circle()
                                .fill((Color(hex: hex) ?? .blue).gradient)
                                .frame(width: 44, height: 44)
                                .overlay {
                                    if selectedColor == hex {
                                        Image(systemName: "checkmark")
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                    }
                                }
                                .onTapGesture {
                                    selectedColor = hex
                                }
                        }
                    }
                    .padding(.vertical, 8)
                }

                Section {
                    HStack {
                        Spacer()
                        ZStack {
                            Circle()
                                .fill((Color(hex: selectedColor) ?? .blue).gradient)
                                .frame(width: 80, height: 80)
                            Text(previewInitials)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        }
                        Spacer()
                    }
                } header: {
                    Text("Preview")
                }
            }
            .navigationTitle("Add Friend")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        saveFriend()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty || username.trimmingCharacters(in: .whitespaces).isEmpty)
                    .fontWeight(.semibold)
                }
            }
        }
    }

    private var previewInitials: String {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return "?" }
        let parts = trimmed.split(separator: " ")
        if parts.count >= 2 {
            return String(parts[0].prefix(1) + parts[1].prefix(1)).uppercased()
        }
        return String(trimmed.prefix(2)).uppercased()
    }

    private func saveFriend() {
        let friend = Friend(
            name: name.trimmingCharacters(in: .whitespaces),
            username: username.trimmingCharacters(in: .whitespaces),
            colorHex: selectedColor
        )
        modelContext.insert(friend)
        dismiss()
    }
}

#Preview {
    FriendsView()
        .modelContainer(previewContainer)
}
