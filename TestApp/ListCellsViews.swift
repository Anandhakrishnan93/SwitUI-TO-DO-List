
import Foundation
import SwiftUI

struct ListCells: View {
    var source = [EditModel]()
    var onTapCell: ((EditModel?) -> Void)?
    
    var body: some View {
        HStack{
            ForEach( 0..<source.count , id: \.self) { index in
                ZStack{
                   Rectangle()
                        .fill(Color.clear)
                        .frame(width:  UIScreen.main.bounds.width / 2.1,height:150)
                 
                    VStack(alignment: .leading, spacing: 8) {
                        Text(source[index].title ?? "")
                            .font(.custom(CustomFont, size: 20))
                        Text(source[index].date ?? "")
                            .foregroundColor(.black)
                            .font(.custom(CustomFont, size: 13))
                    }
                    .frame(width:  UIScreen.main.bounds.width / 2.1,height:150, alignment: .center)
                }
                .shadow(radius: 2, x: 2, y: 2)
                .background(colorModifier(index))
                .cornerRadius(10)
                .clipped()
                .onTapGesture {
                    onTapCell?(source[index])
                }
            }
            if source.count != 2{
              Spacer()
                    .frame(width:  UIScreen.main.bounds.width / 2.1,height:150, alignment: .center)
            }
        }
    }
    
    func colorModifier(_ intensity:Int) -> Color{
        let color = UIColor(red:0.96, green:0.54, blue:0.10, alpha:1.0)
        return Color(color.lighter(by: CGFloat(30 - (intensity * 20))) ?? .yellow )
    }
}


struct ListImageCells: View {
    var source = [EditModel]()

    var body: some View {
        ZStack{
           Rectangle()
                .fill(Color.clear)
                .frame(width:  UIScreen.main.bounds.width / 1.05,height:150, alignment: .center)
            VStack(alignment: .leading, spacing: 8) {
                if source[0].image != nil{
                    Image(uiImage: UIImage(data:  source[0].image!)!)
                     .resizable()
                     .frame(width:UIScreen.main.bounds.width ,height: 250)
                }
            }
            .frame(width:  UIScreen.main.bounds.width / 1.05,height:150, alignment: .center)
        }
        .shadow(radius: 2, x: 2, y: 2)
        .background(Color(UIColor.random()))
        .cornerRadius(10)
        .clipped()
    }
}
