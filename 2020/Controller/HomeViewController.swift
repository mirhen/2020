//
//  HomeViewController.swift
//  2020
//
//  Created by Miriam Hendler on 12/4/16.
//  Copyright © 2016 Miriam Hendler. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    //IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var wasteSymbolImageView: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    
    //Custom Variables
    var items: [Item] = []
    var selectedCell = 0
    var collectionViewLayout: LGHorizontalLinearFlowLayout!
    
    //Life Cycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //Appending Item Array
        let fileManager = FileManager.default
        let bundleURL = Bundle.main.bundleURL
        let assetURL = bundleURL.appendingPathComponent("images.bundle")
        let contents = try! fileManager.contentsOfDirectory(at: assetURL, includingPropertiesForKeys: [URLResourceKey.nameKey, URLResourceKey.isDirectoryKey], options: .skipsHiddenFiles)
        
        for item in contents
        {
            items.append(Item(imageName: "\(item.lastPathComponent)"))
        }
        items = items.reversed()
        
        //Setting up delegate <CollectionView>
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        
        //Setting up UI for <CollectionView>
        selectedCell = 0
        
        self.collectionViewLayout = LGHorizontalLinearFlowLayout
            .configureLayout(self.collectionView, itemSize: CGSize(width: 90, height: 90), minimumLineSpacing: 10)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Segue Functions
    @IBAction func unwindToHomeViewController(segue: UIStoryboardSegue) {
        
    }
    @IBAction func camButtonPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.performSegue(withIdentifier: "camSegue", sender: self)
        } else {
            let alertController = UIAlertController(title: "Uh Oh", message: "Your device does not have a camera!", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(cancel)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
}


//MARK: CollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            as! WasteCollectionViewCell
        if indexPath.row == 0 {
            itemLabel.text =  items[indexPath.row].name
            switch items[indexPath.row].wasteType {
            case .recycle:
                wasteSymbolImageView.image = UIImage(named: "recycle_sym_icon")
            case .compost:
                wasteSymbolImageView.image = UIImage(named: "compost_sym_icon")
            case .landfill:
                wasteSymbolImageView.image = UIImage(named: "landfill_sym_icon")
            default:
                break
            }

        }
        cell.layer.shouldRasterize = true;
        cell.layer.rasterizationScale = UIScreen.main.scale
        cell.itemImageView.image = UIImage(named: items[indexPath.row].imageName)
        
        switch items[indexPath.row].wasteType {
        case .recycle:
            cell.wasteImageView.image = UIImage(named: "blue_circle")
        case .compost:
            cell.wasteImageView.image = UIImage(named: "green_circle")
        case .landfill:
            cell.wasteImageView.image = UIImage(named: "black_circle")
        default:
            break
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        findCenterIndex(scrollView)
    }
    
    func findCenterIndex(_ scrollView: UIScrollView) {
        let collectionOrigin = collectionView!.bounds.origin
        let collectionWidth = collectionView!.bounds.width
        var centerPoint: CGPoint!
        var newX: CGFloat!
        if collectionOrigin.x > 0 {
            newX = collectionOrigin.x + collectionWidth / 2
            centerPoint = CGPoint(x: newX, y: collectionOrigin.y)
        } else {
            newX = collectionWidth / 2
            centerPoint = CGPoint(x: newX, y: collectionOrigin.y)
        }
        
        let index = collectionView!.indexPathForItem(at: centerPoint)
        let cell = collectionView!.cellForItem(at: IndexPath(item: 0, section: 0)) as? WasteCollectionViewCell
        
        if(index != nil){
            let cell = collectionView.cellForItem(at: index!) as? WasteCollectionViewCell
            if(cell != nil){
                
                selectedCell = (collectionView.indexPath(for: cell!)?.item)!
                cell!.itemImageView.image = UIImage(named: items[selectedCell].imageName)
                self.itemLabel.text = items[selectedCell].name
                
                switch items[selectedCell].wasteType {
                case .recycle:
                    wasteSymbolImageView.image = UIImage(named: "recycle_sym_icon")
                case .compost:
                    wasteSymbolImageView.image = UIImage(named: "compost_sym_icon")
                case .landfill:
                    wasteSymbolImageView.image = UIImage(named: "landfill_sym_icon")
                default:
                    break
                }
            }
        }
        else if(cell != nil){
            let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
            for cellView in self.collectionView.visibleCells   {
                let currentCell = cellView as? WasteCollectionViewCell
                
                if(currentCell == cell! && (selectedCell == 0 || selectedCell == 1) && actualPosition.x > 0){
                    
                    selectedCell = (collectionView.indexPath(for: cell!)?.item)!
                    cell!.itemImageView.image = UIImage(named: items[selectedCell].imageName)
                    self.itemLabel.text = items[selectedCell].name
                    switch items[selectedCell].wasteType {
                    case .recycle:
                        wasteSymbolImageView.image = UIImage(named: "recycle_sym_icon")
                    case .compost:
                        wasteSymbolImageView.image = UIImage(named: "compost_sym_icon")
                    case .landfill:
                        wasteSymbolImageView.image = UIImage(named: "landfill_sym_icon")
                    default:
                        break
                    }
                }
            }
        }
    }
    
}


