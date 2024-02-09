//
//  Alerts.swift
//  Photostic
//
//  Created by Shobhit Puri on 2024-02-08.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}


struct Alerts {
    //MARK: - Network Alerts
    
    static let invalidResponse  = AlertItem(title: Text("Server Error"),
                                            message: Text("Invalid response from the server. Please try again later."),
                                            dismissButton: .default(Text("OK")))
    static let invalidAPIKey  = AlertItem(title: Text("Error"),
                                            message: Text("Invalid API Key. Please check if you have it in the Config file and try again."),
                                            dismissButton: .default(Text("OK")))
    
    static let invalidURL       = AlertItem(title: Text("Sever Error"),
                                            message: Text("There was an issue connecting to the server. Please check the URL."),
                                            dismissButton: .default(Text("OK")))
    
    static let genericError = AlertItem(title: Text("Server Error"),
                                            message: Text("Unable to complete your request at this time. Please check your internet connection"),
                                            dismissButton: .default(Text("OK")))
    
}
