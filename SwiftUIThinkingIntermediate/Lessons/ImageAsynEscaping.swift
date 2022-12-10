//
//  ImageAsynEscaping.swift
//  SwiftUIThinkingIntermediate
//
//  Created by Berat Yavuz on 10.12.2022.
//

import SwiftUI

class ImageNetwork {
    let url = URL(string: "https://picsum.photos/200")!
    
    func handleResponse(data:Data?,response:URLResponse?) -> UIImage? {
        guard
            let data = data,
            let image = UIImage(data: data),
            let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300
        else {
            return nil
        }
        return image
    }

    func downloadWithAsync() async throws -> UIImage? {
        do {
            let (data,response) = try await URLSession.shared.data(from: url,delegate: nil)
            return handleResponse(data: data, response: response)
        } catch  {
            throw error
        }
    }
     
}

class ImageViewModel:ObservableObject{
    @Published var image: UIImage? = nil
    let network = ImageNetwork()
    
    
     func showImage() async {
      
         let image = try? await network.downloadWithAsync()
        await MainActor.run {
             self.image = image
         }
         
    }
}

struct ImageAsynEscaping: View {
    @StateObject var vm = ImageViewModel()
    var body: some View {
        ZStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
            }
            
        }.onAppear{
            Task {
               await vm.showImage()
            }
        }
    }
}

struct ImageAsynEscaping_Previews: PreviewProvider {
    static var previews: some View {
        ImageAsynEscaping()
    }
}
