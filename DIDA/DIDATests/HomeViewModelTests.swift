//
//  HomeViewModelTests.swift
//  DIDATests
//
//  Created by JeongMin Ko on 2023/10/01.
//

import XCTest
@testable import DIDA
import RxSwift
import RxTest

#if TEST
extension HomeViewModel {
    func testableFetchHomeData() -> Observable<Result<HomeEntity, Error>> {
        return self.fetchHomeData()
    }
}
#endif

class HomeViewModelTests: XCTestCase {
    
    var viewModel: HomeViewModel!
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDown() {
        viewModel = nil
        disposeBag = nil
        scheduler = nil
        super.tearDown()
    }
    
    func testRefreshTrigger() {
        // Given
        let mockRepository = MockHomeRepository()
        viewModel = HomeViewModel(homeRepository: mockRepository)

        let loadingObserver = scheduler.createObserver(Bool.self)
        viewModel.showLoading.bind(to: loadingObserver).disposed(by: disposeBag)

        // When
        viewModel.input.refreshTrigger.onNext(())

        // Then
        let expectedLoadingEvents = [Recorded.next(0, true)]
        XCTAssertEqual(loadingObserver.events, expectedLoadingEvents)
    }
    
    func testRepositoryGetMainCalled() {
        // Given
        let mockRepository = MockHomeRepository()
        viewModel = HomeViewModel(homeRepository: mockRepository)

        // When
        viewModel.input.refreshTrigger.onNext(())

        // Then
        XCTAssertTrue(mockRepository.getMainCalled)
    }
    
    func testHomeOutputFailure() {
        // Given
        let mockRepository = MockHomeRepository()
        viewModel = HomeViewModel(homeRepository: mockRepository)

        let expectedError = NSError(domain: "Test", code: 0, userInfo: nil)
        mockRepository.expectedResult = .failure(expectedError)

        let observer = scheduler.createObserver(Result<HomeEntity, Error>.self)

        // When
        viewModel.output.homeOutput
            .subscribe(observer)
            .disposed(by: disposeBag)

        scheduler.start() // TestScheduler 시작
        viewModel.input.refreshTrigger.onNext(())

        // Then
        let recordedEvents = observer.events
        XCTAssertFalse(recordedEvents.isEmpty, "No events recorded")
        
        guard recordedEvents.count > 1 else {
            XCTFail("Expected more than one event due to initial value of BehaviorSubject")
            return
        }
        
        let recordedEvent = recordedEvents[1]
        
        switch recordedEvent.value {
        case .next(let result):
            switch result {
            case .failure(let error as NSError):
                XCTAssertEqual(error.domain, expectedError.domain)
                XCTAssertEqual(error.code, expectedError.code)
            default:
                XCTFail("Expected failure event")
            }
        default:
            XCTFail("Expected next event")
        }
    }

}

class MockHomeRepository: HomeRepository {
    
    var expectedResult: Result<HomeEntity, Error>!
    var getMainCalled = false
    func getMain(completion: @escaping (Result<DIDA.GetMainResponse, Error>) -> ()) {
        getMainCalled = true
        switch expectedResult {
        case .success(let homeEntity):
            let response = DIDA.GetMainResponse()
            completion(.success(response))
        case .failure(let error):
            completion(.failure(error))
        case .none:
          
            break
        }
    }

    
    func getMainSoldout(range: Int, completion: @escaping (Result<GetMainSoldoutNFTResponse, Error>) -> ()) {
        
    }
}
