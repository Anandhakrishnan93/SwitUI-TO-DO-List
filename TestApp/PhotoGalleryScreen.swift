
import SwiftUI

@available(iOS 15.0, *)
struct PhotoGalleryScreen: View {

    let imagesArry : [Data]?
    @GestureState private var scale: CGFloat = 1.0
    @State private var currentIndex = 0
    @State var lastScaleValue: CGFloat = 1.0
    @Binding var isDetailPushed : Bool

    private var controls : some View {
      
        HStack{
            Button{
                withAnimation {
                    currentIndex = currentIndex > 0 ? currentIndex - 1 : 0
                }
            } label: {
                Image(systemName: "chevron.left")
                    .padding()
                    .foregroundColor(.white)
                    .background(.gray.opacity(0.5))
                    .clipped()
            }
            Button{
                withAnimation {
                    if let img = imagesArry{
                        currentIndex = currentIndex < img.count ? currentIndex + 1 : 0
                    }
                }
            } label: {
                Image(systemName: "chevron.right")
                    .padding()
                    .foregroundColor(.white)
                    .background(.gray.opacity(0.5))
                    .clipped()
            }
        }.accentColor(.primary)
    }
    
    private var close : some View {
        HStack{
            Button{
                withAnimation {
                    isDetailPushed = false
                }
            } label: {
                Image(systemName: "xmark.square.fill")
                    .padding()
                    .foregroundColor(.white)
                    .font(.system(size: 30))
                    .clipped()
            }
        }.accentColor(.primary)
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .center){
                HStack{
                    Spacer()
                    close
                }
                .offset(y:0)
                Spacer()
                if let img = imagesArry{
                    if img.count != 0{
                        TabView(selection: $currentIndex){
                            ForEach (0..<img.count){ index in
                                Image(uiImage: UIImage(data:img[index])!)
                                 .resizable()
                                .frame(width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height / 2, alignment: .center)
                                    .scaleEffect(lastScaleValue)
                                    .gesture(MagnificationGesture().onChanged { val in
                                        self.lastScaleValue = val
                                        self.lastScaleValue = val.magnitude
                                    }.onEnded { val in
                                    })
                                .tag(index)
                                .onDisappear {
                                    self.lastScaleValue = 1.0
                                }
                                .onAppear {
                                    self.lastScaleValue = 1.0
                                }
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .frame(width: proxy.size.width, height: 500 )
                        Spacer()
                        controls
                    }
                }
            }
            .background(.black)
        }
    }
}

