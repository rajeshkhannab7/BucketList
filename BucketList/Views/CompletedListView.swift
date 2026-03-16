import SwiftUI
import SwiftData

struct CompletedListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(
        filter: #Predicate<BucketListItem> { item in
            item.isCompleted == true
        },
        sort: \BucketListItem.completedDate,
        order: .reverse
    ) private var completedItems: [BucketListItem]

    var body: some View {
        NavigationStack {
            Group {
                if completedItems.isEmpty {
                    emptyStateView
                } else {
                    listView
                }
            }
            .navigationTitle("Completed")
        }
    }

    private var emptyStateView: some View {
        ContentUnavailableView {
            Label("No Completed Items", systemImage: "checkmark.circle")
        } description: {
            Text("Items you mark as done will appear here. Start checking things off your bucket list!")
        }
    }

    private var listView: some View {
        List {
            ForEach(completedItems) { item in
                NavigationLink(destination: ItemDetailView(item: item)) {
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.green)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title)
                                .font(.headline)
                                .strikethrough(true, color: .secondary)

                            if let completedDate = item.completedDate {
                                Text("Completed \(completedDate, format: .dateTime.month().day().year())")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            if let address = item.address, !address.isEmpty {
                                Label(address, systemImage: "mappin")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        modelContext.delete(item)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                .swipeActions(edge: .leading) {
                    Button {
                        withAnimation {
                            item.isCompleted = false
                            item.completedDate = nil
                        }
                    } label: {
                        Label("Undo", systemImage: "arrow.uturn.backward")
                    }
                    .tint(.orange)
                }
            }
        }
    }
}

#Preview {
    CompletedListView()
        .modelContainer(previewContainer)
}
