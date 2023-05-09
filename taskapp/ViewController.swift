//
//  ViewController.swift
//  taskapp
//
//  Created by 久保田 梨央 on 2023/04/25.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
//    Realmインスタンスの取得
    let realm = try! Realm()
    
//    DB内のタスクが格納されるリスト。
//    日付の近い順で並べ替え：昇順
//    以降内容をアップデートするとリスト内は自動的に更新される。
    var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)
//    　　objects(_:)　→ クラス指定で一覧取得
//   　　 sorted(byKeyPath:ascending:) → 並べ替え
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.fillerRowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
//    データの数（＝セルの数）を返す＝taskArrayの要素数を返す
//　tableView(_:numberOfRowsInSection:)は、UITableViewDataSourceプロトコルのメソッド
    
    func tableView(_ tableview: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }

    
//    各セルの内容を返す＝taskArrayから該当データを取り出しセルに設定
//    tableView(_:cellForRowAt:)は、UITableViewDataSourceプロトコルのメソッド
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        再利用可能なcellを得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
//        cellに値を設定する
        let task = taskArray[indexPath.row]
        cell.textLabel?.text = task.title
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = formatter.string(from: task.date)
        cell.detailTextLabel?.text = dateString
        
        return cell
    }
    
//    各セルを選択した時に実行されるメソッド
//   tableView(_:didSelectRowAt:)は、 UITableViewDelegateプロトコルのメソッド
//    セルタップ→タスク入力画面に遷移させる
    
    func tableView(_ tableView: UITableView,didSelectRowAt IndexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue", sender: nil)
//        ↑追加。segueのIDを指定して遷移させる        
    }

//    segueで画面遷移する時に呼ばれる
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let inputViewController:InputViewController = segue.destination as! InputViewController
        
        if segue.identifier == "cellSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            inputViewController.task = taskArray[indexPath!.row]
        } else {
            inputViewController.task = Task()
        }
    }
    
//    セルが削除可能なことを伝えるメソッド
//    tableView(_:editingStyleForRowAt:)　は、UITableViewDelegateプロトコルのメソッド
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
//    Deleteボタンが押された時のメソッド
//    tableView(_:commit:forRowAt:)　は、UITableViewDataSourceプロトコルのメソッド
//    Deleteが押された際にデータを削除する
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            //            削除するタスクを取得
            let task = self.taskArray[indexPath.row]
            
            //            ローカル通知をキャンセル
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [String(task.id.stringValue)])
            
            //            データベースから削除
            try!realm.write {
                self.realm.delete(self.taskArray[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            //            未通知のローカル通知一覧をログ出力
            center.getPendingNotificationRequests{ (requests: [UNNotificationRequest]) in
                for request in requests {
                    print("/---------------")
                    print(request)
                    print("---------------/")
                }
            }
        }
    }
    
//    入力画面から戻ってきた時にTableViewを更新させる
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

