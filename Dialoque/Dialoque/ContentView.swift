//
//  ContentView.swift
//  Dialoque
//
//  Created by Daniel Aprillio on 28/07/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var statController: StatController
    @EnvironmentObject var gameKitController: GameKitController
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State var isPresented: Bool = false
    
    @StateObject var counter = Counter()
    
    var labelStyle: some LabelStyle {
    #if os(watchOS)
        return IconOnlyLabelStyle()
    #else
        return DefaultLabelStyle()
    #endif
    }
    
    var body: some View {
        NavigationView {
            VStack{
                List {
                    ForEach(items) { item in
                        NavigationLink {
                            Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                        } label: {
                            Text(item.timestamp!, formatter: itemFormatter)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button(action: addItem) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
                VStack{
                    Text("\(counter.score)")
                        .font(.largeTitle)
                    
                    HStack{
                        Text("Score:")
                        Button(action:
                                counter.decrement
                        ){
                            Text("-").bold()
                        }
                        Text("\(counter.score)")
                        Button(action: counter.increment){
                            Text("+").bold()
                        }
                    }
                    
                    Spacer().frame(height: 16)
                    
                    Button(action: {
                        gameKitController.reportScore(totalScore: counter.score)
                    }){
                        Text("Submit")
                            .bold()
                            .foregroundColor(.black)
                    }
                    
                    Spacer().frame(height: 8)
                    
                    Button(action: {
                        isPresented = true
                    }){
                        Text("Leaderboard")
                            .bold()
                            .foregroundColor(.indigo)
                    }
                    .fullScreenCover(isPresented: $isPresented) {
                        GameCenterView().ignoresSafeArea()
                        //                        let newView = GameCenterView().ignoresSafeArea()
                        //                        UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: newView)
                    }
                    
                }
                
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var gameKitController = GameKitController()
        
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(gameKitController)
    }
}
