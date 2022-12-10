//
//  DoCatchTryBootcamp.swift
//  SwiftUIThinkingIntermediate
//
//  Created by Berat Yavuz on 9.12.2022.
//

import SwiftUI

class Manager {
    var isActive:Bool = true
     func getTitle()->Result<String,Error> {
        if isActive {
            return .success("New Title")
        }
        else {
            return .failure(URLError(.badURL))
        }
    }
    
    func getTitle2() throws -> String {
        if isActive {
            return "last title"
        }
        else {
            throw URLError(.badURL)
        }
    }
}

class ViewModel:ObservableObject {
    @Published var text: String = "text"
    
    var manager = Manager()
    
    func getTitle(){
//       let result = manager.getTitle()
//
//        switch result {
//        case .success(let newTitle):
//            self.text = newTitle
//        case .failure(let error):
//            self.text = error.localizedDescription
//        }
        
        
        do {
             let newTitle = try manager.getTitle2()
            self.text = newTitle
        } catch  {
            self.text = error.localizedDescription
        }
    }
}


struct DoCatchTryBootcamp: View {
     @StateObject var vm = ViewModel()
    
    var body: some View {
        Text(vm.text)
            .frame(width: 300, height: 300, alignment: .center)
            .background(Color.blue)
            .onTapGesture {
            vm.getTitle()
        }
    }
}

struct DoCatchTryBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        DoCatchTryBootcamp()
    }
}
