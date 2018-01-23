//
//  MovieEntity.swift
//  CSE335_FavoriteMovieListApp
//
//  Created by Rogelio Barcenas on 10/17/16.
//  Copyright © 2016 Rogelio Barcenas. All rights reserved.
//

import Foundation
import CoreData

class MovieEntity: NSManagedObject
{
    @NSManaged var title: String
    @NSManaged var year: String
    
}