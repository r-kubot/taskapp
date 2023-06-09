//
//  InputViewController.swift
//  taskapp
//
//  Created by 久保田 梨央 on 2023/04/26.
//

import UIKit
import RealmSwift
import UserNotifications

class InputViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let realm = try! Realm()
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        背景タップでdismissKeyboardメソッドを呼ぶ
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        titleTextField.text = task.title
        categoryTextField.text = task.category
        contentsTextView.text = task.contents
        datePicker.date = task.date
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write {
            self.task.title = self.titleTextField.text!
            self.task.category = self.categoryTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date
            self.realm.add(self.task, update: .modified)
        }
        
        setNotification(task: task)
        
        super.viewWillDisappear(animated)
    }
    
    //    タスクのローカル通知を登録する
    func setNotification(task: Task) {
        let content = UNMutableNotificationContent()
        //        タイトルと内容を設定（中身なしの場合はメッセージなしの音だけ通知なので「××なし」を表示）
        if task.title == "" {
            content.title = "(タイトルなし)"
        } else {
            content.title = task.title
        }
        if task.contents == "" {
            content.body = "(内容なし)"
        }else {
            content.body = task.contents
        }
        content.sound = UNNotificationSound.default
        
        //        ローカル通知が発動するtrigger（日付マッチ）の作成　トリガーとは条件定義のこと
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        //        identifier, content, triggerからローカル通知を作成（identifierが同じだとローカル通知を上書き保存）
        let request = UNNotificationRequest(identifier: String(task.id.stringValue), content: content, trigger: trigger)
        
        //        ローカル通知を登録
        //        error が nil ならローカル通知の登録に成功したと表示、errorが存在すればerrorを表示
        let center = UNUserNotificationCenter.current()
        center.add(request){ (error) in
            print(error ?? "ローカル通知登録 OK")
        }
        
        //        未通知のローカル通知一覧をログ出力
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("/---------------")
                print(request)
                print("---------------/")
            }
        }
    }
    
        @objc func dismissKeyboard(){
        //        キーボードを閉じる
        view.endEditing(true)
    }
}

