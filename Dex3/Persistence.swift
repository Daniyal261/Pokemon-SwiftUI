//
//  Persistence.swift
//  Dex3
//
//  Created by Raja Adeel Ahmed on 4/7/23.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<1 {
            let newItem = Pokemon(context: viewContext)
            newItem.id = Int16(i)
            newItem.attack = Int16(1)
            newItem.name = "Bulbasaur"
            newItem.types = ["grass", "poison"]
            newItem.hp = Int16(1)
            newItem.defence = Int16(1)
            newItem.specialAttack = Int16(1)
            newItem.specialDefence = Int16(1)
            newItem.shiny = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/384.png")!
            newItem.speed = Int16(1)
            newItem.sprite = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/384.png")!
            newItem.isFavorite = false
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Dex3")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        } else {
            container.persistentStoreDescriptions.first?.url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.codeferry.Dex3Group")?.appending(path: "Dex3.sqlite")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
