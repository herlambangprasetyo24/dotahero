//
//  HeroApiService.swift
//  DotaHero
//
//  Created by Herlambang Prasetyo on 26/07/20.
//  Copyright © 2020 Herlambang. All rights reserved.
//

import UIKit
import RxSwift
import RxAlamofire
import Alamofire

public enum Method {
    case delete
    case get
    case head
    case post
    case put
    case connect
    case options
    case trace
    case patch
    case other(method: String)
}

class HeroApiService: HeroApiServiceProtocol {

    typealias Handler = (Single<Data>) -> Void
    
    private let heroListStore: HeroListStoreProtocol
    
    init(heroListStore: HeroListStoreProtocol) {
        self.heroListStore = heroListStore
    }
    
    func getHeroList() -> Single<[Hero]?> {
        if let heroListFromCache = heroListStore.getHeroList() {
            let fromServer = getHeroListFromServer()
            let fromCache = Single.just(heroListFromCache)
            return Single.zip(fromServer, fromCache, resultSelector: { result,_ in
                return result
            })
        }
        
        return getHeroListFromServer()
    }
    
    func getHeroListFromServer() -> Single<[Hero]?> {
        let url = "\(Domain.baseApiUrl)" + "herostats"
        return request(method: Method.get, url: url).map { [weak self] (success, responseData) in
            let hero = try? JSONDecoder().decode([Hero].self, from: responseData) as [Hero]
            self?.heroListStore.save(heroList: hero ?? [Hero]())
            return hero
        }
    }
    
    private func request(method: Method, url: String, params: [NSString: Any]? = nil) -> Single<(Bool, Data)> {

        guard let url = URL(string: url) else {
            return Observable.empty().asSingle()
        }
        
        return Single.create { [weak self] single in
            guard self != nil else { return Disposables.create() }
            let task = URLSession.shared.dataTask(with: url,  completionHandler: { (data, response, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        print(error.localizedDescription)
                    } else if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            if data != nil {
                                single(.success((true, data!)))
                            } else {
                                single(.error(error!))
                            }
                        } else {
                            single(.error(error!))
                        }
                    }
                }
            })
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
        
        
    }
}


public class RequestObservable {
    private lazy var jsonDecoder = JSONDecoder()
    private var urlSession: URLSession
    public init(config:URLSessionConfiguration) {
        urlSession = URLSession(configuration:
            URLSessionConfiguration.default)
    }
    //MARK: function for URLSession takes
    public func callAPI<ItemModel: Decodable>(request: URLRequest)
        -> Observable<ItemModel> {
            //MARK: creating our observable
            return Observable.create { observer in
                //MARK: create URLSession dataTask
                let task = self.urlSession.dataTask(with: request) { (data,
                    response, error) in
                    if let httpResponse = response as? HTTPURLResponse{
                        let statusCode = httpResponse.statusCode
                        do {
                            let _data = data ?? Data()
                            if (200...399).contains(statusCode) {
                                let objs = try self.jsonDecoder.decode(ItemModel.self, from:
                                    _data)
                                //MARK: observer onNext event
                                observer.onNext(objs)
                            }
                            else {
                                observer.onError(error!)
                            }
                        } catch {
                            //MARK: observer onNext event
                            observer.onError(error)
                        }
                    }
                    //MARK: observer onCompleted event
                    observer.onCompleted()
                }
                task.resume()
                //MARK: return our disposable
                return Disposables.create {
                    task.cancel()
                }
            }
    }
}
