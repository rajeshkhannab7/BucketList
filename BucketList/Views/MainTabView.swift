import SwiftUI
import SwiftData

struct MainTabView: View {
    var body: some View {
        TabView {
            Tab("My List", systemImage: "list.bullet.circle.fill") {
                MyBucketListView()
            }

            Tab("Shared", systemImage: "person.2.circle.fill") {
                SharedListsView()
            }

            Tab("Completed", systemImage: "checkmark.circle.fill") {
                CompletedListView()
            }

            Tab("Friends", systemImage: "person.crop.circle.badge.plus") {
                FriendsView()
            }
        }
    }
}

#Preview {
    MainTabView()
        .modelContainer(previewContainer)
}

@MainActor
let previewContainer: ModelContainer = {
    let schema = Schema([BucketListItem.self, Friend.self])
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    return try! ModelContainer(for: schema, configurations: [config])
}()
