//
//  DashboardViewController+CollectionView.swift
//  WillowCreek
//
//  Created by Jarrod Mitchell on 8/21/19.
//  Copyright © 2019 Jarrod Mitchell. All rights reserved.
//

import Foundation
import UIKit

extension DashboardViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (collectionViewCellTitles[uType]!).count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width/2)-16
        let height = (collectionView.frame.height/2)-8
        let size = CGSize(width: width, height: height)
        return size
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CustomCollectionViewCell
        
        cell.titleLabel.text = (collectionViewCellTitles[uType]!)[indexPath.row]
        cell.layer.cornerRadius = 9
        
        return cell
    }
}
