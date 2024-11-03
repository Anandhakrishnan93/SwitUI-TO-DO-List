
import Foundation
import SwiftUI

public struct ImagePickerView: UIViewControllerRepresentable {

    private let sourceType: UIImagePickerController.SourceType
    private let onImagePicked: (UIImage) -> Void
    @Environment(\.presentationMode) private var presentationMode

    public init(sourceType: UIImagePickerController.SourceType, onImagePicked: @escaping (UIImage) -> Void) {
        self.sourceType = sourceType
        self.onImagePicked = onImagePicked
    }

    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = self.sourceType
        picker.delegate = context.coordinator
        return picker
    }

    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    public func makeCoordinator() -> Coordinator {
        Coordinator(
            onDismiss: { self.presentationMode.wrappedValue.dismiss() },
            onImagePicked: self.onImagePicked
        )
    }

    final public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        private let onDismiss: () -> Void
        private let onImagePicked: (UIImage) -> Void

        init(onDismiss: @escaping () -> Void, onImagePicked: @escaping (UIImage) -> Void) {
            self.onDismiss = onDismiss
            self.onImagePicked = onImagePicked
        }

        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                self.onImagePicked(image)
            }
            self.onDismiss()
        }

        public func imagePickerControllerDidCancel(_: UIImagePickerController) {
            self.onDismiss()
        }

    }

}

extension UIImage {
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }

    func compress(to kb: Int, allowedMargin: CGFloat = 0.2) -> Data {
        let bytes = kb * 1024
        var compression: CGFloat = 1.0
        let step: CGFloat = 0.05
        var holderImage = self
        var complete = false
        while(!complete) {
            if let data = holderImage.jpegData(compressionQuality: 1.0) {
                let ratio = data.count / bytes
                if data.count < Int(CGFloat(bytes) * (1 + allowedMargin)) {
                    complete = true
                    return data
                } else {
                    let multiplier:CGFloat = CGFloat((ratio / 5) + 1)
                    compression -= (step * multiplier)
                }
            }
            
            guard let newImage = holderImage.resized(withPercentage: compression) else { break }
            holderImage = newImage
        }
        return Data()
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}


extension Binding {
    func didSet(execute: @escaping (Value) -> Void) -> Binding {
        return Binding(
            get: { self.wrappedValue },
            set: {
                self.wrappedValue = $0
                execute($0)
            }
        )
    }
    
    func onChangeValue(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
        })
    }
}

extension UIColor {

    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}
