//
//  ControlPanelContentView.swift
//  JarvisControlPanel
//
//  Created by Josh Spicer on 3/11/23.
//

import SwiftUI

struct ControlPanelContentView: View {
  var model: JarvisModel
  @State private var status: String = "READY"
  @State private var nodeResponse: NodeResponse? = nil
  @State private var secret: String = ""
  @FocusState var isInputActive: Bool
  var body: some View {
    ZStack {
      VStack {

        // Centered horizontally
        HStack {
          Image(systemName: "key.viewfinder")
          SecureField(
            "Reset Secret...",
            text: $secret
          )
          .focused($isInputActive)
          .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
              Spacer()

              Button("Hide") {
                isInputActive = false
              }
            }
          }
          // Button to Save the secret persistently and clear the input
          Button(
            action: {
              model.setSecret(newSecret: $secret.wrappedValue)
              secret = ""
            },
            label: {
              Image(systemName: "goforward.plus")
            }
          )

        }
        .padding()
        // Transparent background color (full alpha)
        Text(status)
          .font(.system(size: 14))
          .padding(10)
          .padding([.leading, .trailing], 50)
          .background(.gray)
          .cornerRadius(20)
          .foregroundColor(Color.white)

        Spacer()
        NodeResponseView(data: nodeResponse)
        Spacer()

        HStack {
          Spacer()

          Button(
            action: {
              status = "..."
              model.query(
                q: QueryRequest.Node(
                  "info",
                  "GET",
                  QueryType.JSON,
                  AuthMode.HMAC,
                  CertMode.ClientCert), status: $status, responseData: $nodeResponse)

            },
            label: {
              Image(systemName: "icloud.and.arrow.down")
                .font(.system(.largeTitle))
                .frame(width: 77, height: 70)
                .foregroundColor(Color.white)
                .padding(.bottom, 7)
            }
          )
          .background(Color(red: 34 / 255, green: 139 / 255, blue: 34 / 255))
          .cornerRadius(38.5)
          .padding()
          .shadow(
            color: Color.black.opacity(0.3),
            radius: 3,
            x: 3,
            y: 3)
        }
      }
    }
  }
}

struct ControlPanelContentView_Previews: PreviewProvider {
  static var previews: some View {
    ControlPanelContentView(model: JarvisModel())
  }
}
