//
//  ViewController.swift
//  FoodProject
//
//  Created by user229897 on 11/18/22.
//

import UIKit
import Kingfisher
protocol MyCollectionCellDelegate:AnyObject{
    func MyCollectionCardDidSelect(title:String)
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        self.title = "Welcome John"
        let apperance = UINavigationBarAppearance()
        apperance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = apperance
        self.navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(banner)
        
        banner.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        banner.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        banner.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        banner.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        banner.clipsToBounds = true
        
        banner.addSubview(bannerImgview)
        bannerImgview.backgroundColor = .red
        bannerImgview.widthAnchor.constraint(equalTo: banner.widthAnchor).isActive = true
        bannerImgview.heightAnchor.constraint(equalTo: banner.heightAnchor).isActive = true
        bannerImgview.image = UIImage(named: "banner")
        bannerImgview.tintColor = .black
        
        view.addSubview(contentContainer)
        contentContainer.topAnchor.constraint(equalTo: banner.bottomAnchor).isActive = true
        contentContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contentContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        contentContainer.heightAnchor.constraint(equalTo:view.heightAnchor, multiplier: 0.7).isActive = true
        
        contentContainer.addSubview(tableView)
        tableView.heightAnchor.constraint(equalTo: contentContainer.heightAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: contentContainer.widthAnchor).isActive = true
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    let banner:UIView = {
        let bview = UIView()
        bview.translatesAutoresizingMaskIntoConstraints = false
        bview.backgroundColor = .systemMint
        bview.layer.cornerRadius = 15
        return bview
    }()
    
    let bannerImgview = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    let contentContainer:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let tableView:UITableView = {
       let tbl = UITableView()
        tbl.translatesAutoresizingMaskIntoConstraints = false
        //tbl.backgroundColor = .systemMint
        tbl.register(MyCollectionCell.self, forCellReuseIdentifier: "Cell")
        return tbl
    }()


}

extension ViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MyCollectionCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyCollectionCell
        //cell.textLabel?.text = "Hello Again"
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Food Images"
    }
    
    
}
extension ViewController:MyCollectionCellDelegate{
    func MyCollectionCardDidSelect(title: String) {
        let vc = FoodDetailViewController()
        vc.label.text = title
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

class MyCollectionCell:UITableViewCell{
    
    weak var delegate:MyCollectionCellDelegate?
    
    var foodModel:[Result] = [Result]()
    
    let foodCollection:UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        let fc = UICollectionView(frame: .zero, collectionViewLayout: layout)
        fc.translatesAutoresizingMaskIntoConstraints = false
        return fc
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        contentView.addSubview(foodCollection)
        foodCollection.widthAnchor.constraint(equalTo:self.widthAnchor).isActive = true
        foodCollection.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        foodCollection.heightAnchor.constraint(equalTo:self.heightAnchor).isActive = true
       // foodCollection.backgroundColor = .systemMint
        foodCollection.register(FoodCard.self, forCellWithReuseIdentifier: "Card")
        foodCollection.showsHorizontalScrollIndicator = false
        
        foodCollection.delegate = self
        foodCollection.dataSource = self
        
        loadData()
        
    }
    
    func loadData(){
        
        let urlString = "https://api.spoonacular.com/recipes/complexSearch?apiKey=\(API.APIKEY)"
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
                        
            let fm:FoodModel = try! JSONDecoder().decode(FoodModel.self, from: data!)
            
            self.foodModel = fm.results
            //print(foodModel)
            
            DispatchQueue.main.async {
                self.foodCollection.reloadData()
            }
            
            
        }
        task.resume()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MyCollectionCell:UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let card:FoodCard = collectionView.dequeueReusableCell(withReuseIdentifier: "Card", for: indexPath) as! FoodCard
        card.backgroundColor = .systemBackground
        card.layer.cornerRadius = 15
        card.layer.shadowColor = UIColor.gray.cgColor
        card.layer.shadowOffset = CGSize.zero
        card.layer.shadowOpacity = 0.4
        card.layer.borderWidth = 0.5
        card.layer.borderColor = UIColor.systemGray.cgColor
        card.layer.shadowRadius = 2
        let img = foodModel.indices.contains(indexPath.row) ? foodModel[indexPath.row].image : "https://insanelygoodrecipes.com/wp-content/uploads/2020/11/Homemade-French-Toast-Sticks-500x375.png";
        card.foodImage.kf.setImage(with: URL(string: img))
        card.clipsToBounds = true
        return card
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 170)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected row at \(indexPath.row)")
        self.delegate?.MyCollectionCardDidSelect(title: foodModel[indexPath.row].title)
    }
    
}

class FoodCard:UICollectionViewCell{
    
    var foodImage:UIImageView = {
        let fi = UIImageView()
        fi.translatesAutoresizingMaskIntoConstraints = false
        fi.contentMode = .scaleAspectFill
        return fi
    }()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(foodImage)
        foodImage.widthAnchor.constraint(equalTo:self.widthAnchor).isActive = true
        foodImage.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
               
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



