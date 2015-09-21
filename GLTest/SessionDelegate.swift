//
//  SessionDelegate.swift
//  GLTest
//
//  Created by mukuri on 2015/09/20.
//  Copyright (c) 2015年 mukuri. All rights reserved.
//

import Foundation

protocol SessionDelegate {
    func sessionSuccess() //セッションIDが一致（ログインしていたら）
    func sessionFailure()
}