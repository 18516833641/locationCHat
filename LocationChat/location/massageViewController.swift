//
//  massageViewController.swift
//  LocationChat
//
//  Created by mark on 2020/11/10.
//

import UIKit

class massageViewController: AnalyticsViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "系统消息"
        
        tableView.register(UINib(nibName: "massageTableViewCell", bundle: nil), forCellReuseIdentifier: "massageTableViewCell")
       
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension massageViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell:massageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "massageTableViewCell") as? massageTableViewCell else {
            let cells = massageTableViewCell(style: .default, reuseIdentifier: "massageTableViewCell")
//            cells.backgroundColor = .groupTableViewBackground
            return cells
        }
//        cell.icon.image = UIImage.init(named: imageArr[indexPath.item])
//        cell.title.text = nameArr[indexPath.row]

      
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        print("点击了第 : \(indexPath.row) 个 cell")
//
//        self.delegate?.pushToNewViewController(index: indexPath.row)
    }
   
}
