//
//  ViewController.swift
//  taskapp
//
//  Created by 久保田 梨央 on 2023/04/25.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.fillerRowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
    
//    データの数（＝セルの数）を返す
//    tableView(_:numberOfRowsInSection:)は、UITableViewDataSourceプロトコルのメソッド
    
    func tableView(_ tableview: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    
//    各セルの内容を返す
//    tableView(_:cellForRowAt:)は、UITableViewDataSourceプロトコルのメソッド
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        再利用可能なcellを得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
    }
    
    
//    各セルを選択した時に実行されるメソッド
//   tableView(_:didSelectRowAt:)は、 UITableViewDelegateプロトコルのメソッド
//    セルタップ→タスク入力画面に遷移させる
    
    func tableView(_ tableView: UITableView,didSelectRowAt IndexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue", sender: nil)
//        ↑追加。segueのIDを指定して遷移させる
    }
    
    
//    セルが削除可能なことを伝えるメソッド
//    tableView(_:editingStyleForRowAt:)　は、UITableViewDelegateプロトコルのメソッド
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    
        return .delete
    }
    
    
//    Deleteボタンが押された時のメソッド
//    tableView(_:commit:forRowAt:)　は、UITableViewDataSourceプロトコルのメソッド
//    Deleteが押された際にデータを削除する
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt IndexPath: IndexPath) {
    }
   
}


