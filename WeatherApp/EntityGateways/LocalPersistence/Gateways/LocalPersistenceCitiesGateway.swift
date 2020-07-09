//
//  LocalPersistenceCitiesGateway.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 30/6/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation
import CoreData

protocol LocalPersistenceCitiesGateway: CitiesGateway {
    func save(cities: [City])
    
    func add(city: City)
    
}

class CoreDataCitiesGateway: LocalPersistenceCitiesGateway {
    let viewContext: NSManagedObjectContextProtocol
    
    init(viewContext: NSManagedObjectContextProtocol) {
        self.viewContext = viewContext
    }
    
    //MARK: - CitiesGateway
    
    func fetchCities(completionHandler: @escaping (Result<[City]>) -> Void) {
        if let coreDataCity = try? viewContext.allEntities(withType: CoreDataCity.self) {
            let cities = coreDataCity.map { $0.city }
            completionHandler(.success(cities))
        } else {
            completionHandler(.failure(CoreError(message: "Failed retrieving cities the data base")))
        }
    }
    
    func add(parameters: AddCityParameters, completionHandler: @escaping AddCityEntityGatewayCompletionHandler) {
        guard let coreDataCity = viewContext.addEntity(withType: CoreDataCity.self) else {
            completionHandler(.failure(CoreError(message: "Failed adding the city in the data base")))
            return
        }
        
        coreDataCity.populate(with: parameters)
        
        do {
            try viewContext.save()
            completionHandler(.success(coreDataCity.city))
        } catch {
            viewContext.delete(coreDataCity)
            completionHandler(.failure(CoreError(message: "Failed saving the context")))
        }
        
    }
    
    func delete(city: City, completionHandler: @escaping (Result<Void>) -> Void) {
        let predicate = NSPredicate(format: "id==%@", city.id)
        
        if let coreDataCities = try? viewContext.allEntities(withType: CoreDataCity.self, predicate: predicate),
            let coreDataCity = coreDataCities.first {
            viewContext.delete(coreDataCity)
        } else {
            completionHandler(.failure(CoreError(message: "Failed retrieving cities data base")))
            return
        }
        
        do {
            try viewContext.save()
            completionHandler(.success(()))
        } catch {
            completionHandler(.failure(CoreError(message: "Failed saving the context")))
        }
       }
    
    //MARK: - LocalPersistenceCitiesGateway
    func save(cities: [City]) {
        
    }
    
    func add(city: City) {
        
    }
    
    
}
