
import Foundation
import SwiftUI
import CoreData

class EditViewModel: ObservableObject {
    
    func saveToCore(model: EditModel){
            let entity = NSEntityDescription.insertNewObject(forEntityName: "Store",
                                                                 into: CoreDataManager.shared.viewContext)
            entity.setValue(model.isImage, forKey: "isImagetype")
            entity.setValue(model.date, forKey: "date")
            entity.setValue(model.title, forKey: "title")
            entity.setValue(model.disc, forKey: "disc")
            entity.setValue(model.image, forKey: "image")

            do{
                try CoreDataManager.shared.viewContext.save()
                print("sucess")
            }
            catch{
                print(error.localizedDescription)
            }
    }
    
    func saveToModel(_ title:String,
                     _ disc:String ,
                     image:UIImage?){
        
        var compressedImage  = Data()
        var isImage = false
        var dicsnew = disc
        if let img = image{
            compressedImage = img.compress(to: 100)
            isImage = true
        }
        let input = dicsnew
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
        for match in matches {
            guard let range = Range(match.range, in: input) else { continue }
            let url = input[range]
            if disc.contains(url){
                dicsnew = dicsnew.replacingOccurrences(of: url, with: "[Click here](\(url))")
            }
        }
        let model = EditModel(title: title,
                              dics: dicsnew,
                              date: Date().timeIntervalSinceNow.getDateStringFromUTC(),
                              image: compressedImage,
                              isImage: isImage)
        saveToCore(model: model)
    }
    
    func getFromDB() -> [EditModel]? {
        var edit = [EditModel]()
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "Store")
        do{
            let res = try CoreDataManager.shared.viewContext.fetch(req)
            for i in res as! [NSManagedObject]{
                let model = EditModel(title: i.value(forKey: "title") as! String,
                                      dics:  i.value(forKey: "disc") as! String,
                                      date:  i.value(forKey: "date") as! String,
                                      image:  i.value(forKey: "image") as! Data,
                                      isImage:  (i.value(forKey: "isImagetype") != nil))
                edit.append(model)
            }
        }catch{
            return nil
        }
        return nil
    }
}


extension Double {
    func getDateStringFromUTC() -> String {
        let date = Date(timeIntervalSinceNow: self)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
}
