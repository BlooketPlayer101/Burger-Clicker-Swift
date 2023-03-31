// "Do not modify this code unless you're me. It could break." -WindswipeTW

// --------------------------------------------------------------------------------------------------
// Game info:
// Version: 1.7 (Developer Beta)
// Status: Stable
// --------------------------------------------------------------------------------------------------
// Last updated on 3/7/23.
// --------------------------------------------------------------------------------------------------

// Module imports.
import SwiftUI
import Darwin
import Foundation

// Main view; houses 99% of all game code.
struct ContentView: View {
    // Inital varable declaration; controls starting values.
    @State var gameVersion = 1.7
    @State var isBeta = true
    @State var showChangeLog = false
    @State var gameStarted = false
    @State var tapCount = 0
    @State var tapMultiplier = 1
    @State var amountToUpgrade = 50
    @State var employees = 1
    @State var amountToHire = 1000
    @State var employeeCap = 10
    @State var amountToLevelUp = 50000
    @State var enableForbiddenUpgrades = false
    @State var forbiddenUpgradesUsed = 0
    @State var encyptedGameSeed = ""
    @State var gameDataFull = ""
    var body: some View {
        // Conditional script that controls if the main game is shown.
        if gameStarted == true {
            // Main game code.
            Form {
                // Game title and version display; will house a "How to play" button in a future update.
                Section {
                    Text("Burger Clicker v" + String(gameVersion))
                        .foregroundColor(.orange)
                    if isBeta == true {
                        Text("Notice: Beta build, may house incomplete or unstable features.")
                            .foregroundColor(.red)
                    }
                }
                
                Section {
                    Button("Generate Save Game Code") {
                        let gameData1 = String(tapCount) + " " + String(tapMultiplier) + " " + String(amountToUpgrade)
                        let gameData2 = String(employees) + " " + String(amountToHire) + " " + String(employeeCap)
                        var forbiddenUpgradesEnabledTempValue = 0
                        if enableForbiddenUpgrades == true {
                            forbiddenUpgradesEnabledTempValue = 1
                        } else {
                            forbiddenUpgradesEnabledTempValue = 0
                        }
                        let gameData3 = String(amountToUpgrade) + " " + String(forbiddenUpgradesEnabledTempValue) + " " + String(forbiddenUpgradesUsed)
                        self.gameDataFull = gameData1 + " " + gameData2 + " " + gameData3
                        let utf8str = gameDataFull.data(using: .utf8)
                        if let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) {
                            self.encyptedGameSeed = base64Encoded
                        }
                    }
                    if encyptedGameSeed != "" {
                        Text("Save game code:")
                            .foregroundColor(.purple)
                        TextEditor(text: .constant(encyptedGameSeed))
                            .foregroundColor(.purple)
                    }
                }
                
                // Burger count and "Cook Burgers" button.
                Section {
                    Text("Burgers: \(tapCount)")
                        .foregroundColor(.blue)
                    Button("Cook Burgers") {
                        self.tapCount += tapMultiplier * employees
                    }
                }
                // BPC upgrade info and button.
                Section{
                    Text("Burgers Per Click: \(tapMultiplier * employees)")
                        .foregroundColor(.blue)
                    Text("Burgers needed to upgrade: \(amountToUpgrade)")
                        .foregroundColor(.blue)
                    Button("Upgrade") {
                        if tapCount >= amountToUpgrade {
                            self.tapMultiplier += 1
                            self.tapCount -= amountToUpgrade
                            self.amountToUpgrade += 50 * employees
                        }
                    } 
                }
                // Employee and hiring info; also contains the "Hire Employee" button.
                Section{
                    Text("Employees: \(employees)")
                        .foregroundColor(.blue)
                    Text("Burgers needed to hire: \(amountToHire)")
                        .foregroundColor(.blue)
                    Button("Hire") {
                        if tapCount >= amountToHire {
                            if employees < employeeCap {
                                self.employees += 1
                                self.tapCount -= amountToHire
                                self.amountToHire += 1000
                                self.amountToUpgrade += 500  
                            }
                        }
                    } 
                }
                // Restaurant leveling info and button.
                Section{
                    Text("Restaurant level: \(employeeCap / 10)")
                        .foregroundColor(.blue)
                    Text("Burgers needed to level up: \(amountToLevelUp)")
                        .foregroundColor(.blue)
                    Button("Level Up") {
                        if tapCount >= amountToLevelUp {
                            self.employeeCap *= 2
                            self.tapCount -= amountToLevelUp
                            self.amountToHire += 10000
                            self.amountToUpgrade += 1000
                            self.amountToLevelUp *= 2
                        }
                    } 
                }
                // Forbidden upgrades.
                Section{
                    Text("Forbidden upgrades (WARNING: 10% chance of catastrophe.)")
                        .foregroundColor(.red)
                    // Condition to show forbidden upgrades.
                    if enableForbiddenUpgrades == true {
                        Text("Forbidden upgrades used: " + String(forbiddenUpgradesUsed))
                            .foregroundColor(.red)
                        // "Lower prices" forbidden upgrade.
                        Text("Lower prices (Burgers needed: 10000)")
                            .foregroundColor(.blue)
                        Button("Buy") {
                            if tapCount >= 10000 {
                                self.forbiddenUpgradesUsed += 1
                                self.tapCount -= 10000
                                self.amountToHire /= 2
                                self.amountToUpgrade /= 2
                                self.amountToLevelUp /= 2
                                // Conditional script to trigger game exit; has a 10% chance of executing game exit code.
                                if Int.random(in: 0...9) == 1 {
                                    sleep(10)
                                    self.employees = 0
                                    self.tapCount = 0
                                    self.tapMultiplier = 0
                                    self.employeeCap = 0
                                    self.amountToHire = 0
                                    self.amountToUpgrade = 0
                                    self.amountToLevelUp = 0
                                    exit(5)
                                }
                            }
                        }
                        // "Triple employees" forbidden upgrade.
                        Text("Triple employees (Burgers needed: 10000)")
                            .foregroundColor(.blue)
                        Button("Buy") {
                            if tapCount >= 10000 {
                                self.forbiddenUpgradesUsed += 1
                                self.tapCount -= 10000
                                self.employees *= 3
                                // Conditional script to trigger game exit; has a 10% chance of executing game exit code.
                                if Int.random(in: 0...9) == 1 {
                                    sleep(10)
                                    self.employees = 0
                                    self.tapCount = 0
                                    self.tapMultiplier = 0
                                    self.employeeCap = 0
                                    self.amountToHire = 0
                                    self.amountToUpgrade = 0
                                    self.amountToLevelUp = 0
                                    exit(5)
                                }
                            }
                        }
                        // "Triple BPC" forbidden upgrade.
                        Text("Triple burgers per click (Burgers needed: 10000)")
                            .foregroundColor(.blue)
                        Button("Buy") {
                            if tapCount >= 10000 {
                                self.forbiddenUpgradesUsed += 1
                                self.tapCount -= 10000
                                self.tapMultiplier *= 3
                                // Conditional script to trigger game exit; has a 10% chance of executing game exit code.
                                if Int.random(in: 0...9) == 1 {
                                    sleep(10)
                                    self.employees = 0
                                    self.tapCount = 0
                                    self.tapMultiplier = 0
                                    self.employeeCap = 0
                                    self.amountToHire = 0
                                    self.amountToUpgrade = 0
                                    self.amountToLevelUp = 0
                                    exit(5)
                                }
                            }
                        }
                        // "Multiply RL by 6" forbidden upgrade.
                        Text("Multiply restaurant level by 6 (Burgers needed: 10000)")
                            .foregroundColor(.blue)
                        Button("Buy") {
                            if tapCount >= 10000 {
                                self.forbiddenUpgradesUsed += 1
                                self.tapCount -= 10000
                                self.employeeCap *= 6
                                // Conditional script to trigger game exit; has a 10% chance of executing game exit code.
                                if Int.random(in: 0...9) == 1 {
                                    sleep(10)
                                    self.employees = 0
                                    self.tapCount = 0
                                    self.tapMultiplier = 0
                                    self.employeeCap = 0
                                    self.amountToHire = 0
                                    self.amountToUpgrade = 0
                                    self.amountToLevelUp = 0
                                    exit(5)
                                }
                            }
                        }
                    } else {
                        Button("Enable Forbidden Upgrades") {
                            self.enableForbiddenUpgrades = true
                        }
                    }
                } 
            }  
        } else {
            // Launch screen; shown if "gameStarted" is set to false.
            VStack {
                Image("Image Asset")
                    .imageScale(.small)
                    .scaleEffect(0.5, anchor: .center)
                Text("Burger Clicker")
                    .foregroundColor(.orange)
                    .scaleEffect(3.0, anchor: .bottom)
                Text("A clicker game coded in Swift Playgrounds")
                    .foregroundColor(.teal)
                Text("Developed by WindswipeTW")
                    .foregroundColor(.green)
            }
            Form {
                Section {
                    Button("Play") {
                        if encyptedGameSeed != "" {
                            if let base64Decoded = Data(base64Encoded: encyptedGameSeed, options: Data.Base64DecodingOptions(rawValue: 0))
                                .map({ String(data: $0, encoding: .utf8) }) {
                                let decyptedGameSeedStringArray = base64Decoded!.split{ $0.isWhitespace }.map{ String($0)}
                                let decryptedGameSeedIntArray = decyptedGameSeedStringArray.compactMap { Int($0) }
                                self.tapCount = decryptedGameSeedIntArray[0]
                                self.tapMultiplier = decryptedGameSeedIntArray[1]
                                self.amountToUpgrade = decryptedGameSeedIntArray[2]
                                self.employees = decryptedGameSeedIntArray[3]
                                self.amountToHire = decryptedGameSeedIntArray[4]
                                self.employeeCap = decryptedGameSeedIntArray[5]
                                self.amountToLevelUp = decryptedGameSeedIntArray[6]
                                if decryptedGameSeedIntArray[7] == 1 {
                                    self.enableForbiddenUpgrades = true
                                    self.forbiddenUpgradesUsed = decryptedGameSeedIntArray[8]
                                }
                                self.encyptedGameSeed = ""
                            }
                        }
                        gameStarted = true
                    }
                        TextField("Enter save game code here.", text: $encyptedGameSeed)
                            .disableAutocorrection(true)
                    }
                    Section {
                        Text("Game version: v" + String(gameVersion))
                            .foregroundColor(.purple)
                        if isBeta == true {
                            Text("Notice: Beta build, may house incomplete or unstable features.")
                                .foregroundColor(.red)
                        }
                        Toggle(isOn: $showChangeLog) {
                            Text("Show Change Log")
                                .foregroundColor(.yellow)
                        }
                    }
                    if showChangeLog == true {
                        Section {
                            Text("Change Log:")
                                .foregroundColor(.purple)
                            Text("Added the ability to restore from a game save code.")
                        }
                    }  
                }
                
            }
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
