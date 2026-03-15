import SwiftUI

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
        .modelContainer(for: [BucketListItem.self, Friend.self], inMemory: true)
}
