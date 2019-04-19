//
//  DataStorage.swift
//  MyWallpapers°
//
//  Created by Sergey on 17/04/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import Foundation

class DataStorage {
    private static let instance = DataStorage()
    
    private init() {}
    
    static func getInstance() -> DataStorage {
        return instance
    }
    
    let categoryArray = [
        "Abstraction",
        "Adventure",
        "Animals",
        "Architecture",
        "Art",
        "Black And White",
        "Blur",
        "Blue",
        "Books",
        "Building",
        "Camera",
        "Car",
        "City",
        "Clouds",
        "Coffee",
        "Construction",
        "Cooking",
        "Creative",
        "Desert",
        "Design",
        "Desk",
        "Earth",
        "Fire",
        "Flowers",
        "Food",
        "Forest",
        "Fun",
        "Garden",
        "Gift",
        "Grass",
        "Green",
        "Gym",
        "HD Wallpaper",
        "Heart",
        "Holiday",
        "Home",
        "Ice Cream",
        "Industry",
        "Interior",
        "Landscape",
        "Light",
        "Love",
        "Marketing",
        "Mountains",
        "Music",
        "Nature",
        "New York",
        "Night",
        "Notebook",
        "Orange",
        "Paint",
        "Paper",
        "Photography",
        "Plane",
        "Purple",
        "Rain",
        "Red",
        "Relax",
        "River",
        "Road",
        "Sea",
        "Sky",
        "Space",
        "Sport",
        "Street",
        "Summer",
        "Sun",
        "Sunset",
        "Technology",
        "Texture",
        "Time",
        "Tools",
        "Vintage",
        "Wall",
        "Water",
        "Winter",
        "Wood",
        "Yellow"
    ]
}

