//
//  NewIdentityScreen.swift
//  NativeSigner
//
//  Created by Alexander Slesarev on 4.8.2021.
//

import SwiftUI

struct NewAddressScreen: View {
    
    enum Field: Hashable {
        case path
        case password
        case passwordCheck
    }
    
    @EnvironmentObject var data: SignerDataModel
    @State private var password: String = ""
    @State private var passwordCheck: String = ""
    @FocusState private var focusedField: Field?
    
    var body: some View {
        ZStack {
            ModalBackdrop()
            VStack {
                HStack {
                    NetworkCard(network: data.selectedNetwork)
                    Spacer()
                    VStack {
                        Text("seed").font(.footnote)
                        Text(data.selectedSeed)
                            .font(.headline)
                    }
                }.padding(.bottom, 40)
                if !data.lastError.isEmpty {
                    Text(data.lastError)
                        .foregroundColor(.red)
                        .lineLimit(nil)
                }
                VStack (alignment: .leading) {
                    Text("PATH").foregroundColor(Color("textMainColor")).font(.footnote)
                    ZStack {
                    RoundedRectangle(cornerRadius: 8).stroke(Color("AccentColor")).foregroundColor(Color("backgroundColor")).frame(height: 39)
                    TextField("Path", text: $data.suggestedPath, prompt: Text("Path: //hard/soft"))
                        .foregroundColor(Color("textEntryColor"))
                        .font(.system(size: 15, design: .monospaced))
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .keyboardType(.asciiCapable)
                        .submitLabel(.done)
                        .onChange(of: data.suggestedPath) {path in
                            data.lastError = ""
                        }
                        .focused($focusedField, equals: .path)
                        .padding(8)
                    }
                }
                VStack (alignment: .leading) {
                    Text("OPTIONAL PASSWORD").foregroundColor(Color("textMainColor")).font(.footnote)
                    ZStack {
                        RoundedRectangle(cornerRadius: 8).stroke(Color("AccentColor")).foregroundColor(Color("backgroundColor")).frame(height: 39)
                    TextField("Password", text: $password, prompt: Text("(optional)"))
                        .foregroundColor(Color("textEntryColor"))
                        .font(.system(size: 15, design: .monospaced))
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .keyboardType(.asciiCapable)
                        .submitLabel(.next)
                        .onChange(of: data.suggestedName, perform: {_ in data.lastError = ""
                        })
                        .focused($focusedField, equals: .password)
                        .onSubmit({if password != "" {
                            focusedField = .passwordCheck
                        }})
                        .padding(8)
                    }
                }
                if password != "" {
                    VStack (alignment: .leading) {
                        Text("REPEAT PASSWORD").foregroundColor(Color("textMainColor")).font(.footnote)
                        ZStack {
                            RoundedRectangle(cornerRadius: 8).stroke(Color("AccentColor")).foregroundColor(Color("backgroundColor")).frame(height: 39)
                        TextField("Repeat", text: $passwordCheck, prompt: Text("password"))
                            .foregroundColor(Color("textEntryColor"))
                            .font(.system(size: 15, design: .monospaced))
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .keyboardType(.asciiCapable)
                            .submitLabel(.done)
                            .onChange(of: data.suggestedName, perform: {_ in data.lastError = ""
                            })
                            .focused($focusedField, equals: .passwordCheck)
                            .padding(8)
                        }
                    }}
                HStack {
                    Button(action: {
                        data.createAddress(password: password)
                        if data.lastError == "" {
                            data.keyManagerModal = .none
                        }
                    }) {
                        Text("Create")
                            .font(.largeTitle)
                    }
                    .disabled(password != passwordCheck)
                }
            }.padding(.horizontal)
        }
        .onAppear {
            data.lastError = ""
            focusedField = .path
        }
        .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("backgroundColor")/*@END_MENU_TOKEN@*/)
    }
}

/*
 struct NewIdentityScreen_Previews: PreviewProvider {
 static var previews: some View {
 NewIdentityScreen().previewLayout(.sizeThatFits)
 }
 }
 */
