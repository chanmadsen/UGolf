//
//  HomeViewController.swift
//  UGolf
//
//  Created by Lon Chandler Madsen on 9/20/21.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import SDWebImage


class HomeViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var data = [ProfileViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        
        data.append(ProfileViewModel(viewModelType: .info,
                                     title: "Name:    \(UserDefaults.standard.value(forKey: "name") as? String ?? "No name")",
                                     handler: nil))
        data.append(ProfileViewModel(viewModelType: .scores,
                                     title: "Scores",
                                     handler: nil))
        data.append(ProfileViewModel(viewModelType: .otherUsers,
                                     title: "Friends",
                                     handler: nil))
        data.append(ProfileViewModel(viewModelType: .otherUsers,
                                     title: "Friend Requests",
                                     handler: nil))
        
        data.append(ProfileViewModel(viewModelType: .logout, title: "Log Out", handler: {[weak self] in
            
            guard let strongSelf = self else { return }
            
            let actionSheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
            
            actionSheet.addAction(UIAlertAction(title: "Log Out",
                                                style: .destructive,
                                                handler: {[weak self] _ in
                
                guard let strongSelf = self else { return }
                
                UserDefaults.standard.setValue(nil, forKey: "email")
                UserDefaults.standard.setValue(nil, forKey: "name")
                
                //Log out facebook
                FBSDKLoginKit.LoginManager().logOut()
                
                
                do {
                    try FirebaseAuth.Auth.auth().signOut()
                    
                    let vc = LoginViewController()
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    strongSelf.present(nav, animated: true)
                    
                } catch {
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            strongSelf.present(actionSheet, animated: true)
        }))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = createTableHeader()
       
    }
    
    func createTableHeader() -> UIView? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return nil }
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let filename = safeEmail + "_profile_picture.png"
        
        let path = "images/"+filename
        
        let headerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: self.view.width,
                                              height: 300))
        
        headerView.backgroundColor = #colorLiteral(red: 0.372451365, green: 0.6588525772, blue: 0.2430736125, alpha: 1)
        
        let imageView = UIImageView(frame: CGRect(x: (headerView.width-200) / 2,
                                                  y: 50,
                                                  width: 200,
                                                  height: 200))
        
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 30
        headerView.addSubview(imageView)
        
        StorageManager.shared.downloadURL(for: path, completion: { result in
            switch result {
            case .success(let url):
                imageView.sd_setImage(with: url, completed: nil)
            case .failure(let error):
                print("Failed to get download url: \(error)")
            }
        })
        return headerView
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        validateAuth()
    }
    
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
    }
}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as! ProfileTableViewCell
        
        cell.setUp(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        data[indexPath.row].handler?()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

class ProfileTableViewCell: UITableViewCell {
    
    static let identifier = "ProfileTableViewCell"
    
    public func setUp(with viewModel: ProfileViewModel) {
        
        self.textLabel?.text = viewModel.title
        
        switch viewModel.viewModelType {
        case .info:
            self.textLabel?.textAlignment = .left
            self.selectionStyle = .none
            self.textLabel?.font = .systemFont(ofSize: 28, weight: .bold)
            self.backgroundColor = #colorLiteral(red: 0.5842152834, green: 0.82356745, blue: 0.4195292592, alpha: 1)
        case .scores:
            self.textLabel?.font = .systemFont(ofSize: 24, weight: .bold)
            self.textLabel?.textAlignment = .center
            self.backgroundColor = #colorLiteral(red: 0.3723332927, green: 0.6577198776, blue: 0.2432143563, alpha: 1)
        case .otherUsers:
            self.textLabel?.textAlignment = .center
            self.textLabel?.font = .systemFont(ofSize: 21, weight: .semibold)
        case .logout:
            self.textLabel?.textColor = .red
            self.textLabel?.textAlignment = .center
            self.textLabel?.font = .systemFont(ofSize: 21, weight: .semibold)
        }
    }
}
