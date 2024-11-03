
import SwiftUI

@available(iOS 15, *)
struct ListingScreen: View {
    @State var editData = EditModel()
    @State private var animationAmount = 1.0
    @State var addedIds = [ Int]()
    @State private var showDetails = false
    @State private var open = true
    @ObservedObject var viewModel = ListViewModel()
    @State private var rotationAngle: Double = 0
    @State private var selectedIndex: Int = 0
    @State var source = [DataSource]()
    @State var arrImage : [Data]?
    @State var isLoading:Bool = false

    init() {
          UITextView.appearance().backgroundColor = .black
    }
    
    var body: some View {
        NavigationView{
            ZStack(alignment:.center){
                if source.count !=  0{
                    NavigationLink(destination: DetailScreen(editData:self.editData ,
                                                               showDetails:$showDetails,
                                                               arrImage:self.arrImage)
                                    .navigationBarBackButtonHidden(true)
                                   , isActive: $showDetails) {
                        EmptyView()
                    }
                }
                if !isLoading{
                    VStack(spacing:0){
                        HStack{
                            Text("Notes")
                                .font(.custom(CustomFontBold, size: 40))
                                .foregroundColor(Color(UIColor.gray))
                            Spacer()
                        }
                        .padding()
                        .background(Color.white)
                        ScrollView {
                            if source.count != 0{
                                LazyVStack{
                                    ForEach( 0..<source.count , id: \.self) { index in
                                        VStack{
                                            if self.source[index].type == DetailType.none{
                                                ListCells(source: self.source[index].arr,onTapCell : { resp in
                                                    editData = resp!
                                                    showDetails = true
                                                })
                                            }
                                            else {
                                                ListImageCells(source: self.source[index].arr)
                                                    .onTapGesture {
                                                        self.editData = self.source[index].arr[0]
                                                        showDetails = true

                                                }
                                            }
                                        }
                                    }
                                }.background(Color.white)
                            }
                        }
                        .background(Color.white)
                    }
              
                    ZStack(alignment: .bottomTrailing ) {
                        Circle()
                            .fill(Color(UIColor.darkGray))
                            .frame(width: 50, height: 50)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    open.toggle()
                                }
                            }
                            .offset(y: -20)
                        Image(systemName: "plus")
                            .resizable()
                            .foregroundColor(Color.white)
                            .frame(width: 20, height: 20)
                            .offset(x:-15,y: -35)
                            .accessibilityIdentifier("PLUS")


                        EditScreen(open:$open.didSet(execute: { resp in
                            if resp == true{
                                onDataSource()
                            }
                            }))
                            .frame(width:UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                            .offset(y: open ? -200 : 0)
                            .scaleEffect(open ? 1.2 : 1)
                            .rotationEffect(Angle(degrees: open ? 30 : 0))
                            .rotation3DEffect(
                                Angle(degrees: open ? 30 : 0),
                                axis: (x: 1, y: 0, z: 0),
                                anchor: .center,
                                anchorZ: 0.0,
                                perspective: 1
                            )
                            .opacity( open ? 0.0 : 1.0)
                        }
                }
                else{
                    ZStack{
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height )
                        VStack{
                            Spacer()
                            ActivityIndicator()
                            .frame(width: 50, height: 50)
                            .background(Color.white)
                            Spacer()
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear(perform: {
                onDataSource()
            })
        }.background(Color.white)

    }
    
    
    func onDataSource() {
        let data = viewModel.getFromDB()
        if let dt = data{
            if dt.count != 0{
                self.arrImage = viewModel.seggrateImages(dt)
                self.source = viewModel.dataSourceFilter(dt)
                isLoading = false

            }
            else{
                isLoading = true
                viewModel.callApi(){resp in
                if resp{
                    onDataSource()
                }
             }
          }
       }
    }
}

