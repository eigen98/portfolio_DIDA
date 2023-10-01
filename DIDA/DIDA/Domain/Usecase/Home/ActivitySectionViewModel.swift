//
//  ActivitySectionViewModel.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/05/08.
//

import Foundation
import RxSwift
import RxCocoa

class ActivitySectionViewModel : BaseViewModel{
    
    private var disposeBag : DisposeBag
    private var socialInteractionRepository: SocialInteractionRepository

    
    var input : Input
    var output : Output
    
    struct Input{
        let followButtonTapped: PublishRelay<Int>
    }
    struct Output {
        let items: BehaviorSubject<[UserEntity]>
        let followStatusChanged: PublishSubject<(Bool, Int)>
    }
    
    override init() {
        let itemsSubject = BehaviorSubject<[UserEntity]>(value: [])
        let followStatusChangedSubject = PublishSubject<(Bool, Int)>()
        
        self.input = Input(followButtonTapped: PublishRelay())
        self.output = Output(items: itemsSubject, followStatusChanged: followStatusChangedSubject)
        socialInteractionRepository = SocialInteractionRepositoryImpl()
        disposeBag = DisposeBag()
        super.init()
        
    }
    
    override func bind() {
        input.followButtonTapped.subscribe(onNext: { [weak self] index in
            self?.toggleFollowStatus(at: index)
        }).disposed(by: disposeBag)
    }
    
    func configure(items: [UserEntity]) {
        output.items.onNext(items)
    }
    
    private func toggleFollowStatus(at index: Int) {
        guard var items = try? output.items.value() else { return }
        items[index].isFollowing.toggle()
        output.items.onNext(items)
        output.followStatusChanged.onNext((items[index].isFollowing, index))
        performFollowAction(for: items[index])
    }
    
    private func performFollowAction(for item: UserEntity) {
        socialInteractionRepository.followUser(memberId: item.userId) { [weak self] result in
            switch result {
            case .success(let success):
                if !success {
                    self?.revertFollowStatus(for: item.userId)
                }
            case .failure(let error):
                self?.revertFollowStatus(for: item.userId)
                print("Error following user: \(error)")
            }
        }
    }
    
    private func revertFollowStatus(for userId: Int) {
        guard var items = try? output.items.value(),
              let index = items.firstIndex(where: { $0.userId == userId }) else { return }
        items[index].isFollowing.toggle()
        output.items.onNext(items)
        output.followStatusChanged.onNext((items[index].isFollowing, index))
    }
}
enum FollowError: Error {
    case invalidInput
    case networkError
    case authorizationError
    case unknownError
}

extension FollowError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidInput:
            return "제공된 입력이 잘못되었습니다."
        case .networkError:
            return "요청을 처리하는 동안 네트워크 에러가 발생했습니다."
        case .authorizationError:
            return "인증에 실패했습니다. 자격 증명을 확인해 주세요."
        case .unknownError:
            return "알 수 없는 에러가 발생했습니다."
        }
    }
}
