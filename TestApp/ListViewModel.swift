
import Foundation
import CoreData
import UIKit

@available(iOS 15.0, *)
class ListViewModel: ObservableObject {
    var editviewModel = EditViewModel()

    func getFromDB() -> [EditModel]? {
        var edit = [EditModel]()
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "Store")
        do{
            let res = try CoreDataManager.shared.viewContext.fetch(req)
            for i in res as! [NSManagedObject]{
                var model = EditModel()
                if let val = i.value(forKey: "isImagetype"){
                    if val as! Bool == true{
                         model = EditModel(title: i.value(forKey: "title") as! String,
                                            dics:  i.value(forKey: "disc") as! String,
                                            date:  i.value(forKey: "date") as! String,
                                            image:  i.value(forKey: "image") as! Data ,
                                            isImage:  val as! Bool)
                    }else{
                         model = EditModel(title: i.value(forKey: "title") as! String,
                                            dics:  i.value(forKey: "disc") as! String,
                                            date:  i.value(forKey: "date") as! String,
                                            image:  Data("".utf8),
                                            isImage:  val as! Bool)
                    }
                }
                edit.append(model)
            }
            return edit
        }catch{
            return nil
        }
    }
    
    func dataSourceFilter( _ data :[EditModel]) -> [DataSource] {
        let edit = data
        var flag = data
        var source = [DataSource]()
        var k = 0
        for _ in 0..<loopCount(edit){
            if edit[k].isImage == false{
                var sou = DataSource()
                sou.arr.append(edit[k])
                flag.removeFirst()
                sou.type = DetailType.none
                if edit.count > k + 1{
                    if edit[k + 1].isImage == false{
                        sou.arr.append(edit[k + 1])
                        flag.removeFirst()
                        sou.type = DetailType.none
                    }else{
                        source.append(sou)
                        var sou1 = DataSource()
                        sou1.arr.append(edit[k + 1])
                        flag.removeFirst()
                        sou1.type = DetailType.image
                        source.append(sou1)
                        if flag.isEmpty{
                            break
                        }
                        k = k + 2
                        continue
                    }
                }
                source.append(sou)
                if flag.isEmpty{
                    break
                }
                k = k + 2
            }else{
                var sou = DataSource()
                sou.arr.append(edit[k])
                sou.type = DetailType.image
                flag.removeFirst()
                source.append(sou)
                if flag.isEmpty{
                    break
                }
                k = k + 1
            }
        }
        return source
    }
    
    func loopCount(_ data :[EditModel]) -> Int{
        let edit = data
        var k = Int()
        var n = Int()
        for i in 0..<edit.count{
            if edit[i].isImage == false{
                k = k + 1
            }else{
                n = n + 1
            }
        }
        return k/2 + k%2 + n
    }
    
    func seggrateImages(_ data :[EditModel]) -> [Data]{
        var arr = [Data]()
        if data.count != 0{
            for i in 0..<data.count{
                if data[i].isImage == true{
                    if data[i].image != nil{
                        arr.append(data[i].image!)
                    }
                }
            }
        }
        return arr
    }
    
    
  func callApi(_ completion: @escaping (Bool) -> Void){
      Task {
       let apiModel = try? await HttpClient.shared.fetchApi()
        if let api = apiModel{
            for mod in api{
                DispatchQueue.global(qos: .background).async {
                    if mod.image != nil{
                        do{
                            let data = try Data.init(contentsOf: URL.init(string:mod.image ?? "")!)
                            DispatchQueue.main.async {
                                self.editviewModel.saveToModel(mod.title, mod.body, image: UIImage(data: data))
                                if self.checkCount(apiModel!) == true{
                                    completion(true)
                                }
                            }
                        }
                        catch {
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.editviewModel.saveToModel(mod.title, mod.body, image: nil)
                            if self.checkCount(api) == true{
                                completion(true)
                            }
                        }
                    }
                }
             }
          }
       }
    }
    
    func checkCount(_ apiData:[PrefetchModel]) -> Bool{
        let data = getFromDB()
        if let dt = data{
            if apiData.count == dt.count{
                return true
            }else{
                return false
            }
        }
        return false
    }
}
