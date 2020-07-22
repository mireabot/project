//
//  ContentView.swift
//  HRSpot.Me
//
//  Created by Fixed on 08.06.2020.
//  Copyright © 2020 MKM.LLC. All rights reserved.
//

import SwiftUI
import Firebase
import MapKit
import Combine

struct ContentView: View {
    
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    //@State var index = 0
    var body: some View {
        VStack{
            
            if status{
                Nav()
            }
            else{
                
                Login()
            }
            
        }.animation(.spring())
        .onAppear {
                
            NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main) { (_) in
                
                let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                self.status = status
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct Login : View {
    
    @State var user = ""
    @State var pass = ""
    @State var msg = ""
    @State var alert = false
    
    var body : some View{
        
        VStack{
            
            Image("Image")
            
            Text("Sign In").fontWeight(.heavy).font(.largeTitle)
            
            VStack {
                
                VStack (alignment: .leading){
                    
                    Text("E-mail").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                    
                    HStack{
                        
                        TextField("Enter Your E-mail", text: $user)
                        
                        if user != ""{
                            
                            Image("check").foregroundColor(Color.init(.label))
                        }
                        
                    }
                    
                    Divider()
                    
                }.padding(.bottom, 15)
                
                VStack(alignment: .leading){
                    
                    Text("Password").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                        
                    SecureField("Enter Your Password", text: $pass)
                    
                    Divider()
                }

            }.padding(.horizontal, 6)
            
            Button(action: {
                
                signInWithEmail(email: self.user, password: self.pass) { (verified, status) in
                    
                    if !verified{
                        
                        self.msg = status
                        self.alert.toggle()
                    }
                    else{
                        
                        UserDefaults.standard.set(true, forKey: "status")
                        NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                    }
                }
                
            }) {
                
                Text("Sign In").foregroundColor(.white).frame(width: UIScreen.main.bounds.width - 120).padding()
                
                
            }.background(
            
                LinearGradient(gradient: .init(colors: [Color("Color"),Color("Color1"),Color("Color2")]), startPoint: .leading, endPoint: .trailing)
            )
            .clipShape(Capsule())
            .padding(.top, 45)
            
            bottomView()
            
        }.padding()
        .alert(isPresented: $alert) {
                
            Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
        }
    }
}

struct bottomView : View{
    
    @State var show = false
    
    var body : some View{
        
        VStack{
            
            Text("(or)").foregroundColor(Color.gray.opacity(0.5)).padding(.top,30)
            
            HStack(spacing: 8){
                
                Text("Don't Have An Account ?").foregroundColor(Color.gray.opacity(0.5))
                
                Button(action: {
                    
                    self.show.toggle()
                    
                }) {
                    
                   Text("Join Us")
                    
                }.foregroundColor(Color("Color1"))
                
            }.padding(.top, 25)
            
        }.sheet(isPresented: $show) {
            
            Signup(show: self.$show)
        }
    }
}
struct ImagePicker : UIViewControllerRepresentable {
    
    @Binding var picker : Bool
    @Binding var imagedata : Data
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        
        return ImagePicker.Coordinator(parent1: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
        
    }
    
    class Coordinator : NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
        
        var parent : ImagePicker
        
        init(parent1 : ImagePicker) {
            
            parent = parent1
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            
            self.parent.picker.toggle()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            
            let image = info[.originalImage] as! UIImage
            
            let data = image.jpegData(compressionQuality: 0.45)
            
            self.parent.imagedata = data!
            
            self.parent.picker.toggle()
        }
    }
}

struct Indicator : UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<Indicator>) -> UIActivityIndicatorView {
        
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        return indicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Indicator>) {
        
        
    }
}
struct Signup : View {
    @State var user = ""
    @State var pass = ""
    @State var name = ""
    @State var surname = ""
    @State var alert = false
    @State var msg = ""
    @Binding var show : Bool
    @State var picker = false
    @State var imagedata : Data = .init(count: 0)
    @State var bar = false
    @Environment(\.presentationMode) var present
    var body : some View{
        
        VStack{
                Image("Image1")
                Text("Registration").fontWeight(.heavy).font(.largeTitle)
                    .padding(.top, 30.0)
                
            HStack {
                Spacer()
                Button(action: {
                        
                        self.picker.toggle()
                        
                    }) {
                        
                        if self.imagedata.count == 0{
                            
                           Image(systemName: "person.crop.circle.badge.plus").resizable().frame(width: 90, height: 70).foregroundColor(.gray)
                        }
                        else{
                            
                            Image(uiImage: UIImage(data: self.imagedata)!).resizable().renderingMode(.original).frame(width: 90, height: 90).clipShape(Circle())
                        }
                        
                        
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 15)
            
                VStack(alignment: .leading){
                    
                    VStack(alignment: .leading){
                        
                        Text("Name").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                        
                        HStack{
                            
                            TextField("Enter Your Name", text: $name)
                            
                            if user != ""{
                                
                                Image("check").foregroundColor(Color.init(.label))
                            }
                            
                        }
                        
                        Divider()
                        
                    }.padding(.bottom, 15)
                    
                    VStack(alignment: .leading){
                        
                        Text("Surname").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                        
                        HStack{
                            
                            TextField("Enter Your Surname", text: $surname)
                            
                            if user != ""{
                                
                                Image("check").foregroundColor(Color.init(.label))
                            }
                            
                        }
                        
                        Divider()
                        
                    }.padding(.bottom, 15)
                    
                    VStack(alignment: .leading){
                        
                        Text("E-mail").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                        
                        HStack{
                            
                            TextField("Enter Your E-mail", text: $user)
                            
                            if user != ""{
                                
                                Image("check").foregroundColor(Color.init(.label))
                            }
                            
                        }
                        
                        Divider()
                        
                    }.padding(.bottom, 15)
                    
                    VStack(alignment: .leading){
                        
                        Text("Password").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                            
                        SecureField("Enter Your Password", text: $pass)
                        
                        Divider()
                    }

                }.padding(.horizontal, 6)
            
                    Button(action: {
                        UserDefaults.standard.set(self.name, forKey: "Name")
                        UserDefaults.standard.set(self.surname, forKey: "Surname")
                    signIupWithEmail(email: self.user, password: self.pass, name: self.name, surname: self.surname) { (verified, status) in
                        
                        if !verified{
                            
                            self.msg = status
                            self.alert.toggle()
                            
                        }
                        else{
                            
                            UserDefaults.standard.set(true, forKey: "status")
                            
                            self.show.toggle()
                            
                            NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                        }
                    }
                    
                }) {
                    
                    Text("Join Us").foregroundColor(.white).frame(width: UIScreen.main.bounds.width - 120).padding()
                    
                    
                }.background(
                
                    LinearGradient(gradient: .init(colors: [Color("Color"),Color("Color1"),Color("Color2")]), startPoint: .leading, endPoint: .trailing)
                )
                .clipShape(Capsule())
                .padding(.top, 45)
                .opacity((self.name == "" || self.surname == "" || self.user == "" || self.pass == "") ? 0.35 : 1)
                .disabled((self.name == "" || self.surname == "" || self.user == "" || self.pass == "") ? true : false)
            
            
        }
        .padding()
            .sheet(isPresented: self.$picker, content: {
                
                ImagePicker(picker: self.$picker, imagedata: self.$imagedata)
            })
        .alert(isPresented: $alert) {
                
            Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
        }
        
    }
}
struct type : Identifiable {
        var id : Int
        var percent : CGFloat
        var name : Image
}
var percents = [
    
    type(id: 0, percent: 30, name: Image("Adaptability")),
    type(id: 1, percent: 10, name: Image("Creativity")),
    type(id: 2, percent: 25, name: Image("Enforceability")),
    type(id: 3, percent: 88, name: Image("Healthiness")),
    type(id: 4, percent: 58, name: Image("Intelligence")),
    type(id: 5, percent: 40, name: Image("Leadership Skills")),
    type(id: 6, percent: 29, name: Image("Loyalty")),
    type(id: 7, percent: 40, name: Image("Organizational Skills")),
    type(id: 8, percent: 49, name: Image("Sociability")),
    type(id: 9, percent: 60, name: Image("Diligence"))
    
    ]

struct Bar : View {
    @State var percent : CGFloat = 0
    var name = ""
    
    var body: some View {
        VStack{
            
            Text(String(format: "%.0f", Double(percent))).foregroundColor(Color.black.opacity(0.5))
            Rectangle().fill(Color.purple).frame(width: UIScreen.main.bounds.width / 10 - 9, height: getHeight())
            Image("\(name)")
        }
    }
    func getHeight()->CGFloat {
        return 200 / 100 * percent
    }
}
struct Info : View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            VStack(alignment: .leading, spacing: 20){
                Image("Adaptability")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                Text("Адаптивность")
                    .foregroundColor(.gray)
                    .font(.callout)
                Text("Способность быстро подстраиваться под меняющиеся условия")
                    .font(.subheadline)
            }.padding(12)
            Divider()
            VStack(alignment: .leading, spacing: 20){
                Image("Creativity")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                Text("Креативность")
                    .foregroundColor(.gray)
                    .font(.callout)
                Text("Способность к поиску новых решений")
                    .font(.subheadline)
            }.padding(12)
            Divider()
            VStack(alignment: .leading, spacing: 20){
                Image("Enforceability")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                Text("Исполнительность")
                    .foregroundColor(.gray)
                    .font(.callout)
                Text("Способность четко следовать указаниям")
                    .font(.subheadline)
            }.padding(12)
            Divider()
            VStack(alignment: .leading, spacing: 20){
                Image("Enforceability")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                Text("Исполнительность")
                    .foregroundColor(.gray)
                    .font(.callout)
                Text("Способность четко следовать указаниям")
                    .font(.subheadline)
            }.padding(12)
            Divider()
            VStack(alignment: .leading, spacing: 20){
                Image("Healthiness")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                Text("Здоровье")
                    .foregroundColor(.gray)
                    .font(.callout)
                Text("Совокупность факторов здорового образа жизни")
                    .font(.subheadline)
            }.padding(12)
            Divider()
        }
    }
}
struct Skills_Bar : View {
    @State private var isForm = false
    @State private var isInfo = false
    var body: some View {
        VStack{
            HStack {
                Button(action: {
                    self.isForm.toggle()
                }){
                    Text("Edit")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .frame(width: 150)
                    .background(Color.purple)
                    .clipShape(Capsule())
                    .padding(12)
                }
                    .padding(.top, -200)
                    .sheet(isPresented: $isForm){
                        setB()
                }
                Spacer()
                Button(action: {
                    self.isInfo.toggle()
                }){
                    Image(systemName: "info.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .padding(12)
                }.sheet(isPresented: $isInfo){
                    Info()
                }
                .padding(.top, -190)
            }
            VStack {
        HStack(alignment: .bottom, spacing: 8) {
            ForEach(percents){ i in
                Bar(percent: i.percent)
            }
        }.frame(height: 250)
        HStack(alignment: .bottom, spacing: 9){
            Image("Adaptability")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            Image("Creativity")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            Image("Enforceability")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            Image("Healthiness")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            Image("Intelligence")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            Image("Leadership Skills")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            Image("Loyalty")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            Image("Organizational Skills")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            Image("Sociability")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            Image("Diligence")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
                }
            }
        }
    }
}
struct setB : View {
    @State var c1 : String = ""
    @State var c2 : String = ""
    @State var c3 : String = ""
    @State var c4 : String = ""
    @State var c5 : String = ""
    @State var c6 : String = ""
    @State var c7 : String = ""
    @State var c8 : String = ""
    @State var c9 : String = ""
    @State var c10 : String = ""
    @State var skill = false
    //@State var user =
    var body: some View {
        VStack(alignment: .leading){
            Form {
                Section {
                    Text("Adaptability")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    TextField("Enter percent", text: $c1).keyboardType(.decimalPad)
                }
                Section {
                    Text("Creativity")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    TextField("Enter percent", text: $c2).keyboardType(.decimalPad)
                }
                Section {
                    Text("Enforceability")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    TextField("Enter percent", text: $c3).keyboardType(.decimalPad)
                }
                Section {
                    Text("Healthiness")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    TextField("Enter percent", text: $c4).keyboardType(.decimalPad)
                }
                Section {
                    Text("Intelligence")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    TextField("Enter percent", text: $c5).keyboardType(.decimalPad)
                }
                Section {
                    Text("Leadership Skills")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    TextField("Enter percent", text: $c6).keyboardType(.decimalPad)
                }
                Section {
                    Text("Loyalty")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    TextField("Enter percent", text: $c7).keyboardType(.decimalPad)
                }
                Section {
                    Text("Organizational Skills")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    TextField("Enter percent", text: $c8).keyboardType(.decimalPad)
                }
                Section {
                    Text("Sociability")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    TextField("Enter percent", text: $c9).keyboardType(.decimalPad)
                }
                Section {
                    Text("Diligence")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    TextField("Enter percent", text: $c10).keyboardType(.decimalPad)
                }
            }
            Button(action: {
                self.skill.toggle()
            }) {
                Text("Submit")
                .foregroundColor(.white)
                .fontWeight(.bold)
                .padding(.vertical)
                .frame(width: 150)
                .background(Color.purple)
                .clipShape(Capsule())
                .padding(12)
            }
            .sheet(isPresented: $skill) {
                    Skills_Bar()
            }
        }
    }
}

struct Detail : View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Details")
                .fontWeight(.heavy)
        }
    }
}
struct CircleTab : View {
    
    @Binding var index : Int
    
    var body : some View{
        
        
        HStack{
            
            Button(action: {
                
                self.index = 0
                
            }) {
                
                VStack{
                    
                    if self.index != 0{
                        
                        Image("profile").foregroundColor(Color.black.opacity(0.2))
                    }
                    else{
                        
                        Image("profile")
                            .resizable()
                            .frame(width: 25, height: 23)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("Color1"))
                            .clipShape(Circle())
                            .offset(y: -20)
                            .padding(.bottom, -20)
                        
                        Text("Profile").foregroundColor(Color.black.opacity(0.7))
                    }
                }
                
                
            }
            
            Spacer(minLength: 15)
            
            Button(action: {
                
                self.index = 1
                
            }) {
                
                VStack{
                    
                    if self.index != 1{
                        
                        Image("search").foregroundColor(Color.black.opacity(0.2))
                    }
                    else{
                        
                        Image("search")
                            .resizable()
                            .frame(width: 23, height: 23)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("Color1"))
                            .clipShape(Circle())
                            .offset(y: -20)
                            .padding(.bottom, -20)
                        
                        Text("Search").foregroundColor(Color.black.opacity(0.7))
                    }
                }
            }
            
            Spacer(minLength: 15)
            
            Button(action: {
                
                self.index = 2
                
            }) {
                
                VStack{
                    
                    if self.index != 2{
                        
                        Image("map").foregroundColor(Color.black.opacity(0.2))
                    }
                    else{
                        
                        Image("map")
                            .resizable()
                            .frame(width: 24, height: 22)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("Color1"))
                            .clipShape(Circle())
                            .offset(y: -20)
                            .padding(.bottom, -20)
                        
                        Text("Map").foregroundColor(Color.black.opacity(0.7))
                    }
                }
            }
            
            Spacer(minLength: 15)
            
            Button(action: {
                
                self.index = 3
                
            }) {
                
               VStack{
                   
                   if self.index != 3{
                       
                       Image("spot").foregroundColor(Color.black.opacity(0.2))
                   }
                   else{
                       
                       Image("spot")
                           .resizable()
                           .frame(width: 25, height: 23)
                           .foregroundColor(.white)
                           .padding()
                           .background(Color("Color1"))
                           .clipShape(Circle())
                           .offset(y: -20)
                           .padding(.bottom, -20)
                       
                       Text("Spot").foregroundColor(Color.black.opacity(0.7))
                   }
               }
            }
            
            Spacer(minLength: 15)
            
            Button(action: {
                
                self.index = 4
                
            }) {
                
               VStack{
                   
                   if self.index != 4{
                       
                       Image("settings").foregroundColor(Color.black.opacity(0.2))
                   }
                   else{
                       
                       Image("settings")
                           .resizable()
                           .frame(width: 25, height: 23)
                           .foregroundColor(.white)
                           .padding()
                           .background(Color("Color1"))
                           .clipShape(Circle())
                           .offset(y: -20)
                           .padding(.bottom, -20)
                       
                       Text("Settings").foregroundColor(Color.black.opacity(0.7))
                   }
               }
            }
            
        }.padding(.vertical,-10)
        .padding(.horizontal, 25)
        .background(Color.white)
        .animation(.spring())
    }
}
struct Nav: View {
    @State var index = 0
    var body: some View {
        VStack {
        ZStack{
            
            if self.index == 0{
                Profile()
            }
            else if self.index == 1{
                
                Tinder()
            }
            else if self.index == 2{
                Map()
                
            }
            else if self.index == 3{
                spotP()
            }
            else {
                Settings()
            }
        }
        CircleTab(index: self.$index)
        }
    }
}
struct Home : View {
    var body: some View {
        Nav()
    }
}
struct Testing: View {
    @Binding var percent : CGFloat
    var body: some View{
        ZStack(alignment: .leading){
            ZStack(alignment: .trailing){
                Capsule().fill(Color.black.opacity(0.08))
                    .frame(height: 22)
                Text(String(format: "%.0f", self.percent * 100) + "%").font(.caption).foregroundColor(Color.gray.opacity(0.75)).padding(.trailing)
            }
            Capsule().fill(LinearGradient(gradient: .init(colors: [Color.purple,Color.red]), startPoint: .leading, endPoint: .trailing))
                .frame(width: self.calPercent(), height: 22)
        }.padding(18)
            .background(Color.black.opacity(0.085))
            .cornerRadius(15)
    }
    func calPercent()->CGFloat {
        let width = UIScreen.main.bounds.width - 66
        return width * self.percent
    }
}
struct Questions : View {
    @State var CurrentText = 0
    @State var percent : CGFloat = 0
    @State var count : Int = 0
    @State var load = false
    var body: some View {
        var adapt : CGFloat = 0
        return ZStack {
            VStack(spacing: 20) {
            Button(action: {
                self.load.toggle()
                if self.CurrentText < 3 {
                    self.CurrentText += 1
                }
            }){
                Text("Next")
                .foregroundColor(.white)
                .fontWeight(.bold)
                .padding(.vertical)
                .frame(width: 90)
                .background(Color.purple)
                .clipShape(Capsule())
                .padding(12)
            }
                .animation(.spring())
            ZStack {
                if CurrentText == 0{
                    Text("Вы ощущаете себя уверенно в новом коллективе?")
                    .fontWeight(.semibold)
                }
                else if CurrentText == 1 {
                    Text("Как часто вы отказывались менять работу из-за боязни работы в новом коллективе?")
                    .fontWeight(.semibold)
                }
                else {
                    Text("Готовы ли вы отказаться от своих привычек ради работы мечты?")
                    .fontWeight(.semibold)

                }
            }
            Button(action: {
                    adapt += 1.0
                    self.percent += 0.01
                    self.count += 1
                }){
                    Text("Да")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .frame(width: 150)
                    .background(Color.purple)
                    .cornerRadius(30)
                }
                Button(action: {
                    adapt += 0.5
                     self.percent += 0.01
                    self.count += 1
                }){
                    Text("Отчасти")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .frame(width: 150)
                    .background(Color.purple)
                    .cornerRadius(30)
                }
                Button(action: {
                    adapt += 0
                     self.percent += 0.01
                    self.count += 1
                }){
                    Text("Нет")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .frame(width: 150)
                    .background(Color.purple)
                    .cornerRadius(30)
                    }
            Spacer(minLength: 0)
            Button(action: {
            }){
                Text("Send")
                .foregroundColor(.white)
                .fontWeight(.bold)
                .padding(.vertical)
                .frame(width: 150)
                .background(Color.purple)
                .cornerRadius(30)
                }.opacity((self.count != 3) ? 0.35 : 1)
                .disabled((self.count != 3) ? true : false)
            
                Spacer(minLength: 0)
                Testing(percent: self.$percent).padding(.top, -50)
            }.padding()
            .blur(radius: self.load ? 15 : 0)
            if self.load {
                GeometryReader { _ in
                     Loader()
                }.background(Color.white).edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        self.load.toggle()
                }
            }
        }
    }
}
struct spotP : View {
    var body: some View {
        NavigationView {
        ZStack(alignment: .top){
            VStack(spacing: 5){
                NavigationLink(destination: ApplicationsForSpot()){
                    Text("Applications")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(width: 250)
                        .background(Color.purple)
                        .cornerRadius(30)
                }
                NavigationLink(destination: BookmarksForSpot()){
                    Text("Bookmarks")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(width: 250)
                        .background(Color.purple)
                        .cornerRadius(30)
                }
                NavigationLink(destination: Analytics()){
                    Text("Analytics")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(width: 250)
                        .background(Color.gray)
                        .cornerRadius(30)
                }
            }.padding(.top,-250)
            VStack(spacing: 30){
                
                NavigationLink(destination: Questions()) {
                    Text("Pro-Testing")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                }
                .frame(width: 250)
                .background(
                
                    LinearGradient(gradient: .init(colors: [Color("Color"),Color("Color1"),Color("Color2")]), startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(30)
                
                NavigationLink(destination: Skills_Bar()) {
                    Text("Skills Bar")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                }
                .frame(width: 250)
                .background(
                
                    LinearGradient(gradient: .init(colors: [Color("Color"),Color("Color1"),Color("Color2")]), startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(30)
                Button(action: {
                    
                }){
                    Text("Company mode")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(width: 250)
                        .background(Color.black)
                        .cornerRadius(30)
                        }
                    }
            }.padding(.vertical,320)
        }
        
    }
}
struct Analytics: View {
    @State var selected = 0
    @State var Grid : [Int] = []
    var colors = [Color(.blue),Color(.gray)]
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack{
                HStack{
                    Button(action: {
                        
                    }) {
                        Text("About")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(width: 180)
                        .background(LinearGradient(gradient: .init(colors: [Color(.purple),Color(.red)]), startPoint: .top, endPoint: .bottom))
                        .clipShape(Capsule())
                    }
                }
                VStack(alignment: .leading, spacing: 25){
                    Text("Daily activity").font(.system(size: 22))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 15){
                        ForEach(activeData){ act in
                            VStack{
                                VStack{
                                    Spacer(minLength: 0)
                                    if self.selected == act.id {
                                        Text(self.getHrs(value: act.mins))
                                        .foregroundColor(.white)
                                        .padding(.bottom, 5)
                                    }
                                    RoundShape().fill(LinearGradient(gradient: .init(colors: [Color(.purple),Color(.red)]), startPoint: .top, endPoint: .bottom))
                                        .frame(height: self.getHeight(value: act.mins))
                                }.frame(height: 220)
                                    .onTapGesture {
                                        withAnimation(.easeOut){
                                            self.selected = act.id
                                        }
                                }
                                
                                Text(act.day).foregroundColor(.white)
                                    .font(.caption)
                            }
                        }
                    }
                }.padding()
                    .background(Color.black.opacity(0.9))
                    .cornerRadius(10)
                    .padding()
                
                HStack{
                    Text("Attendance").font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                //.padding()
                ScrollView(.horizontal,showsIndicators: false){
                HStack(spacing: 15){
                    ForEach(stat_data){ stat in
                        VStack(spacing: 22){
                            HStack{
                                Text(stat.title).font(.system(size: 22))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                
                                Spacer(minLength: 0)
                            }
                            ZStack{
                                Circle().trim(from: 0, to: 1)
                                    .stroke(stat.color.opacity(0.05), lineWidth: 10)
                                    .frame(width: (UIScreen.main.bounds.width - 150)/2, height: (UIScreen.main.bounds.width - 150)/2)
                                
                                Circle().trim(from: 0, to: (stat.currentData / stat.goal))
                                .stroke(stat.color, lineWidth: 10)
                                .frame(width: (UIScreen.main.bounds.width - 150)/2, height: (UIScreen.main.bounds.width - 150)/2)
                                
                                Text(self.getPercent(current: stat.currentData, Goal: stat.goal))
                                .font(.system(size: 22))
                                    .fontWeight(.bold)
                                    .foregroundColor(stat.color)
                                    .rotationEffect(.init(degrees: 90))
                            }
                            .rotationEffect(.init(degrees: -90))
                        }.padding()
                        .background(Color.black.opacity(0.9))
                        .cornerRadius(20)
                        .frame(width: (UIScreen.main.bounds.width - 10)/2, height: (UIScreen.main.bounds.width - 10)/2)
                        
                        }
                    }.padding()
                }
            }
        }.background(Color.white.edgesIgnoringSafeArea(.all))
            .padding(.top, -60)
    }
    
    func getPercent(current : CGFloat, Goal: CGFloat)->String{
        let per = (current / Goal) * 100
        return String(format: "%.1f", per)
    }
    func getHeight(value: CGFloat)->CGFloat {
        
        let min = CGFloat(value / 1440) * 200
        
        return min
    }
    func getHrs(value : CGFloat)->String{
        let hrs = value / 60
        
        return String(format: "%.1f", hrs)
    }
}
struct RoundShape : Shape {
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 5, height: 5))
        
        return Path(path.cgPath)
    }
}
struct Stat : Identifiable {
    var id : Int
    var title : String
    var currentData : CGFloat
    var goal : CGFloat
    var color : Color
}
var stat_data = [
    Stat(id: 0, title: "IT", currentData: 7.6, goal: 10, color: .orange),
    Stat(id: 1, title: "Social", currentData: 1.5, goal: 10, color: .pink),
    Stat(id: 2, title: "Food", currentData: 8.6, goal: 10, color: .green)
]
struct Daily : Identifiable {
    var id : Int
    var day : String
    var mins : CGFloat
}
var activeData = [
    Daily(id: 0, day: "Mon", mins: 250),
    Daily(id: 1, day: "Tue", mins: 150),
    Daily(id: 2, day: "Wen", mins: 650),
    Daily(id: 3, day: "Thu", mins: 350),
    Daily(id: 4, day: "Fri", mins: 750),
    Daily(id: 5, day: "Sat", mins: 200),
    Daily(id: 6, day: "Sun", mins: 300)
]

struct Settings: View {
    @State var tog : Bool = false
    @State var tog1 : Bool = false
    @State var tog2 : Bool = false
    //though were going to change content onclick so it must be in @state for dynamic changes...
    
    var body: some View{
        
        ZStack(alignment: .top){
            
            VStack{
               VStack(alignment: .leading, spacing: 5){
                    Toggle(isOn: $tog, label: {
                        Text("Allow access to geoposition")
                        }).padding(5)
                    Divider()
                    Toggle(isOn: $tog1, label: {
                        Text("Allow data sharing")
                        }).padding(5)
                    Divider()
                    Toggle(isOn: $tog2, label: {
                        Text("Auto-match")
                        }).padding(5)
                    Divider()
                }
                .padding(.top, -550)
                Button(action: {
                    
                }) {
                    Text("Delete account")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .frame(width: 180)
                    .background(Color.red)
                    .clipShape(Capsule())
                }
                .padding(.top, -370)
                
                VStack(spacing: 5){
                    Button(action: {
                        
                    }){
                        Text("Pro-mode")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(width: 350)
                        .background(Color.black)
                        .clipShape(Capsule())
                    }
                    // SighOut button
                     Button(action: {
                         
                         
                         try! Auth.auth().signOut()
                        // GIDSignIn.sharedInstance()?.signOut()
                         UserDefaults.standard.set(false, forKey: "status")
                         NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                         
                     }) {
                         
                         Text("Logout")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(width: 350)
                        .background(Color.purple)
                        .clipShape(Capsule())
                    }
                }
                .padding(.top, -180)
            }.padding(.top, 660)
            
            
            
            // now we going to expand circle size...
            // though we re expanding circle size by 200 so we pad horizontal to -100 to fit into screen...
            
            
        }
    }
}
struct Edit : View {
    @State var p1 : String = ""
    @State var p2 : String = ""
    @State var p3 : String = ""
    @State var p4 : String = ""
    @State var p5 : String = ""
    @State var p6 : String = ""
    @State var p7 : String = ""
    @State var p8 : String = ""
    var body: some View {
        VStack(alignment: .leading){
            Form {
                Section {
                    Text("Name")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    TextField("Enter name", text: $p1)
                }
                Section {
                    Text("Surname")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    TextField("Enter surname", text: $p2)
                }
                Section {
                    Text("Age")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    TextField("Enter age", text: $p3)
                }
                Section {
                    Text("Degree")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    TextField("Enter degree", text: $p4)
                }
                Section {
                    Text("Specialization")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    TextField("Enter specialization", text: $p5)
                }
                Section {
                    Text("Position")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    TextField("Enter position", text: $p6)
                }
                Section {
                    Text("Experience")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    TextField("Enter experience", text: $p7)
                }
                Section {
                    Text("About")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    TextField("Enter info", text: $p8)
                }
            }
            Button(action: {
            }) {
                Text("Submit")
                .foregroundColor(.white)
                .fontWeight(.bold)
                .padding(.vertical)
                .frame(width: 150)
                .background(Color.purple)
                .clipShape(Capsule())
                .padding(12)
            }
        }
    }
}
struct Profile: View {
    @State var index = 0
    @State var count = 0
    @State var name = ""
    @State var surname = ""
    @State private var IsBrandPage = false
    @State private var IsEdit = false
    //@State var settings = ""
    var body : some View {
        VStack{
            HStack(spacing: 15) {
                Button(action:{
                    self.IsEdit.toggle()
                }) {
                    Text("Edit")
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color("Color"))
                        .cornerRadius(10)
                }.sheet(isPresented: $IsEdit){
                    Edit()
                }
            }.padding(.top, 5)
                Spacer()
                HStack {                 // start of info1 and photo
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 150){
                            Text("Name")
                                .font(.system(size: 14,weight: .bold))
                                .foregroundColor(Color.black)
                                
                            
                            Text("Andrei")
                                .font(.system(size: 14,weight: .light))
                                .foregroundColor(Color.black)
                        }

                        HStack(spacing: 115) {
                            Text("Surame")
                                .font(.system(size: 14,weight: .bold))
                                .foregroundColor(Color.black)
                                
                            Text("Medvedev")
                                .font(.system(size: 14,weight: .light))
                                .foregroundColor(Color.black)
                        }
                        HStack(spacing: 190) {
                            Text("Age")
                                .font(.system(size: 14,weight: .bold))
                                .foregroundColor(Color.black)
                                
                            Text("19")
                                .font(.system(size: 14,weight: .light))
                                .foregroundColor(Color.black)
                        }
                        Divider()
                    }
                    .padding(.leading, 20)
                    .padding(.top,-50)
                    Spacer(minLength: 15)
                    VStack(spacing: 0){
                        
                        Image("user")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .padding(12)
                        .padding(.top,12)
                        .background(Color(.white))
                        .cornerRadius(10)
                    }
                    .padding(.top,-100)
                    
                }  // end of info1 and photo
            Spacer()
            HStack {      // start of info2
                VStack(alignment: .leading, spacing: 10){
                    HStack(spacing: 140) {
                        Text("Degree")
                            .font(.system(size: 14,weight: .bold))
                            .foregroundColor(Color.black)
                            
                        Text("Student")
                            .font(.system(size: 14,weight: .light))
                            .foregroundColor(Color.black)
                    }
                    HStack(spacing: 115) {
                        Text("Specialization")
                            .font(.system(size: 14,weight: .bold))
                            .foregroundColor(Color.black)
                            
                        Text("Tech")
                            .font(.system(size: 14,weight: .light))
                            .foregroundColor(Color.black)
                    }
                    HStack(spacing: 130) {
                        Text("Position")
                            .font(.system(size: 14,weight: .bold))
                            .foregroundColor(Color.black)
                            
                        Text("Designer")
                            .font(.system(size: 14,weight: .light))
                            .foregroundColor(Color.black)
                    }
                    HStack(spacing: 117) {
                        Text("Experience")
                            .font(.system(size: 14,weight: .bold))
                            .foregroundColor(Color.black)
                            
                        Text("Trainee")
                            .font(.system(size: 14,weight: .light))
                            .foregroundColor(Color.black)
                    }
                    HStack(spacing: 175) {
                        Text("About")
                            .font(.system(size: 14,weight: .bold))
                            .foregroundColor(Color.black)
                            
                        Text("Info")
                            .font(.system(size: 14,weight: .light))
                            .foregroundColor(Color.black)
                    }
                    Divider()
                }.padding(.leading, 20)
                    .padding(.top, -60)
                Spacer(minLength: 15)
            } // end of info 2
            
            TopBar(count: self.$count)
            if self.count == 0 {
                Applications()
            }
            else {
                Bookmarks()
            }
            Button(action: {
                self.IsBrandPage.toggle()
            }) {
                Text("Show all")
                .foregroundColor(.white)
                .fontWeight(.bold)
                .padding(.vertical)
                .frame(width: 150)
                .background(Color.purple)
                .clipShape(Capsule())
            }.padding(.top, 50)
            .cornerRadius(20)
                //.background(Color.purple)
                .sheet(isPresented: $IsBrandPage) {
                    BrandPage()
            }
            Spacer(minLength: 0)
        }
    }
}
struct Applications : View {
    var body: some View {
        ScrollView(.horizontal,showsIndicators: false){
        HStack(spacing: 20) {
            VStack(spacing: 12) {
                Image("dodo")
                .resizable()
                .frame(width: 40, height: 40)
                
                Text("DODO")
                    .font(.title)
                    .padding(.top, 10)
                 Text("Food")
                    .font(.caption)
                    .foregroundColor(.gray)
            } .padding(.vertical)
                .frame(width: (UIScreen.main.bounds.width - 10)/2)
                .background(Color(.white))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 8, y: 8)
                .shadow(color: Color.white.opacity(0.5), radius: 10, x: -8, y: -8)
            
            VStack(spacing: 12) {
                Image("mac")
                .resizable()
                .frame(width: 40, height: 40)
                
                Text("Macdonalds")
                    .font(.title)
                    .padding(.top, 10)
                
                 Text("Food")
                    .font(.caption)
                    .foregroundColor(.gray)
            } .padding(.vertical)
                .frame(width: (UIScreen.main.bounds.width - 20)/2)
                .background(Color(.white))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 8, y: 8)
                .shadow(color: Color.white.opacity(0.5), radius: 10, x: -8, y: -8)
            VStack(spacing: 12) {
                Image("mac")
                .resizable()
                .frame(width: 40, height: 40)
                
                Text("Macdonalds")
                    .font(.title)
                    .padding(.top, 10)
                
                 Text("Food")
                    .font(.caption)
                    .foregroundColor(.gray)
            } .padding(.vertical)
                .frame(width: (UIScreen.main.bounds.width - 20)/2)
                .background(Color(.white))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 8, y: 8)
                .shadow(color: Color.white.opacity(0.5), radius: 10, x: -8, y: -8)
            } .padding(.top, 10)
        }.edgesIgnoringSafeArea(.bottom)
    }
}
struct ApplicationsForSpot : View {
    var body: some View {
        HStack(spacing: 20) {
            VStack(spacing: 12) {
                Image("dodo")
                .resizable()
                .frame(width: 40, height: 40)
                
                Text("DODO")
                    .font(.title)
                    .padding(.top, 10)
                 Text("Food")
                    .font(.caption)
                    .foregroundColor(.gray)
                Button(action: {
                    
                }){
                    Text("Show").foregroundColor(.purple)
                }
            } .padding(.vertical)
                .frame(width: (UIScreen.main.bounds.width - 10)/2)
                .background(Color(.white))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 8, y: 8)
                .shadow(color: Color.white.opacity(0.5), radius: 10, x: -8, y: -8)
            
            VStack(spacing: 12) {
                Image("mac")
                .resizable()
                .frame(width: 40, height: 40)
                
                Text("Macdonalds")
                    .font(.title)
                    .padding(.top, 10)
                
                 Text("Food")
                    .font(.caption)
                    .foregroundColor(.gray)
                Button(action: {
                    
                }){
                    Text("Show").foregroundColor(.purple)
                }
            } .padding(.vertical)
                .frame(width: (UIScreen.main.bounds.width - 20)/2)
                .background(Color(.white))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 8, y: 8)
                .shadow(color: Color.white.opacity(0.5), radius: 10, x: -8, y: -8)
            } .padding(.top, 10)
    }
}
struct BookmarksForSpot : View {
    var body: some View {
        HStack(spacing: 20) {
            VStack(spacing: 12) {
                Image("apple")
                .resizable()
                .frame(width: 40, height: 40)
                
                Text("Apple")
                    .font(.title)
                    .padding(.top, 10)
                 Text("IT")
                    .font(.caption)
                    .foregroundColor(.gray)
                Button(action: {
                    
                }){
                    Text("Show").foregroundColor(.purple)
                }
            } .padding(.vertical)
                .frame(width: (UIScreen.main.bounds.width - 10)/2)
                .background(Color(.white))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 8, y: 8)
                .shadow(color: Color.white.opacity(0.5), radius: 10, x: -8, y: -8)
            VStack(spacing: 12) {
                Image("gasprom")
                .resizable()
                .frame(width: 40, height: 40)
                
                Text("Gasprom")
                    .font(.title)
                    .padding(.top, 10)
                 Text("ECO")
                    .font(.caption)
                    .foregroundColor(.gray)
                Button(action: {
                    
                }){
                    Text("Show").foregroundColor(.purple)
                }
            } .padding(.vertical)
                .frame(width: (UIScreen.main.bounds.width - 10)/2)
                .background(Color(.white))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 8, y: 8)
                .shadow(color: Color.white.opacity(0.5), radius: 10, x: -8, y: -8)
        } .padding(.top, 10)
    }
}
struct Bookmarks : View {
    var body: some View {
        ScrollView(.horizontal,showsIndicators: false){
        HStack(spacing: 20) {
            VStack(spacing: 12) {
                Image("apple")
                .resizable()
                .frame(width: 40, height: 40)
                
                Text("APPLE")
                    .font(.title)
                    .padding(.top, 10)
                 Text("IT")
                    .font(.caption)
                    .foregroundColor(.gray)
            } .padding(.vertical)
                .frame(width: (UIScreen.main.bounds.width - 10)/2)
                .background(Color(.white))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 8, y: 8)
                .shadow(color: Color.white.opacity(0.5), radius: 10, x: -8, y: -8)
            VStack(spacing: 12) {
                Image("gasprom")
                .resizable()
                .frame(width: 40, height: 40)
                
                Text("Gasprom")
                    .font(.title)
                    .padding(.top, 10)
                 Text("ECO")
                    .font(.caption)
                    .foregroundColor(.gray)
            } .padding(.vertical)
                .frame(width: (UIScreen.main.bounds.width - 10)/2)
                .background(Color(.white))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 8, y: 8)
                .shadow(color: Color.white.opacity(0.5), radius: 10, x: -8, y: -8)
            VStack(spacing: 12) {
                Image("mac")
                .resizable()
                .frame(width: 40, height: 40)
                
                Text("Macdonalds")
                    .font(.title)
                    .padding(.top, 10)
                
                 Text("Food")
                    .font(.caption)
                    .foregroundColor(.gray)
            } .padding(.vertical)
                .frame(width: (UIScreen.main.bounds.width - 20)/2)
                .background(Color(.white))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 8, y: 8)
                .shadow(color: Color.white.opacity(0.5), radius: 10, x: -8, y: -8)
            } .padding(.top, 10)
        }
    }
}
struct TopBar: View {
    @Binding  var count : Int
    var body: some View {
        HStack {
            Button(action: {
                self.count = 0
            }) {
                Text("Applications")
                    .foregroundColor(self.count == 0 ? Color.white : .gray)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(self.count == 0 ? Color("Color2"): Color.clear )
                    .cornerRadius(10)
            }
            
            Spacer(minLength: 0)
            
            Button(action: {
                self.count = 1
            }) {
                Text("Bookmarks")
                    .foregroundColor(self.count == 1 ? Color.white : .gray)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(self.count == 1 ? Color("Color2"): Color.clear )
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Color(.white))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 8, y: 8)
        .shadow(color: Color.white.opacity(0.5), radius: 10, x: -8, y: -8)
        .padding(.horizontal)
        .padding(.top, 5)
    }
}
struct Map: View {
    @State private var IsDetail = false
    @State var manager = CLLocationManager()
    @State var alert = false
    @State var index = 0
    @State var open = false
    @State var offset : CGFloat = -UIScreen.main.bounds.height
    @ObservedObject private var locationManager = LocationManager()
    var body: some View {
        ZStack {
            
          VStack {
            HStack{
                
                Button(action: {
                    
                    self.index = 0
                    
                }) {
                    
                    Text("By Match")
                        .foregroundColor(self.index == 0 ? Color.white : .gray)
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(self.index == 0 ? Color.purple : Color.clear)
                        .cornerRadius(10)
                }
                
                Spacer(minLength: 0)
                
                Button(action: {
                    
                    self.index = 1
                    
                }) {
                    
                    Text("By Offer")
                        .foregroundColor(self.index == 1 ? Color.white : .gray)
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(self.index == 1 ? Color.purple : Color.clear)
                        .cornerRadius(10)
                }
                
                Spacer(minLength: 0)
                
                Button(action: {
                    
                    self.index = 2
                    
                }) {
                    
                    Text("By Rating")
                        .foregroundColor(self.index == 2 ? Color.white : .gray)
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(self.index == 2 ? Color.purple : Color.clear)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal,8)
            .padding(.vertical,5)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 8, y: 8)
            .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
            .padding(.horizontal)
            .padding(.top,55)
        
            VStack(spacing: 20) {
                
                MapView(manager: $manager, alert: $alert).alert(isPresented: $alert) {
            
            Alert(title: Text("Please Enable Location Access In Settings Pannel !!!"))
        }.padding(.vertical, 0)
            
            .padding(.top, -70)
            .padding(.horizontal, 10)
                HStack(spacing: 55) {
             Text("Spot Info")
                .font(.system(size: 20, weight: .bold))
                    HStack{
                        
                        Image(systemName: "flame.fill")
                        .resizable()
                        .frame(width: 25, height: 35)
                        .foregroundColor(.white)
                        
                        VStack(alignment: .leading, spacing: 4){
                            
                            Text("89%")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                            
                            Text("Match")
                                .foregroundColor(.white)
                                .font(.system(size: 12, weight: .semibold))
                            
                        }
                        .padding(.leading, 0)
                    }
                    .padding()
                    .background(Color.purple)
                    .cornerRadius(10)
                    
                    
                    Image("dodo")
                    .resizable()
                        .frame(width: 60, height: 60)
                }
                Divider()
                HStack(spacing: 215) {
                Text("Name:")
                   .font(.system(size: 14, weight: .semibold))
                   .padding()
                           
                
                       
                    Text("DODO Pizza")
                        .font(.system(size: 12, weight: .light))
                        .padding(.horizontal, 10)
                }.padding(.vertical, -10)
                HStack(spacing: 225) {
                Text("Position:")
                   .font(.system(size: 14, weight: .semibold))
                   .padding()
                           
                  
                       
                    Text("Cashier")
                        .font(.system(size: 12, weight: .light))
                        .padding(.horizontal, 10)
                }.padding(.vertical, -10)
                HStack(spacing: 265) {
                Text("Rating:")
                   .font(.system(size: 14, weight: .semibold))
                   .padding()
                           
                   
                       
                    Text("82")
                        .font(.system(size: 12, weight: .light))
                        .padding(.horizontal, 10)
                }.padding(.vertical, -10)
                HStack(spacing: 175) {
                Text("Requirements:")
                   .font(.system(size: 14, weight: .semibold))
                   .padding()
                           
                       
                    Button(action: {
                        self.offset = 0
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6){
                             self.open.toggle()
                        }
                
                    }) {
                        Text("Details")
                            .foregroundColor(Color.purple)
                            .padding(.horizontal, 10)
                    }
                }.padding(.vertical, -10)
                    
                
                    
                HStack(spacing: 65) {
                Button(action: {
                    
                }) {
                    
                    Text("View Profile")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(width: 150)
                        .background(Color.purple)
                    .cornerRadius(30)
                }
                .padding(.bottom, -340)
                
                Button(action: {
                    
                }) {
                    
                    Text("Apply")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(width: 150)
                        .background(Color.purple)
                        .cornerRadius(30)
                }
                .padding(.bottom, -340)
            }

                }.padding(.vertical, 100)
            }
        }
    }
}
struct MapView : UIViewRepresentable {
    
    @Binding var manager : CLLocationManager
    @Binding var alert : Bool
    let map = MKMapView()
    
    func makeCoordinator() -> MapView.Coordinator {
        return Coordinator(parent1: self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        
        
        let center = CLLocationCoordinate2D(latitude: 13.086, longitude: 80.2707)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        map.region = region
        manager.requestWhenInUseAuthorization()
        manager.delegate = context.coordinator
        manager.startUpdatingLocation()
        return map
    }
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        
    }
    class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
        
        private let locationmanager = CLLocationManager()
        @Published var location: CLLocation? = nil
        
        override init() {
            super.init()
            self.locationmanager.delegate = self
            self.locationmanager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationmanager.distanceFilter = kCLDistanceFilterNone
            self.locationmanager.requestWhenInUseAuthorization()
            self.locationmanager.startUpdatingHeading()
        }
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            guard let location = locations.last else {
                return
            }
            self.location = location
        }
    }
    class Coordinator : NSObject,CLLocationManagerDelegate{
        
        var parent : MapView
        
        init(parent1 : MapView) {
            
            parent = parent1
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            
            if status == .denied{
                
                parent.alert.toggle()
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            let location = locations.last
            let point = MKPointAnnotation()
            
            let georeader = CLGeocoder()
            georeader.reverseGeocodeLocation(location!) { (places, err) in
                
                if err != nil{
                    
                    print((err?.localizedDescription)!)
                    return
                }
                
                let place = places?.first?.locality
                point.title = place
                point.subtitle = "Current"
                point.coordinate = location!.coordinate
                self.parent.map.removeAnnotations(self.parent.map.annotations)
                self.parent.map.addAnnotation(point)
                
                let region = MKCoordinateRegion(center: location!.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                self.parent.map.region = region
            }
        }
    }
}

struct BrandPage : View {
    
    @State var width = UIScreen.main.bounds.width
    
    
    //though were going to change content onclick so it must be in @state for dynamic changes...
    
    @State var data = [

        DataType(name: "DODO pizza", field: "Food", content: "Top rated food company which makes pizza", match: "89%", expand: ["Moscow","Requirements","82","Salesman"],color: Color("dodo"),image: "dodo"),
        
        DataType(name: "Macdonalds", field: "Food", content: "Top rated fast-food company which makes everything", match: "98%", expand: ["Moscow","Requirements","99","Cashier"],color: Color("mac"),image: "mac"),
        
        DataType(name: "Apple", field: "IT", content: "Top rated IT company in the world", match: "20%", expand: ["Cupertino","Requirements","100","Assistant"], color: Color("apple"), image: "apple"),
        
        DataType(name: "Gasprom", field: "Eco", content: "Russian gas company", match: "80%", expand: ["Moscow","Requirements","50","Engineer"], color: Color("gasprom"), image: "gasprom")
        
            

    ]
    
    @State var index = 0
    
    var body: some View{
        
        ZStack(alignment: .top){
            
            VStack{
                HStack{
                    
                    Button(action: {
                        
                        
                    }) {
                        
                        HStack{
                            
                            Image("bookmarks1")
                                .renderingMode(.original)
                                .background(self.data[self.index].color)
                            
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }) {
                        
                        Image("map")
                            .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                    }
                }
                .padding(.top, 20)
                HStack{
                    
                    Button(action: {
                        
                        if self.index != 0{
                            
                            self.index -= 1
                        }
                        
                    }) {
                     
                        Image("left")
                            .renderingMode(.original)
                    }
                    .opacity(self.index != 0 ? 1 : 0.5)
                    .disabled(self.index != 0 ? false : true)
                    
                    Image(self.data[self.index].image)
                    
                    Button(action: {
                        
                        if self.index != self.data.count - 1{
                            
                            self.index += 1
                        }
                        
                    }) {
                     
                        Image("right")
                            .renderingMode(.original)
                    }
                    .opacity(self.index != self.data.count - 1 ? 1 : 0.5)
                    .disabled(self.index != self.data.count - 1 ? false : true)
                    
                    // disabling the button at the end of the array....
                }
                .padding(.top, 20)
                
                VStack(spacing: 20){
                    
                    Text(self.data[self.index].name)
                        .fontWeight(.bold)
                        .font(.title)
                        //.padding(.top, 5)
                    
                    Text(self.data[self.index].field)
                        .fontWeight(.bold)
                    
                    Text(self.data[self.index].content)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                    

                    
                    HStack{
                        
                        Image(systemName: "flame.fill")
                        .resizable()
                        .frame(width: 25, height: 35)
                        .foregroundColor(.white)
                        
                        VStack(alignment: .leading, spacing: 4){
                            
                            Text(self.data[self.index].match)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                            
                            Text("Match")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                        .padding(.leading, 20)
                    }
                    .padding()
                    .background(Color.purple)
                    .cornerRadius(10)
                    
                    HStack(spacing: 60){
                        
                        VStack(alignment: .center, spacing: 10) {
                            
                            Text(self.data[self.index].expand[0])
                                .fontWeight(.bold)
                            
                            Text("City")
                                .foregroundColor(.gray)
                        }
                        
                        
                        
                        VStack(alignment: .center, spacing: 10) {
                            
                            Text(self.data[self.index].expand[2])
                                .fontWeight(.bold)
                            
                            Text("Rating")
                                .foregroundColor(.gray)
                        }
                        VStack(alignment: .center, spacing: 10) {
                            
                            Text(self.data[self.index].expand[3])
                                .fontWeight(.bold)
                            
                            Text("Position")
                                .foregroundColor(.gray)
                        }
                        
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    Drop()
                    Spacer(minLength: 0)
                    
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                
                Button(action: {
                    
                }) {
                    
                    Text("Apply")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(width: self.width - 50)
                        .background(Color.purple)
                        .clipShape(Capsule())
                }
                .padding(.bottom, 25)
            }
            .zIndex(1)
            // zindex swap positions in the stack....
            
            // now going to create top curve...
            // follow me....
            
            Circle()
                .fill(self.data[self.index].color)
            .frame(width: self.width + 200, height: self.width + 200)
            .padding(.horizontal, -100)
                
            // moving view up ...
            .offset(y: -self.width)
            
            // now we going to expand circle size...
            // though we re expanding circle size by 200 so we pad horizontal to -100 to fit into screen...
            
            
        }
        .animation(.default)
    }
}

struct Drop: View {
    
    @State var expand = false
    var body: some View {
        
        VStack(alignment: .leading, spacing: 5, content:  {
            HStack {
                Text("Requirements").fontWeight(.bold).foregroundColor(Color.white)
                
                Image(systemName: expand ? "chevron.up" : "chevron.down").resizable().frame(width: 10, height: 10).foregroundColor(Color.white)
            }.onTapGesture {
                self.expand.toggle()
                
            }
            if expand {
                VStack{
                    HStack(spacing: 10){
                        Text("Rating").font(.system(size: 15, weight: .semibold))
                        Text("75").font(.system(size: 15, weight: .bold))
                    }
                        .foregroundColor(Color.white)
                    HStack(spacing: 5){
                        Text("Experience").font(.system(size: 15, weight: .semibold))
                        Text("Trainee").font(.system(size: 15, weight: .bold))
                        }
                        .foregroundColor(Color.white)
                    }
                }
            })
            .padding(.horizontal,45)
        .background(LinearGradient(gradient: .init(colors: [.purple,.purple]), startPoint: .top, endPoint: .bottom))
        .cornerRadius(20)
        .animation(.spring())
        }
    }
// sample data.....

struct DataType {
    
    var name : String
    var field : String
    var content : String
    var match : String
    var expand : [String]
    var color : Color
    var image : String
}
struct Tinder : View {
    
    @State var width = UIScreen.main.bounds.width
    
    
    //though were going to change content onclick so it must be in @state for dynamic changes...
    
    @State var data = [

        DataType(name: "DODO pizza", field: "Food", content: "Top rated food company which makes pizza", match: "89%", expand: ["Moscow","Requirements","82","Salesman"],color: Color("dodo"),image: "dodo"),
        
        DataType(name: "Macdonalds", field: "Food", content: "Top rated fast-food company which makes everything", match: "98%", expand: ["Moscow","Requirements","99","Cashier"],color: Color("mac"),image: "mac")
            

    ]
    
    @State var index = 0
    
    var body: some View{
        
        ZStack(alignment: .top){
            
            VStack{
                HStack{
                    
                    Button(action: {
                        
                        
                    }) {
                        
                        HStack(spacing: 10){
                            
                            Image("bookmarks1")
                                .renderingMode(.original)
                                .background(self.data[self.index].color)
                            
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }) {
                        
                        Image("map")
                            .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                    }
                }
                .padding(.top, 40)
                HStack{
                    
                    Button(action: {
                        
                        if self.index != 0{
                            
                            self.index -= 1
                        }
                        
                    }) {
                     
                        Image("left")
                            .renderingMode(.original)
                    }
                    .opacity(self.index != 0 ? 1 : 0.5)
                    .disabled(self.index != 0 ? false : true)
                    
                    Image(self.data[self.index].image)
                    
                    Button(action: {
                        
                        if self.index != self.data.count - 1{
                            
                            self.index += 1
                        }
                        
                    }) {
                     
                        Image("right")
                            .renderingMode(.original)
                    }
                    .opacity(self.index != self.data.count - 1 ? 1 : 0.5)
                    .disabled(self.index != self.data.count - 1 ? false : true)
                    
                    // disabling the button at the end of the array....
                }
                .padding(.top, -20)
                
                VStack(spacing: 20){
                    
                    Text(self.data[self.index].name)
                        .fontWeight(.bold)
                        .font(.title)
                        //.padding(.top, 5)
                    
                    Text(self.data[self.index].field)
                        .fontWeight(.bold)
                    
                    Text(self.data[self.index].content)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                    

                    
                    HStack{
                        
                        Image(systemName: "flame.fill")
                        .resizable()
                        .frame(width: 25, height: 35)
                        .foregroundColor(.white)
                        
                        VStack(alignment: .leading, spacing: 4){
                            
                            Text(self.data[self.index].match)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                            
                            Text("Match")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                        .padding(.leading, 20)
                    }
                    .padding()
                    .background(Color.purple)
                    .cornerRadius(10)
                    
                    HStack(spacing: 60){
                        
                        VStack(alignment: .center, spacing: 10) {
                            
                            Text(self.data[self.index].expand[0])
                                .fontWeight(.bold)
                            
                            Text("City")
                                .foregroundColor(.gray)
                        }
                        
                        
                        
                        VStack(alignment: .center, spacing: 10) {
                            
                            Text(self.data[self.index].expand[2])
                                .fontWeight(.bold)
                            
                            Text("Rating")
                                .foregroundColor(.gray)
                        }
                        /*VStack(alignment: .center, spacing: 10) {
                            
                            Text(self.data[self.index].expand[3])
                                .fontWeight(.bold)
                            
                            Text("Position")
                                .foregroundColor(.gray)
                        } */
                        
                    }
                    .padding(.horizontal)
                    .padding(.top, -10)
                    
                    HStack {
                        Text("Position:")
                            .fontWeight(.bold)
                        Text("Salesman")
                            .font(.system(size:18, weight: .semibold))
                    }
                    DropT()
                    Spacer(minLength: 0)
                    
                }
                .padding(.horizontal, 20)
                .padding(.top, -5)
                
                HStack(spacing: 50) {
                Button(action: {
                    
                }) {
                    
                    Text("Apply")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(width: 150)
                        .background(Color.purple)
                        .clipShape(Capsule())
                }
                .padding(.bottom, 65)
                    Button(action: {
                        
                    }) {
                        
                        Text("Decline")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .frame(width: 150)
                            .background(Color.red)
                            .clipShape(Capsule())
                    }
                    .padding(.bottom, 65)
                }
            }
            .zIndex(1)
            // zindex swap positions in the stack....
            
            // now going to create top curve...
            // follow me....
            
            Circle()
                .fill(self.data[self.index].color)
            .frame(width: self.width + 200, height: self.width + 200)
            .padding(.horizontal, -100)
                
            // moving view up ...
            .offset(y: -self.width)
            
            // now we going to expand circle size...
            // though we re expanding circle size by 200 so we pad horizontal to -100 to fit into screen...
            
            
        }
        .animation(.default)
    }
}

struct DropT: View {
    
    @State var expand = false
    var body: some View {
        
        VStack(alignment: .leading, spacing: 5, content:  {
            
            HStack {
                Text("Requirements").fontWeight(.bold).foregroundColor(Color.white)
                
                Image(systemName: expand ? "chevron.up" : "chevron.down").resizable().frame(width: 10, height: 10).foregroundColor(Color.white)
            }.onTapGesture {
                self.expand.toggle()
                
            }
            if expand {
                VStack{
                    HStack(spacing: 10){
                        Text("Rating").font(.system(size: 15, weight: .semibold))
                        Text("75").font(.system(size: 15, weight: .bold))
                    }
                        .foregroundColor(Color.white)
                    HStack(spacing: 5){
                        Text("Experience").font(.system(size: 15, weight: .semibold))
                        Text("Trainee").font(.system(size: 15, weight: .bold))
                        }
                        .foregroundColor(Color.white)
                    
                    }
                }
            })
            .padding(.horizontal,45)
        .background(LinearGradient(gradient: .init(colors: [.black,.black]), startPoint: .top, endPoint: .bottom))
        .cornerRadius(20)
        .animation(.spring())
        }
    }
// sample data.....
struct btnView: View {
    var image = ""
    var name = ""
    var body: some View {
        
        Button(action: {
            
        }) {
            HStack {
                Image(image).renderingMode(.original).resizable().frame(width: 40, height: 40)
                Text(name)
                
                Spacer(minLength: 15)
                
                Image(systemName: "chevron.right")
                
                } .padding()
                .foregroundColor(Color.black.opacity(0.5))
        }
    }
}
struct Blur : UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<Blur>) -> UIVisualEffectView {
        let effect = UIBlurEffect(style: .systemMaterialDark)
        let view = UIVisualEffectView(effect: effect)
        return view
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Blur>) {
        
    }
}
struct Loader : View {
    @State var animate = false
    var body: some View {
        VStack{
            Circle()
                .trim(from: 0, to: 0.8)
                .stroke(AngularGradient(gradient: .init(colors: [Color.purple,Color.red]), center: .center), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .frame(width: 45, height: 45)
                .rotationEffect(.init(degrees: self.animate ? 360 : 0))
                .animation(Animation.linear(duration: 0.7).repeatForever(autoreverses: false))
            Text("Loading...").padding(.top)
        }
         .padding(20)
        .background(Color.white)
        .cornerRadius(15)
        .onAppear{
            self.animate.toggle()
        }
        
    }
}
func signInWithEmail(email: String,password : String, completion: @escaping (Bool,String)->Void){
    
    Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
        
        if err != nil{
            
            completion(false,(err?.localizedDescription)!)
            return
        }
        
        completion(true,(res?.user.email)!)
    }
}

func signIupWithEmail(email: String,password : String,name: String, surname: String, completion: @escaping (Bool,String)->Void){
    
    Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
    
        if err != nil{
            
            completion(false,(err?.localizedDescription)!)
            return
        }
        
        completion(true,(res?.user.email)!)
    }
}

/*func signOutWithEmail(){
    
    let user = Auth.auth().currentUser

    user?.delete { error in
      if  error != nil {
        // An error happened.
      } else {
        DataService.ds.deleteCurrentFirebaseDBUser()
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
      }
    }
} */
