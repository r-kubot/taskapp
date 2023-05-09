//
//  Task.swift
//  taskapp
//
//  Created by 久保田 梨央 on 2023/04/27.
//

import RealmSwift

class Task: Object {
//    管理用ID
    @Persisted(primaryKey: true) var id: ObjectId
    
//    タイトル
    @Persisted var title = ""
    
//    内容
    @Persisted var contents = ""
    
//    日時
    @Persisted var date = Date()
    
//    カテゴリ
    @Persisted var category = ""
    
//    「＠」は属性。varやfuncの前につけると特別な機能を与えられる。
//    @PersistedはRealmをインストールすると使える。
//    Realmデータベースの読み書きの対象になる
}

