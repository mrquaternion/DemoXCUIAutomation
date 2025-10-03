//
//  DemoUITests.swift
//  DemoUITests
//
//  Created by Mathias La Rochelle on 2025-09-09.
//

import XCTest

final class DemoUITests: XCTestCase {
    
    var app: XCUIApplication!
    var device: XCUIDevice!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["UI_TESTING", "RESET_AUTH_STATE"]
        app.launchEnvironment = ["UI_TESTING": "1"]
        
        device = XCUIDevice.shared
        device.orientation = .portrait
    }

    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Tests page d'authentification
    @MainActor
    func testExploreAuthenticationErrors() throws {
        app.launch()
        
        let credentialCombinations: [(input: (email: String, password: String), output: String?, shouldLogIn: Bool)] = [
            (input: (email: "hello", password: "hellofriend"), output: AuthError.invalidEmail.message, shouldLogIn: false), // courriel invalide
            (input: (email: "hello@friend.com", password: "Bitsound123"), output: AuthError.emailNotFound.message, shouldLogIn: false), // mauvais courriel
            (input: (email: "user@example.com", password: "Bitsound123"), output: nil, shouldLogIn: true)
        ]
        
        // Étape 1 : Vérifier qu'on est bien sur la page d'accueil
        let nameOfApplication = app.staticTexts["BitSound"]
        XCTAssertTrue(nameOfApplication.waitForExistence(timeout: 2)) // attendre tout chargement possible après ouverture de l'app
        
        // Étape 2 : Localiser les champs cliquables
        let emailTextField = app.textFields.matching(identifier: "your_email").firstMatch
        let showPasswordButton = app.buttons.matching(identifier: "show_password").firstMatch; showPasswordButton.tap()
        let passwordTextField = app.textFields.matching(identifier: "your_password").firstMatch
        let logInButton = app.buttons.matching(identifier: "login").firstMatch
        
        // Étape 3 : Entrer l'information
        for (index, data) in credentialCombinations.enumerated() {
            try enterCredentials(
                email: data.input.email,
                password: data.input.password,
                errorMessage: data.output,
                shouldLogIn: data.shouldLogIn,
                emailTextField: emailTextField,
                passwordTextField: passwordTextField,
                logInButton: logInButton
            )

            if index < credentialCombinations.count - 1 {
                emailTextField.clearText(in: app)
                passwordTextField.clearText(in: app)
            }
        }
    }
    
    // MARK: - Tests ajout de contenu
    func testAddSoundtracksToMainBoard() throws {
        app.launch()
        
        let validCredentials: (email: String, password: String) = (email: "user@example.com", password: "Bitsound123")
        
        // Étape 1 : Vérifier qu'on est bien sur la page d'accueil
        let nameOfApplication = app.staticTexts["BitSound"]
        XCTAssertTrue(nameOfApplication.waitForExistence(timeout: 2)) // attendre tout chargement possible après ouverture de l'app
        
        // Étape 2 : Localiser les champs cliquables
        let emailTextField = app.textFields.matching(identifier: "your_email").firstMatch
        let showPasswordButton = app.buttons.matching(identifier: "show_password").firstMatch; showPasswordButton.tap()
        let passwordTextField = app.textFields.matching(identifier: "your_password").firstMatch
        let logInButton = app.buttons.matching(identifier: "login").firstMatch
        
        // Étape 3 : Entrer l'information
        try enterCredentials(
            email: validCredentials.email,
            password: validCredentials.password,
            errorMessage: nil,
            shouldLogIn: nil,
            emailTextField: emailTextField,
            passwordTextField: passwordTextField,
            logInButton: logInButton
        )
        
        // Étape 4 : Ajouter les jeux dont les musiques nous intéressent
        let addSoundtracksButton = app.buttons.matching(identifier: "add_soundtrack").firstMatch
        addSoundtracksButton.tap()
        
        let gameTypesToPick: [Game] = [
            .init(id: .halo, gameName: "Halo: Combat Evolved"),
            .init(id: .esv, gameName: "The Elder Scrolls V:\nSkyrim"),
            .init(id: .smg, gameName: "Super Mario Galaxy")
        ]
        gameTypesToPick.forEach { game in
            let addHaloSoundtrackButton = app.buttons.matching(identifier: "add_\(game.id.rawValue)").firstMatch
            
            // ------ Pour la présentation ------
            sleep(2)
            // ----------------------------------
            
            addHaloSoundtrackButton.tap()
        }
        
        let confirmButton = app.buttons.matching(identifier: "confirm_selection").firstMatch
        confirmButton.tap()
        
        app.scrollViews.element.swipeUp()
        
        // ------ Pour la présentation ------
        sleep(5)
        // ----------------------------------
        
        // Étape 5 : Vérifier qu'ils sont bien à l'accueil
        gameTypesToPick.forEach { game in
            let titleOfGamesAdded = app.staticTexts[game.gameName]
            XCTAssert(titleOfGamesAdded.exists, "Le jeu \(game.gameName) n'est pas affiché alors qu'il a été sélectionné.")
        }
    }
    
    func monTest() throws {
        
    }
    
    // MARK: - Tests de l'audio
    func testVerifyAudioOrigin() throws {
        app.launch()
        
        let audio: TestableAudioManager = AudioManager.shared
        
        // Étape 1
        try testAddSoundtracksToMainBoard()
        
        let games: [Game] = [
            .init(id: .halo, gameName: "Halo: Combat Evolved"),
            .init(id: .esv, gameName: "The Elder Scrolls V:\nSkyrim")
        ]
        games.forEach { game in
            let playButton = app.buttons.matching(identifier: "pb_\(game.id)").firstMatch
            playButton.tap() // Activer
            
            // Étape 2 : Vérifier que la musique jouée par le audio manager est bien celle du bouton
            if let current = audio.current {
                XCTAssertTrue(current.id == game.id.rawValue)
            }
            
            // ------ Pour la présentation ------
            if game.id == .esv { sleep(12) } else { sleep(5) }
            // ----------------------------------
            playButton.tap() // Arrêter
            
            // Étape 3 : Vérifier que le audio manager c'est bien arrêter
            XCTAssertNil(audio.current)
        }
    }
    
    // MARK: - Miscs
    private func enterCredentials(
        email: String,
        password: String,
        errorMessage: String?,
        shouldLogIn: Bool?,
        emailTextField: XCUIElement,
        passwordTextField: XCUIElement,
        logInButton: XCUIElement
    ) throws {
        emailTextField.tap()
        emailTextField.typeText(email)
        
        app.keyboards.buttons["Return"].tap() // Nécessaire sinon le simulateur ne trouve pas le prochain champ de texte
        
        passwordTextField.tap()
        passwordTextField.typeText(password)
        
        app.keyboards.buttons["Return"].tap()
        
        logInButton.tap()
        
        // Vérification de l'apparition du message d'erreur si c'est le cas
        if let errorMessage = errorMessage  {
            let errorLabel = app.staticTexts[errorMessage]
            XCTAssertNotEqual(errorLabel.exists, shouldLogIn)
        } else {
            try AuthError.allCases.forEach { error in
                if app.staticTexts[error.message].waitForExistence(timeout: 1) {
                    throw error
                }
            }
        }
    }
}


extension XCUIElement {
    func clearText(in app: XCUIApplication) {
        self.tap()
        
        let selectAll = app.menuItems["Select All"]
        let cut = app.menuItems["Cut"]
        
        // Cas 1 : menu `Select All` apparaît -> on le choisit, puis on `Cut`
        if selectAll.waitForExistence(timeout: 1) {
            selectAll.tap()
            if cut.waitForExistence(timeout: 1) {
                cut.tap()
            }
            return
        }
        
        // Cas 2 : pas de `Select All` -> on tente double tap
        self.doubleTap()
        
        // Après double tap, soit `Select All`, soit `Cut` directement
        if selectAll.waitForExistence(timeout: 1) {
            selectAll.tap()
            if cut.waitForExistence(timeout: 1) {
                cut.tap()
            }
        } else if cut.waitForExistence(timeout: 1) {
            cut.tap()
        }
    }
}
