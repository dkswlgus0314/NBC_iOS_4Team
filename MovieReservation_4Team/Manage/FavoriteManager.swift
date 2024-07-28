//
//  Manager.swift
//  MovieReservation_4Team
//
//  Created by t2023-m0023 on 7/22/24.
//


import CoreData
import UIKit

// 사용자의 즐겨찾기 영화를 관리하는 클래스
class FavoriteManager {
    //<<<<<[CoreData를 쓴다면 공통으로 들아갈 부분들]🌟🌟🌟🌟🌟🌟🌟🌟
    static let shared = FavoriteManager()
    //    private let userDataManager = UserDataManager.shared
    
    private init() {}
    
    var persistentContainer: NSPersistentContainer {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    // MARK: - Core Data stack
    //    lazy var persistentContainer: NSPersistentContainer = {
    //            let container = NSPersistentContainer(name: "MovieUserData") //🌟🌟🌟
    //            container.loadPersistentStores { storeDescription, error in
    //                if let error = error as NSError? {
    //                    fatalError("Unresolved error \(error), \(error.userInfo)")
    //                }
    //            }
    //            return container
    //        }()
    
    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("User saved successfully")
            } catch {
                let nserror = error as NSError
                print("Failed to save user: \(error.localizedDescription)")
            }
        }
    }
    
    
    // 즐겨찾기 추가
    func addFavoriteMovie(movieID: String, user: UserData) {
        let context = persistentContainer.viewContext
        let favoriteMovie = FavoriteMovie(context: context)
        favoriteMovie.movieID = movieID
        favoriteMovie.isLiked = false
        favoriteMovie.user = user
        fetchFavoriteMovies(for: user)
        saveContext()
    }
    
    // 즐겨찾기 삭제
    func deleteFavoriteMovie(favorite: FavoriteMovie) {
        let context = persistentContainer.viewContext
        context.delete(favorite)
        saveContext()
    }
    
    // 즐겨찾기 리스트 불러오기
    func fetchFavoriteMovies(for user: UserData) -> [FavoriteMovie]? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "user == %@", user)
        
        do {
            let favoriteMovies = try context.fetch(fetchRequest)
//            print("🔥fetchFavoriteMovies: \(favoriteMovies)")
            
            // favoriteMovies의 movieID 배열 생성
                   let movieIDs = favoriteMovies.compactMap { $0.movieID }
                   print("🔥 Favorite Movie IDs: \(movieIDs)")
            
            return favoriteMovies
        } catch {
            print("Failed to fetch favorite movies: \(error.localizedDescription)")
            return nil
        }
    }
}


