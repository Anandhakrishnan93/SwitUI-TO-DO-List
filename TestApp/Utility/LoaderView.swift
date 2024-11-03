
import Foundation
import SwiftUI

@available(iOS 15.0, *)
struct ActivityIndicator: View {
    @State var animateTrimPath = false
    @State var rotaeInfinity = false
     
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 15).fill(Color.gray.opacity(0.1))
                ProgressView {
                    Text("Loading...")
                          .font(.title2)
                          .foregroundColor(Color.white)
                }
            }
            .progressViewStyle(DarkBlueShadowProgressViewStyle())
            .frame(width: 120, height: 120, alignment: .center)
                .background(RoundedRectangle(cornerRadius: 25).stroke(Color.gray,lineWidth: 2))
        }
}

@available(iOS 15.0, *)
struct DarkBlueShadowProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .tint(Color.red)
            .shadow(color: Color(red: 0, green: 0, blue: 0.6),
                    radius: 4.0, x: 1.0, y: 2.0)
    }
}
