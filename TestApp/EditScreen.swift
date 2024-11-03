

import SwiftUI
import Combine

struct EditScreen: View {
    @State var placeholderString = "Title..."
    @State var placeholderStringText = "Text..."
    @State var title: String = "Title..."
    @State var text: String = "Text..."
    @Binding var open :Bool
    @State var showImagePicker: Bool = false
    @State var image: UIImage?
    @State var editData:EditModel?
    @ObservedObject var viewModel = EditViewModel()

    var body: some View {
        ZStack{
            Rectangle()
                 .fill(Color.white)
                 .frame(width:  UIScreen.main.bounds.width,height: UIScreen.main.bounds.height)
            VStack{
                Text("")
                    .frame(height:10)
                HStack{
                    Button(action: {
                        withAnimation(.spring()) {
                            open.toggle()
                        }
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
                    .accessibilityIdentifier("BACK")
                   Spacer()
                    HStack{
                        Button {
                            self.showImagePicker.toggle()
                        } label: {
                            HStack {
                                ZStack{
                                    Rectangle()
                                        .fill(Color(UIColor.black))
                                         .frame(width: 50,height:30)
                                         .cornerRadius(0)
                                    Image(systemName: "pin")
                                        .resizable()
                                        .foregroundColor(Color.white)
                                        .frame(width:10,height: 15)
                                }
                            }
                        }
                        Button {
                            viewModel.saveToModel(title, text, image: self.image)
                            withAnimation(.spring()) {
                                open.toggle()
                            }
                        } label: {
                            ZStack{
                                Rectangle()
                                    .fill(Color(UIColor.black))
                                     .frame(width: 50,height:30)
                                     .cornerRadius(0)
                                Text("Save")
                                    .font(.custom(CustomFont, size: 12))
                                    .padding()
                                    .foregroundColor(Color.white)
                            }
                        }
                    }
                }
                .padding()
                VStack{
                    if image != nil{
                        Image(uiImage: image!)
                            .resizable()
                            .frame(height: 250)
                    }
                    TextEditor(text: $title)
                        .font(.custom(CustomFontBold, size: 25))
                        .foregroundColor(self.title == placeholderString ? .gray : .black)
                        .frame(height: 100)
                        .background(Color.black)
                        .onTapGesture {
                            if self.title == placeholderString{
                                self.title = ""
                            }
                        }
                        .accessibilityIdentifier("PLUS")

                    TextEditor(text: $text)
                        .font(.custom(CustomFontBold, size: 17))
                        .foregroundColor(self.text == placeholderStringText ? .gray : .black)
                        .background(Color.black)
                        .onTapGesture {
                            if self.text == placeholderStringText{
                                self.text = ""
                            }
                        }
                  }
            }
        }
        .onChange(of: open) { target in
            if target == true{
                self.title = placeholderString
                self.text = placeholderStringText
                self.image = nil
            }
        }
       .sheet(isPresented: $showImagePicker) {
                ImagePickerView(sourceType: .photoLibrary) { image in
                    self.image = image
           }
       }
    }
}
