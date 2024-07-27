import UIKit
import CoreData

class UserDataManager {
    
    static let shared = UserDataManager()
    
    private init() {}
    
    var persistentContainer: NSPersistentContainer {
         return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
     }
     
     var context: NSManagedObjectContext {
         return persistentContainer.viewContext
     }
    
    //즐겨찾기 사용
    func saveUser(name: String, phone: String, id: String, password: String, userprofile: Data?) {
        let user = UserData(context: context)
        user.name = name
        user.phone = phone
        user.id = id
        user.password = password
        user.userprofile = userprofile
        user.isLoggedIn = false // 기본값
        
        do {
            try context.save()
            print("User saved successfully")
        } catch {
            print("Failed to save user: \(error.localizedDescription)")
        }
    }
    
    func fetchUser(byId id: String) -> UserData? {
        let fetchRequest: NSFetchRequest<UserData> = UserData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let user = results.first {
                print("Fetched user details for ID: \(id)")
                print("Name: \(user.name ?? "N/A")")
                print("Phone: \(user.phone ?? "N/A")")
                print("Password: \(user.password ?? "N/A")")
                return user
            } else {
                print("No user found with ID: \(id)")
                return nil
            }
        } catch {
            print("Failed to fetch user: \(error)")
            return nil
        }
    }
    
    private func printUserDetails(id: String) {
        if let user = fetchUser(byId: id) {
            print("User details for ID \(id):")
            print("Name: \(user.name ?? "N/A")")
            print("Phone: \(user.phone ?? "N/A")")
            print("Password: \(user.password ?? "N/A")")
        }
    }
    
    func updateUser(id: String, name: String?, phone: String?, password: String?, userprofile: Data?) {
        let fetchRequest: NSFetchRequest<UserData> = UserData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let user = results.first {
                if let name = name {
                    user.name = name
                }
                if let phone = phone {
                    user.phone = phone
                }
                if let password = password {
                    user.password = password
                }
                if let userprofile = userprofile {
                    user.userprofile = userprofile
                }
                
                try context.save()
                print("User \(id) updated successfully.")
                printUserDetails(id: id) // 업데이트 후 디버깅
            } else {
                print("User with id \(id) not found")
            }
        } catch {
            print("Failed to update user: \(error)")
        }
    }
    
    func deleteUser(byId id: String) {
        let fetchRequest: NSFetchRequest<UserData> = UserData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let user = results.first {
                context.delete(user)
                try context.save()
                print("User \(id) deleted successfully.")
            } else {
                print("User with id \(id) not found")
            }
        } catch {
            print("Failed to delete user: \(error)")
        }
    }
    
    
    func validateUser(id: String, password: String) -> Bool {
        let fetchRequest: NSFetchRequest<UserData> = UserData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@ AND password == %@", id, password)
        
        do {
            let results = try context.fetch(fetchRequest)
            let isValid = !results.isEmpty
            print("Validation for ID: \(id) with Password: \(password) returned \(isValid)")
            return isValid
        } catch {
            print("Failed to validate user: \(error)")
            return false
        }
    }
    
    func loginUser(id: String, password: String) -> Bool {
        if validateUser(id: id, password: password) {
            let fetchRequest: NSFetchRequest<UserData> = UserData.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            
            do {
                let results = try context.fetch(fetchRequest)
                if let user = results.first {
                    user.isLoggedIn = true
                    try context.save()
                    print("User \(id) logged in successfully and status updated in Core Data.")
                    return true
                } else {
                    print("User with id \(id) not found in Core Data")
                }
            } catch {
                print("Failed to update user status in Core Data: \(error)")
            }
        } else {
            print("Invalid login credentials.")
        }
        return false
    }
    
    func registerUser(name: String, phone: String, id: String, password: String, userprofile: Data?) {
        saveUser(name: name, phone: phone, id: id, password: password, userprofile: userprofile)
        loginUser(id: id, password: password) // 등록 및 로그인 상태 업데이트 (추가됨)
        print("User \(id) registered successfully and status updated.")
        print("User details: Name: \(name), Phone: \(phone), ID: \(id), Password: \(password)")
    }
    
    func logoutCurrentUser() {
        let fetchRequest: NSFetchRequest<UserData> = UserData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isLoggedIn == %@", NSNumber(value: true))
        
        do {
            let results = try context.fetch(fetchRequest)
            if let user = results.first {
                user.isLoggedIn = false
                try context.save()
                print("User \(user.id ?? "unknown") logged out successfully.")
            } else {
                print("No logged in user found.")
            }
        } catch {
            print("Failed to logout user: \(error)")
        }
    }
    
    //즐겨찾기 사용
    func getCurrentLoggedInUser() -> UserData? {
        let fetchRequest: NSFetchRequest<UserData> = UserData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isLoggedIn == %@", NSNumber(value: true))
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Failed to fetch logged in user: \(error)")
            return nil
        }
    }
}
