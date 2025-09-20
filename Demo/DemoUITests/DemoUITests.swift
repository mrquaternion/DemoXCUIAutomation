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
        
        let credentialCombinations: [(input: (email: String, password: String), output: String?, expected: Bool)] = [
            (input: (email: "hello", password: "hellofriend"), output: AuthError.invalidEmail.message, expected: false), // courriel invalide
            (input: (email: "hello@friend.com", password: "Bitsound123"), output: AuthError.emailNotFound.message, expected: false), // mauvais courriel
            (input: (email: "user@example.com", password: "hellofriend"), output: AuthError.passwordNotFound.message, expected: false), // mauvais mdp
            (input: (email: "user@example.com", password: "Bitsound123"), output: nil, expected: true)
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
                expectedValue: data.expected,
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
            expectedValue: nil,
            emailTextField: emailTextField,
            passwordTextField: passwordTextField,
            logInButton: logInButton
        )
        
        // Étape 4 : Ajouter les jeux dont les musiques nous intéressent
        let addSoundtracks = app.buttons.matching(identifier: "add_soundtrack").firstMatch
        addSoundtracks.tap()
        
        let gameTypesToPick: [Game] = [
            .init(id: .halo, gameName: "Halo: Combat Evolved"),
            .init(id: .esv, gameName: "The Elder Scrolls V:\nSkyrim"),
            .init(id: .smg, gameName: "Super Mario Galaxy")
        ]
        gameTypesToPick.forEach { game in
            let addHaloSoundtrackButton = app.buttons.matching(identifier: "add_\(game.id.rawValue)").firstMatch
            addHaloSoundtrackButton.tap()
            
            // ------ Pour la présentation ------
            sleep(2)
            // ----------------------------------
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
    
    // MARK: - Miscs
    private func enterCredentials(
        email: String,
        password: String,
        errorMessage: String?,
        expectedValue: Bool?,
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
            XCTAssertNotEqual(errorLabel.exists, expectedValue)
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
