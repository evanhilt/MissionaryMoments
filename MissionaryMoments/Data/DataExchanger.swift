//
//  DataExchanger.swift
//  Member_Missionary
//
//  Created by Evan Hilton on 5/14/20.
//  Copyright © 2020 Evan Hilton. All rights reserved.
//

import Foundation
import CoreData

class DataExchanger {
    
    static let shared = DataExchanger()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        do {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]
            let url = documentsDirectory.appendingPathComponent("MomentsCoreData.sqlite")
            let options: [AnyHashable: Any] = [
                NSPersistentStoreFileProtectionKey: FileProtectionType.complete
            ]
            try container.persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
            print("Succeded to setup custom persistentStoreCoordinator")
        } catch {
            print("Failed to setup custom persistentStoreCoordinator")
        }
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    func addEvent(event: EventStruct) -> Void {
        if(getEvent(id: event.id) != nil) {
            return
        }
        let managedContext = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Event", in: managedContext)!
        let newEvent = NSManagedObject(entity: entity, insertInto: managedContext)
        newEvent.setValue(event.id, forKeyPath: "id")
        newEvent.setValue(event.friendId, forKeyPath: "friendId")
        newEvent.setValue(event.eventType.rawValue, forKeyPath: "eventType")
        newEvent.setValue(event.title, forKeyPath: "title")
        newEvent.setValue(event.time, forKeyPath: "time")
        newEvent.setValue(event.notes, forKeyPath: "notes")
        do {
            try managedContext.save()
            print("Added Event success")
            return
        } catch let error as NSError {
            print("Added Event failure: \(error)")
            return
        }
    }
    
    func addFriend(friend: FriendStruct) -> Void {
        if(getFriend(id: friend.id) != nil) {
            return
        }
        let managedContext = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Friend", in: managedContext)!
        let newFriend = NSManagedObject(entity: entity, insertInto: managedContext)
        newFriend.setValue(friend.id, forKeyPath: "id")
        newFriend.setValue(friend.firstName, forKeyPath: "firstName")
        newFriend.setValue(friend.lastName, forKeyPath: "lastName")
        newFriend.setValue(friend.contactsId, forKeyPath: "contactsId")
        newFriend.setValue(friend.gender.rawValue, forKeyPath: "gender")
        newFriend.setValue(friend.phoneNumber, forKeyPath: "phoneNumber")
        newFriend.setValue(friend.photo, forKeyPath: "photo")
        newFriend.setValue(friend.age, forKey: "age")
        newFriend.setValue(friend.member, forKey: "member")
        do {
            try managedContext.save()
            print("Added Friend success")
            return
        } catch let error as NSError {
            print("Added Friend failure: \(error)")
            return
        }
    }
    
    func getEvent(id: Int) -> EventStruct? {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
        fetchRequest.predicate = NSPredicate(format: "id == %@", String(id))
        do {
            let fetchedEvent = try managedContext.fetch(fetchRequest) as! [Event]
            if fetchedEvent.count > 0 {
                let eventStruct = makeEventStruct(event: fetchedEvent[0])
                return eventStruct
            }
            print("No Event with that id exists.")
            return nil
        } catch {
            print("Unable to fetch Event!")
            return nil
        }
    }
    
    func getFriend(id: Int) -> FriendStruct? {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
        fetchRequest.predicate = NSPredicate(format: "id == %@", String(id))
        do {
            let fetchedFriend = try managedContext.fetch(fetchRequest) as! [Friend]
            if fetchedFriend.count > 0 {
                let friendStruct = makeFriendStruct(friend: fetchedFriend[0])
                return friendStruct
            }
            print("No Friend with that id exists.")
            return nil
        } catch {
            print("Unable to fetch Friend!")
            return nil
        }
    }
    
    func delEvent(id: Int) -> Void {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
        fetchRequest.predicate = NSPredicate(format: "id == %@", String(id))
        do {
            let fetchedEvent = try managedContext.fetch(fetchRequest) as! [Event]
            if fetchedEvent.count > 0 {
                let event = fetchedEvent[0]
                do {
                    try event.validateForDelete()
                    managedContext.delete(event)
                    try managedContext.save()
                    print("Delete Event success")
                    return
                } catch {
                    print("Unable to delete Event!")
                    return
                }
            }
            print("No Event with that id exists.")
            return
        } catch {
            print("Unable to fetch Event!")
            return
        }
    }
    
    func delFriend(delEvents: Bool = true, id: Int) -> Void {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
        fetchRequest.predicate = NSPredicate(format: "id == %@", String(id))
        do {
            let fetchedFriend = try managedContext.fetch(fetchRequest) as! [Friend]
            if fetchedFriend.count > 0 {
                let friend = fetchedFriend[0]
                if delEvents == true {
                    let fetchEventsRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
                    fetchEventsRequest.predicate = NSPredicate(format: "id == %@", String(id))
                    let fetchedEvents = try managedContext.fetch(fetchEventsRequest) as! [Event]
                    for event in fetchedEvents {
                        print("deleting event: \(event.title!)")
                        try event.validateForDelete()
                        managedContext.delete(event)
                    }
                }
                do {
                    try friend.validateForDelete()
                    managedContext.delete(friend)
                    try managedContext.save()
                    print("Delete Friend success")
                    return
                } catch {
                    print("Unable to delete Friend!")
                    return
                }
            }
            print("No Friend with that id exists.")
            return
        } catch {
            print("Unable to fetch Friend!")
            return
        }
    }
    
    func getAllEvents() -> [EventStruct] {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
        var eventStructs: [EventStruct] = []
        do {
            let fetchedEvents = try managedContext.fetch(fetchRequest) as! [Event]
            for event in fetchedEvents {
                let eventStruct = makeEventStruct(event: event)
                eventStructs.append(eventStruct)
            }
        } catch {
            print("Unable to fetch all Events")
        }
        return eventStructs
    }
    
    func getAllFriends() -> [FriendStruct] {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
        var friendStructs: [FriendStruct] = []
        do {
            let fetchedFriends = try managedContext.fetch(fetchRequest) as! [Friend]
            for friend in fetchedFriends {
                let friendStruct = makeFriendStruct(friend: friend)
                friendStructs.append(friendStruct)
            }
        } catch {
            print("Unable to fetch all Friends")
        }
        return friendStructs
    }
    
    func getAllFriendsEvents(friendId: Int) -> [EventStruct] {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
        fetchRequest.predicate = NSPredicate(format: "friendId == %@", String(friendId))
        var eventStructs: [EventStruct] = []
        do {
            let fetchedEvents = try managedContext.fetch(fetchRequest) as! [Event]
            for event in fetchedEvents {
                let eventStruct = makeEventStruct(event: event)
                eventStructs.append(eventStruct)
            }
        } catch {
            print("Unable to fetch friend's Events")
        }
        return eventStructs
    }
    
    func makeEventStruct(event: Event) -> EventStruct {
        let eventStruct = EventStruct (
        id: Int(event.id),
        friendId: Int(event.friendId),
        time: event.time!,
        title: event.title!,
        notes: event.notes!,
        eventType: EventEnum(rawValue: Int(event.eventType))!)
        return eventStruct
    }
    
    func makeFriendStruct(friend: Friend) -> FriendStruct {
        let friendStruct = FriendStruct (
        id: Int(friend.id),
        contactsId: Int(friend.contactsId),
        firstName: friend.firstName!,
        lastName: friend.lastName!,
        gender: GenderEnum(rawValue: Int(friend.gender))!,
        phoneNumber: Int(friend.phoneNumber),
        photo: friend.photo,
        age: Int(friend.age),
        member: Bool(friend.member))
        return friendStruct
    }
}
 
