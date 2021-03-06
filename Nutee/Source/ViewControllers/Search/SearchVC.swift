//
//  SearchVC.swift
//  Nutee
//
//  Created by Junhyeon on 2020/04/03.
//  Copyright © 2020 S.OWL. All rights reserved.
//

import UIKit

import FirebaseAnalytics

class SearchVC: UIViewController {
    
    // MARK: - UI components
    @IBOutlet weak var searchWrapView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    
    
    // MARK: - Variables and Properties
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearch()
        searchBtn.isHidden = true
        searchBtn.addTarget(self, action: #selector(search), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        Analytics.logEvent("searchview", parameters: [
           "name": "검색 뷰 선택" as NSObject,
           "full_text": "검색 뷰 선택" as NSObject
           ])

        
        // 네비바 border 삭제
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        searchTextField.becomeFirstResponder()
    }
    
    
    // MARK: - Helper
    func setSearch(){
        self.searchTextField.delegate = self
        searchWrapView.setBorder(borderColor: .nuteeGreen, borderWidth: 1)
        searchTextField.placeholder = "검색"
        searchTextField.tintColor = .nuteeGreen
        searchBtn.tintColor = .nuteeGreen
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    @objc func search(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchResultVC") as! SearchResultVC
        
        vc.searchResult = searchTextField.text
        Analytics.logEvent(searchTextField.text ?? "", parameters: [
           "name": "검색 뷰 선택" as NSObject,
           "full_text": "검색 뷰 선택" as NSObject
           ])

        self.navigationController?.pushViewController(vc, animated: true)
    }
        
}

// MARK: - extension에 따라 적당한 명칭 작성
extension SearchVC : UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        // 입력된 빈칸 감지하기
        var str = textField.text
        str = str?.replacingOccurrences(of: " ", with: "")
        
        if str?.count == 0 {
            searchBtn.isHidden = true
        } else {
            searchBtn.isHidden = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 입력된 빈칸 감지하기
        var str = textField.text
        str = str?.replacingOccurrences(of: " ", with: "")
        
        if str?.count != 0 {
            search()
            searchTextField.resignFirstResponder()
        }
        return true
    }
    
}
