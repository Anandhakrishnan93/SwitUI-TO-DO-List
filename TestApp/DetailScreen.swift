
import SwiftUI

@available(iOS 15, *)
struct DetailScreen: View {
    var editData:EditModel?
    @State var showPhoto:Bool = false
    @Binding var showDetails:Bool
    var arrImage : [Data]?
    
    var body: some View {
        ZStack(alignment: .leading){
            VStack{
                HStack{
                    Button(action: {
                       self.showDetails = false
                   }) {
                       HStack {
                           ZStack{
                               Rectangle()
                                   .fill(Color(UIColor.black))
                                    .frame(width: 50,height:30)
                                    .cornerRadius(0)
                               Image(systemName: "chevron.left")
                                   .resizable()
                                   .foregroundColor(Color.white)
                                   .frame(width:10,height: 15)
                           }
                          
                       }
                   }
                   .offset(x:10)
                    Spacer()
                }
                ScrollView{
                    HStack{
                        VStack(alignment: .leading ,spacing: 15){
                            if let data = editData{
                                if let dt = data.isImage{
                                    if dt == true{
                                       Image(uiImage: UIImage(data:  data.image!)!)
                                        .resizable()
                                        .frame(width:UIScreen.main.bounds.width - 10 ,height: 250)
                                        .onTapGesture {
                                                self.showPhoto.toggle()
                                        }
                                    }
                                }
                                Text(data.title ?? "")
                                    .foregroundColor(Color.black)
                                    .lineLimit(2)
                                    .font(.custom(CustomFontBold, size: 25))
                                Text(data.date ?? "")
                                    .font(.custom(CustomFont, size: 17))
                                    .foregroundColor(Color.black)
                                let markdownLink = try! AttributedString(markdown: data.disc ?? "")
                                Text(markdownLink)
                                    .font(.custom(CustomFont, size: 17))
                                    .foregroundColor(Color.black)
                                Spacer()
                            }
                        }
                        .padding()
                        Spacer()
                    }
                    .frame(width:UIScreen.main.bounds.width)
                    Spacer()
                        .navigationBarHidden(true)

                }
                if showPhoto{
                    PhotoGalleryScreen(imagesArry:arrImage,isDetailPushed: $showPhoto)
                        .frame(height:UIScreen.main.bounds.height - 50)
                        .transition(AnyTransition.scale.animation(.easeInOut))
                        .offset(y:-40)
                        
                }
            }
        }
        .frame(width:UIScreen.main.bounds.width)
        .background(Color.white)
    }
}

