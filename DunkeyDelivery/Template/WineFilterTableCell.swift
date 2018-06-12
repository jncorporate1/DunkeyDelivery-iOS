//
//  WineFilterTableCell.swift
//  Template
//
//  Created by Jamil Khan on 8/1/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

protocol WineFilterTableCellDelegate {
    func sendSelectedValue( value: String , name: String, selectedPrice: String)
}

class WineFilterTableCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var title: UILabel!
    
    
    //MARK: - Variables
    
    var currentSectionOfTable : Int!
    var currentSection : Int!
    var isSeeMore : Bool!
    var collectionData = [String]()
    var isMultipleSelection: Bool!
    var delegate : WineFilterTableCellDelegate!
    var sendSortValue = ""
    var manager = AppStateManager.sharedInstance
    var collectionViewSelection : IndexPath = []
    
    
    //MARK: - View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let colletionViewSecondCellNibName = UINib(nibName: "WineFilterMetaCollectionCell", bundle:nil)
        self.collectionView.register(colletionViewSecondCellNibName, forCellWithReuseIdentifier: "cell")
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataOfCollectionView), name: NSNotification.Name(rawValue: "reloadCollectionView"), object: nil)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.alwaysBounceVertical = false
        collectionView.alwaysBounceHorizontal = false
        
        currentSectionOfTable = 0
        currentSection = 0
        isSeeMore = false
        self.registerNot()
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    //MARK: - Helping Method
    
    func isSeeMoreSelected(notification: Notification){
        isSeeMore = !isSeeMore
        collectionView.reloadData()
    }
    
    func setUpData(collectionData: [String], isMultiple: Bool, title: String){
        self.collectionData = collectionData
        self.isMultipleSelection = isMultiple
        self.title.text = title
        self.collectionView.reloadData()
    }
    
    func reloadDataOfCollectionView(){
        self.collectionView.reloadData()
    }
    
}


extension WineFilterTableCell{
    func registerNot(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.curSection(_:)), name: NSNotification.Name(rawValue: "tableViewSection"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.isSeeMoreSelected(notification:)), name: NSNotification.Name(rawValue: "seeMoreDown"), object: nil)
    }
    
    func curSection(_ notification: NSNotification) {
        if let section = notification.userInfo?["section"] as? Int {
            currentSectionOfTable = section
            collectionView.reloadData()
        }
    }
}


//MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension WineFilterTableCell : UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.tag == 2 && isSeeMore == true{
            return 12
        }
        return collectionData.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WineFilterMetaCollectionCell
        
        if(indexPath.section == 0){
            cell.isMultipleTouchEnabled = isMultipleSelection
            cell.view.term.text = collectionData[indexPath.row]
            if manager.countryState.count > 0 {
                for item in manager.countryState{
                    if item == collectionData[indexPath.row]{
                        cell.isSelected = true
                    }
                }
            }
            
            if manager.priceState == collectionData[indexPath.row]{
                cell.isSelected = true
            }
            
            if manager.sizeState.count > 0 {
                for item in manager.sizeState{
                    if item == collectionData[indexPath.row]{
                        cell.isSelected = true
                    }
                }
            }
                
            else{
                
                if title.text == "Price"{
                    /*  cell.view.view.backgroundColor = Constants.APP_COLOR
                      cell.view.term.textColor = UIColor.white*/
                    return cell
                }
                    
                if manager.countryState.count > 0 {
                    
                }
                if manager.countryState.count > 0 {
                    
                }
                    
                else{
                        cell.view.view.backgroundColor = UIColor.white
                        cell.view.term.textColor = UIColor.darkGray
                }
            }
        }
        
        
        /*  if(indexPath.section == 1)
         {
         cell.view.term.text = "White"
         }
         if(indexPath.section == 2)
         {
         cell.view.term.text = "Sparkling"
         }
         if(indexPath.section == 3)
         {
         cell.view.term.text = "Kosher"
         }
         if(indexPath.section == 4)
         {
         cell.view.term.text = "Rose"
         }
         if(indexPath.section == 5)
         {
         cell.view.term.text = "Sake"
         }*/
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if title.text == "Country"{
            print ("\(collectionData[indexPath.row])")
            delegate.sendSelectedValue(value: collectionData[indexPath.row], name: "Country", selectedPrice:"")
            if  collectionViewSelection != indexPath{
                manager.countryState.append(collectionData[indexPath.row])
                collectionViewSelection = indexPath
            }
            else if collectionViewSelection == indexPath {
                if let index = manager.countryState.index(of: collectionData[indexPath.row]) {
                    manager.countryState.remove(at: index)
                }
            }
        }
        
        if title.text == "Price"{
            print ("\(collectionData[indexPath.row])")
            delegate.sendSelectedValue(value: collectionData[indexPath.row], name: "Price", selectedPrice:collectionData[indexPath.row])
            manager.priceState = collectionData[indexPath.row]
            self.collectionView.reloadData()
        }
        
        if title.text == "Size"{
            print ("\(collectionData[indexPath.row])")
            delegate.sendSelectedValue(value: collectionData[indexPath.row], name: "Size",selectedPrice:"")
            if  collectionViewSelection != indexPath{
                manager.sizeState.append(collectionData[indexPath.row])
                collectionViewSelection = indexPath
            }
            else if collectionViewSelection == indexPath {
                if let index = manager.sizeState.index(of: collectionData[indexPath.row]) {
                    manager.sizeState.remove(at: index)
                }
            }
        }
    }
    

}

