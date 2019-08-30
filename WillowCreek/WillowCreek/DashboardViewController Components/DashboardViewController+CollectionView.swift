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
        if uType == "maintenance" {
            return 0
        }else{
            return (collectionViewCellTitles[uType]!).count
        }
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
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            func openMessageVC(vcTitle: String) {
                let messageVC = self.storyboard?.instantiateViewController(withIdentifier: "message") as! MessageViewController
                
                if self.uType == "tenants" {
                    self.db.collection("tenants").document(self.uId).getDocument { (snapshot, error) in
                        if let  error = error {
                            print("Error getting address: " + error.localizedDescription)
                        }else{
                            messageVC.uAddress = snapshot?.data()!["address"] as? String
                            print("Successfully retrieved address")
                        }
                    }
                }
                messageVC.vcTitle = vcTitle
                messageVC.uType = self.uType
                messageVC.uId = self.uId
                messageVC.index = indexPath.row
                messageVC.dashDelegate = self
                self.navigationController?.pushViewController(messageVC, animated: true)
            }
            
            if indexPath.row == 0 && self.uType == "tenants" {
                openMessageVC(vcTitle: "Send Messsage To Managment")
            }else if indexPath.row == 0 {
                openMessageVC(vcTitle: "Send Announcement")
            }else if indexPath.row == 1 && self.uType == "tenants" {
                openMessageVC(vcTitle: "Send Work Order")
            }else if indexPath.row == 1 {
                
            }else{
                openMessageVC(vcTitle: "Send Message To Tenant")
            }
        }
    }
}
