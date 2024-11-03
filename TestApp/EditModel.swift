
import Foundation

enum DetailType{
    case image
    case none
}

struct DataSource{
    var arr = [EditModel]()
    var type : DetailType? = DetailType.none
    init(){
    }
    
}

struct EditModel{
    var title:String?
    var disc:String?
    var date:String?
    var image:Data? = nil
    var isImage:Bool?
    
    init(title:String,
         dics:String,
         date:String,
         image:Data,
         isImage:Bool){
        
        self.image = image
        self.title = title
        self.disc = dics
        self.isImage = isImage
        self.date = date
        
    }
    init(){}
}
