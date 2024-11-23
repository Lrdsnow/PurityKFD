//
//  AppData.swift
//  purekfd
//
//  Created by Lrdsnow on 6/28/24.
//

import Foundation
import SwiftUI

public class AppData: ObservableObject {
    @Published var repos: [Repo] = []
    @Published var pkgs: [Package] = []
    @Published var featured: [Featured] = []
    @Published var installed_pkgs: [Package] = []
    @Published var available_updates: [Package] = []
    @Published var queued_pkgs: [(Package, Double, Error?)] = [] // to install, to uninstall
    
    // Exploit stuff
    @AppStorage("selectedExploit") var selectedExploit = 0
    @AppStorage("hasSetExploit") var hasSetExploit = false
    @AppStorage("FilterPackages") var filterPackages = true
    @AppStorage("savedExploitSettings") var savedSettings: [String: String] = [:]
    
    @AppStorage("savedLiveAccents") var savedLiveAccents: [String: String] = [:]
    
    func getLiveAccent(_ key: String, _ iconURL: URL?) -> Color? {
        if let saved = savedLiveAccents[key] {
            let comp = saved.components(separatedBy: ":")
            if let hex = comp.first,
               let oldIconURLKey = comp.last {
                if let iconURLKey = iconURL?.absoluteString {
                    if oldIconURLKey != iconURLKey {
                        return nil
                    }
                }
                return Color(hex: hex)
            }
        }
        return nil
    }

    func setPkgLiveAccent(_ color: Color?, _ bundleId: String, _ iconURL: URL?) {
        if let mainPKG = pkgs.firstIndex(where: { $0.bundleid == bundleId }) {
            pkgs[mainPKG]._liveAccent = color
        }
        if let installedPKG = installed_pkgs.firstIndex(where: { $0.bundleid == bundleId }) {
            installed_pkgs[installedPKG]._liveAccent = color
        }
        if let updatePKG = available_updates.firstIndex(where: { $0.bundleid == bundleId }) {
            available_updates[updatePKG]._liveAccent = color
        }
        if let hex = color?.toHex(),
           let iconURLKey = iconURL?.absoluteString {
            savedLiveAccents[bundleId] = "\(hex):\(iconURLKey)"
        }
    }
    
    func setRepoLiveAccent(_ color: Color?, _ url: URL?, _ iconURL: URL?) {
        if let repo = repos.firstIndex(where: { $0.url == url }) {
            repos[repo]._liveAccent = color
        }
        if let hex = color?.toHex(),
           let urlKey = url?.absoluteString,
           let iconURLKey = iconURL?.absoluteString {
            savedLiveAccents[urlKey] = "\(hex):\(iconURLKey)"
        }
    }
    
    static let shared = AppData()
}
