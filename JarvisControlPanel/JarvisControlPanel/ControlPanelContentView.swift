//
//  ControlPanelContentView.swift
//  JarvisControlPanel
//
//  Created by Josh Spicer on 3/11/23.
//

import MapKit
import SwiftUI


struct ControlPanelContentView: View {
  var model: JarvisModel
  @State private var nodeStatus: String = ""
  @State private var nodeResponse: NodeResponse? = nil
    @State private var clusterStatus: String = ""
  @State private var clusterResponse: ClusterResponse? = nil
    
    // Update secret
    @State private var isShowingUpdateSecretPrompt = false
    @State private var updateSecretInput = ""

    
  var body: some View {
      NavigationView {
          ZStack {
              VStack {
                  NodeResponseView(data: nodeResponse, status: nodeStatus)
                  ClusterResponseView(data: clusterResponse, status: clusterStatus)
                  Spacer()
                  HStack {
                      Spacer()
                      Button(
                        action: {
                            nodeStatus = "..."
                            clusterStatus = "..."
                            model.query(
                                q: QueryRequest.Node(
                                    "info",
                                    "GET",
                                    QueryType.JSON,
                                    AuthMode.HMAC,
                                    CertMode.ClientCert), status: $nodeStatus, responseData: $nodeResponse)
                            
                            model.query(
                                q: QueryRequest.Cluster(
                                    "info2",
                                    "GET",
                                    QueryType.JSON,
                                    AuthMode.HMAC,
                                    CertMode.ClientCert), status: $clusterStatus, responseData: $clusterResponse)
                            
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
          .toolbar {
              ToolbarItemGroup(placement: .navigationBarTrailing) {
                  
                  Menu {
                    
                    Button(action: {
                          withAnimation {
                              self.isShowingUpdateSecretPrompt.toggle()
                          }
                      })
                      {
                          Label("Update Secret", systemImage: "key")
                      }
//                      Button(action: {}) {
//                          Label("View Camera", systemImage: "camera")
//                      }
                  }
              label: {
                  Label("Settings", systemImage: "ellipsis.circle")
              }
              }
          }
      }
      .textFieldAlert(isShowing: $isShowingUpdateSecretPrompt, text: $updateSecretInput, title: "Update Secret")
      .onChange(of: updateSecretInput) { newValue in
          model.setSecret(newSecret: newValue)
      }
  }
}

//struct ControlPanelContentView_Previews: PreviewProvider {
//  static var previews: some View {
//    ControlPanelContentView(model: JarvisModel())
//  }
//}


