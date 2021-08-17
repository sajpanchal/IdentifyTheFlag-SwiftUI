//
//  ContentView.swift
//  GuessTheFlag
//


//  Created by saj panchal on 2021-05-29.
//

import SwiftUI

struct ContentView: View {
    @State var flag = false
    @State var countries = ["Estonia","France","Germany","Ireland","Italy","Nigeria","Poland","Russia","Spain","UK","US"].shuffled()
    @State var correctAnswer = Int.random(in: 0...2)
    func askQuestions() {
       countries = countries.shuffled()
        correctAnswer = Int.random(in: 0...2)
    }
    @State var msg = ""
    @State var animationAmount: Double = 0
    @State var opacity: Double = 1
    @State var scale: CGFloat = 0
    @State var selectedButton = 3
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
//    var image : String
    struct FlagImage: View {
        var image: String
        var body: some View{
            Image(image)
        }
    }
    var body: some View {
        //Image(image)
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.blue,Color.black, Color.blue]), startPoint: .leading, endPoint: .bottom)
            // Color.blue.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/) // edgesIngnoringSafeArea will make our view overlap outside the safe area.
            VStack(alignment: .center) {
                Group {
                    Text("Tap the Flag of").foregroundColor(.white).font(.largeTitle).fontWeight(.black)
                    Text(countries[correctAnswer]).foregroundColor(.white).font(.largeTitle).fontWeight(.black)
                }
                .accessibility(label: Text("Tap the Flag of \(countries[correctAnswer])"))
                VStack(alignment: .center, spacing: 25){
                    ForEach(0..<3) { number in
                        Button(action: {
                            flag = true
                            selectedButton = number
                            if number == correctAnswer {
                                msg = "You have selected a correct flag!"
                                withAnimation {
                                    self.animationAmount += 360
                                    self.opacity = 0.25
                                    self.scale = 1
                                }
                            }
                            else {
                                msg = "Sorry! wrong flag selected. Better luck next time."
                                withAnimation(.easeInOut(duration: 1).repeatCount(3, autoreverses: true)) {
                                    self.scale = 0.7
                                    
                                }
                            }
                        }, label: {
                            FlagImage(image: countries[number])
                        }).clipShape(Capsule()).overlay(Capsule().stroke(Color.black, lineWidth: 2.0))
                        .shadow(color: .black, radius: 2)//clipShape modifier
                        .rotation3DEffect(
                            .degrees(number == correctAnswer ? animationAmount : 0),
                            axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                        .opacity(number == correctAnswer ? 1 : self.opacity)
                        .scaleEffect((number == selectedButton && selectedButton != 3) ? scale : 1)
                        .accessibility(label: Text(self.labels[self.countries[number], default: "Unkwown Flag"]))
                    }
                    Spacer()
                }.alert(isPresented: $flag, content: {
                    Alert(title: Text("Result"), message: Text(msg), dismissButton: .cancel(Text("OK")){
                        self.opacity = 1
                        self.scale = 1
                        selectedButton = 3
                        flag = false
                        askQuestions()
                    })
                    .accessibility(label: Text("Result. \(Text(msg))"))
                })
            }
        }
    }
}
    

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
