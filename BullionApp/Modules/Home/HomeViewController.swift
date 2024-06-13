//
//  HomeViewController.swift
//  BullionApp
//
//  Created by Naela Fauzul Muna on 12/06/24.
//

import UIKit

class HomeViewController: UIViewController {
    var bannerCollectionView: UICollectionView!
    var pageControl: UIPageControl!
    var logoImageView: UIImageView!
    var logout: UIButton!
    var tableView: UITableView!
    var HomeVM = HomeViewModel()
    var addUserButton: UIButton!
    var listText: UILabel!
    
    var authToken: String?
    var bannerImages: [UIImage] = [
        UIImage(named: "banner")!,
        UIImage(named: "banner")!,
        UIImage(named: "banner")!
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.customOrange
        
        setupView()
        HomeVM.authToken = authToken
        HomeVM.fetchUsers {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func setupView() {
        logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "Logo")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            logoImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            logoImageView.widthAnchor.constraint(equalToConstant: 104),
            logoImageView.heightAnchor.constraint(equalToConstant: 32),
        ])
        
        logout = UIButton(type: .system)
        logout.setTitle("Logout", for: .normal)
        logout.setTitleColor(.white, for: .normal)
        logout.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(logout)
        
        NSLayoutConstraint.activate([
            logout.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            logout.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
        ])
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        
        bannerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        bannerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        bannerCollectionView.dataSource = self
        bannerCollectionView.delegate = self
        bannerCollectionView.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: "BannerCollectionViewCell")
        bannerCollectionView.showsHorizontalScrollIndicator = false
        bannerCollectionView.backgroundColor = .clear
        self.view.addSubview(bannerCollectionView)
        
        NSLayoutConstraint.activate([
            bannerCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            bannerCollectionView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 30),
            bannerCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            bannerCollectionView.heightAnchor.constraint(equalToConstant: 160),
        ])
        
        pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = bannerImages.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
        self.view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            pageControl.topAnchor.constraint(equalTo: bannerCollectionView.bottomAnchor, constant: 10),
            pageControl.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        backgroundView.layer.cornerRadius = 24
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOpacity = 0.2
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 2)
        backgroundView.layer.shadowRadius = 4
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(backgroundView)
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            backgroundView.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 20)
        ])
        
        listText = UILabel()
        listText.translatesAutoresizingMaskIntoConstraints = false
        listText.text = "List Users"
        listText.textColor = UIColor.customOrange
        listText.font = UIFont.preferredFont(forTextStyle: .headline)
        backgroundView.addSubview(listText)
        
        NSLayoutConstraint.activate([
            listText.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            listText.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20)
        ])
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserTableViewCell")
        backgroundView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: listText.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -80)
        ])
        
        addUserButton = UIButton(type: .system)
        addUserButton.setTitle("Add User", for: .normal)
        addUserButton.translatesAutoresizingMaskIntoConstraints = false
        addUserButton.backgroundColor = UIColor.customBlue
        addUserButton.layer.cornerRadius = 20
        addUserButton.setTitleColor(.white, for: .normal)
        backgroundView.addSubview(addUserButton)
        
        NSLayoutConstraint.activate([
            addUserButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            addUserButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
            addUserButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10),
            addUserButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func pageControlTapped(_ sender: UIPageControl) {
        let page = sender.currentPage
        let indexPath = IndexPath(item: page, section: 0)
        bannerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func showUserDetailDialog(userId: String) {
        if let userDetail = HomeVM.userList.first(where: { $0.id == userId }) {
            DispatchQueue.main.async {
                let detailVC = UserDetailViewController()
                detailVC.userDetail = userDetail
                detailVC.modalPresentationStyle = .formSheet
                self.present(detailVC, animated: true, completion: nil)
            }
        }
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bannerImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionViewCell", for: indexPath) as! BannerCollectionViewCell
        cell.configure(with: bannerImages[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 150)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HomeVM.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as? UserTableViewCell else {
            return UITableViewCell()
        }
        let user = HomeVM.userList[indexPath.row]
        cell.configure(with: user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = HomeVM.userList[indexPath.row]
        showUserDetailDialog(userId: user.id)
    }
}
