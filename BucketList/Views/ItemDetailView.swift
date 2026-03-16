import SwiftUI
import SwiftData
import MapKit
#if canImport(UIKit)
import UIKit
#endif

struct ItemDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var item: BucketListItem
    @State private var showingEditSheet = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                if item.hasLocation {
                    mapSection
                }
                detailsSection
                if !item.notes.isEmpty {
                    notesSection
                }
                actionsSection
            }
            .padding()
        }
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingEditSheet = true
                } label: {
                    Text("Edit")
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EditItemView(item: item)
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: item.category.icon)
                    .font(.title)
                    .foregroundStyle(.accent)

                Text(item.category.rawValue)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray5))
                    .clipShape(Capsule())

                Spacer()

                if item.isCompleted {
                    Label("Completed", systemImage: "checkmark.circle.fill")
                        .font(.subheadline)
                        .foregroundStyle(.green)
                }
            }

            if !item.itemDescription.isEmpty {
                Text(item.itemDescription)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }

            if let address = item.address, !address.isEmpty {
                Label(address, systemImage: "mappin.circle.fill")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            if let friend = item.sharedByFriend {
                Label("Shared by \(friend)", systemImage: "person.fill")
                    .font(.subheadline)
                    .foregroundStyle(.blue)
            }

            HStack {
                Label(
                    "Added \(item.createdDate, format: .dateTime.month().day().year())",
                    systemImage: "calendar"
                )
                .font(.caption)
                .foregroundStyle(.tertiary)

                if let completedDate = item.completedDate {
                    Text("  |  ")
                        .foregroundStyle(.tertiary)
                    Label(
                        "Done \(completedDate, format: .dateTime.month().day().year())",
                        systemImage: "checkmark"
                    )
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                }
            }
        }
    }

    private var mapSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Location")
                .font(.headline)

            if let coordinate = item.coordinate {
                Map(initialPosition: .region(MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                ))) {
                    Marker(item.title, coordinate: coordinate)
                }
                .frame(height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 16))

                Button {
                    openInMaps(coordinate: coordinate)
                } label: {
                    Label("Open in Maps", systemImage: "map.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Button {
                    openInGoogleMaps(coordinate: coordinate)
                } label: {
                    Label("Open in Google Maps", systemImage: "globe")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(.green)
            }
        }
    }

    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Details")
                .font(.headline)

            HStack {
                Label("Shared with friends", systemImage: "person.2.fill")
                Spacer()
                Text(item.isSharedWithFriends ? "Yes" : "No")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Notes")
                .font(.headline)

            Text(item.notes)
                .font(.body)
                .foregroundStyle(.secondary)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private var actionsSection: some View {
        VStack(spacing: 12) {
            if !item.isCompleted {
                Button {
                    withAnimation {
                        item.isCompleted = true
                        item.completedDate = Date()
                    }
                } label: {
                    Label("Mark as Completed", systemImage: "checkmark.circle.fill")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 4)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
            } else {
                Button {
                    withAnimation {
                        item.isCompleted = false
                        item.completedDate = nil
                    }
                } label: {
                    Label("Move Back to Bucket List", systemImage: "arrow.uturn.backward.circle.fill")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 4)
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
            }

            if item.sharedByFriend != nil {
                Button {
                    addToMyList()
                } label: {
                    Label("Add to My Bucket List", systemImage: "plus.circle.fill")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 4)
                }
                .buttonStyle(.bordered)
            }

            ShareLink(
                item: shareText,
                subject: Text(item.title),
                message: Text(item.itemDescription)
            ) {
                Label("Share", systemImage: "square.and.arrow.up")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
            }
            .buttonStyle(.bordered)
        }
        .padding(.top, 8)
    }

    private var shareText: String {
        var text = "Check out this bucket list item: \(item.title)"
        if !item.itemDescription.isEmpty {
            text += "\n\(item.itemDescription)"
        }
        if let coordinate = item.coordinate {
            text += "\n\nView on Google Maps: https://www.google.com/maps?q=\(coordinate.latitude),\(coordinate.longitude)"
        }
        return text
    }

    private func openInMaps(coordinate: CLLocationCoordinate2D) {
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = item.title
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }

    private func openInGoogleMaps(coordinate: CLLocationCoordinate2D) {
        let urlString = "comgooglemaps://?q=\(coordinate.latitude),\(coordinate.longitude)&label=\(item.title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        let fallbackURL = "https://www.google.com/maps?q=\(coordinate.latitude),\(coordinate.longitude)"

        #if canImport(UIKit)
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else if let url = URL(string: fallbackURL) {
            UIApplication.shared.open(url)
        }
        #else
        if let url = URL(string: fallbackURL) {
            NSWorkspace.shared.open(url)
        }
        #endif
    }

    private func addToMyList() {
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
    NavigationStack {
        ItemDetailView(item: BucketListItem(
            title: "Visit the Eiffel Tower",
            itemDescription: "See the iconic Parisian landmark at night when it sparkles",
            category: .place,
            latitude: 48.8584,
            longitude: 2.2945,
            address: "Paris, France"
        ))
    }
    .modelContainer(previewContainer)
}
