//
//  SearchBar.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/03/29.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class CustomSearchBar : UISearchBar {
    
    let disposeBag = DisposeBag()
    let searchButton = UIButton()
    
    let searchButtonTapped = PublishRelay<Void>()
    var shouldLoadResult = Observable<String>.of("")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(searchButton)
            
        searchTextField.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(60)
                $0.trailing.equalTo(searchButton.snp.leading).offset(-12)
                $0.centerY.equalToSuperview()
        }
            
        searchButton.snp.makeConstraints {
                $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
        }
        searchTextField.autocapitalizationType = .none
        searchTextField.clearButtonMode = .whileEditing
        searchButton.setTitle("검색", for: .normal)
        searchButton.setTitleColor(.black, for: .normal)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func bind() {

        Observable.merge(searchButton.rx.tap.asObservable(),
                         self.rx.searchButtonClicked.asObservable()
        )
        .bind(to: searchButtonTapped)
        .disposed(by: disposeBag)
        
        searchButtonTapped
            .asSignal()
            .emit(to: self.rx.endEditing)
            .disposed(by: disposeBag)
        
        self.shouldLoadResult = searchButtonTapped
            .withLatestFrom(self.rx.text) { $1 ?? ""}
            .filter{ !$0.isEmpty }
            .distinctUntilChanged()
            
        
    }
    
    
    
}
