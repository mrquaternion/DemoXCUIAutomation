#import "@preview/touying:0.6.1": *
#import themes.university: *
#import "@preview/cetz:0.3.2"
#import "@preview/fletcher:0.5.5" as fletcher: node, edge
#import "@preview/numbly:0.1.0": numbly
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *

// cetz and fletcher bindings for touying
#let cetz-canvas = touying-reducer.with(reduce: cetz.canvas, cover: cetz.draw.hide.with(bounds: true))
#let fletcher-diagram = touying-reducer.with(reduce: fletcher.diagram, cover: fletcher.hide)
#let bordureImage(contenu) = rect(inset: 0pt, stroke: 2pt + gray, contenu)

#show: university-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Automatisation des tests d'interfaces],
    subtitle: [dans l'écosystème Apple],
    author: [Mathias La Rochelle],
    date: datetime.today(),
    institution: [Université de Montréal]
  ),
)

#set par(justify: true)
#set heading(numbering: numbly("{1}.", default: "1.1"))
#set text(lang: "fr")

#title-slide()

== Aperçu <touying:hidden>

#components.adaptive-columns(outline(title: none, indent: 1em))

= XCUIAutomation 

== C'est quoi ?

Framework qui permet d'automatiser les intéractions utilisateurs #pause
#pad(left: 2em)[
  - Vérifier l'état de l'interface #pause
  - Vérifier le reflet approprié des vues selon le changement des 
    - contrôleurs
    - modèles de données #pause
  - Créer des cas de tests pour simuler des gestes #pause
]

Ne possède pas encore son framework moderne comme #box(image("assets/swifttesting.png", width: 1em), baseline: 20%) _Swift Testing_ pour XCTest.

*IMPORTANT* : Le préfixe _test_ doit précéder le nom de chaque fonction à exécuter.


== Pourquoi ?
#figure(
  caption: "Source : " + text(fill: blue)[@learnxcuitest] + " en Annexe" ,
  bordureImage(image("assets/automation_vs_manual.png"))
) 


== Assertions XCTest
#slide(composer: (1fr, 1fr))[
  - Booléens
    - `XCTAssert`
    - `XCTAssertTrue`
    - `XCTAssertFalse`

  - Égalités et inégalités
      - `XCTAssertEqual`
      - `XCTAssertNotEqual`
      - `XCTAssertIdentical`
      - `XCTAssertNotIdentical`
][
  - Nil et Non-Nil
    - `XCTAssertNil`
    - `XCTAssertNotNil`
    - `XCTUnwrap`

  - Comparaison de valeurs
    - `XCTAssertGreaterThan`
    - `XCTAssertGreaterThanOrEqual`
    - `XCTAssertLessThan`
    - `XCTAssertLessThanOrEqual`
]


== Composantes essentielles
#pad(left: 1em)[
  1. `XCUIApplication`
    - Instance devant être appelée avec `launch()` à chaque début de test. Arguments de lancement spécifiés en même temps de son exécution. #pause

  2. `XCUIElementQuery`
    - Méthode utilisée par le RunnerApp et permettant de faire des requêtes au `UIWindow` du HostApp pour obtenir les `XCUIElement`. #pause

  
  3. `XCUIElement`
    - Composante UI dont le simulateur peut intéragir avec grâce à des fonctions comme `tap()`, `doubleTap()`, `press(_:)`, [`swipeLeft()`, `swipeRight()`, etc], `pinch(_:_:)`, `rotate(_:)` et plus.
]


== Flux d'appels
#align(center)[
  #fletcher-diagram(
    node-stroke: .08em,
    node-fill: gradient.radial(blue.lighten(80%), blue, center: (30%, 20%), radius: 70%),
    spacing: 2.5em,

    // HostApp
    node((3, 0), text(`RunnerApp`, size: 16pt), radius: 1.6em, fill: gradient.radial(orange.lighten(80%), orange, center: (30%, 20%), radius: 70%)),
    pause,
    edge((3, -0.1), (0, -0.1), "-|>", label: text("XCUIElementQuery", size: 20pt), label-side: center),

    // Root: RunnerApp (bottom)
    node((0, 0), text(`HostApp`, size: 16pt), radius: 1.6em),
    pause,

    // UIApplicationMain above RunnerApp
    node((1, 0.7), text(`UIApplicationMain`, size: 11pt), radius: 2em),
    edge((0, 0.2), (1, 0.7), "-|>"),

    // Children of UIApplicationMain (spread above)
    node((-0.5, 1.5), text(`UIApplication`, size: 12pt), radius: 1.8em),
    node((1, 2), text(`UIWindow`, size: 16pt), radius: 1.6em),
    node((3, 1.5), text(`Runloop`, size: 16pt), radius: 1.6em),

    edge((1, 1), (-0.5, 1.5), "-|>", label: text("creates", size: 20pt)),
    edge((1, 1), (1, 2), "-|>", label: text("makeKeyAndVisible", size: 20pt), label-side: center),
    edge((1, 1), (3, 1.5), "-|>", label: text("start loop", size: 20pt)),

    // RootViewController above UIWindow
    node((2.5, 2.3), text(`UIViewController`, size: 11pt), radius: 2em),
    edge((1, 2), (2.5, 2.3), "-|>"),
    pause,

    edge((0, 0.1), (3, 0.1), "-|>", label: text("XCUIElement", size: 20pt), label-side: center),
  )
]


== Détection des composantes d'accessibilité

#figure(
  caption: "Correspondance entre " + box(image("assets/accessibilityinspector.png", width: 1em), baseline: 20%) + emph( " Accessibility Inspector") + " et l'arbre des composantes de l'interface utilisateur",
  bordureImage(image("assets/accessibility_vs_uitree.png", width: 100%))
)


= Demo

== Contexte de l'application
#slide(align: center)[
  Application qui permet d'ajouter les musiques de nos jeux vidéos favoris.

  #grid(
    columns: (1fr, 1fr),
      bordureImage(image("assets/mainview.png", width: 42%)),
      bordureImage(image("assets/homeview.png", width: 42%))
    )
]

== Exemples de code
#show: codly-init.with()
#codly(languages: codly-languages)
#text(size: 14pt)[
  ```swift
  @MainActor
  func testExploreAuthenticationErrors() throws {
      app.launch()
          
      // Étape 1 : Vérifier qu'on est bien sur la page d'accueil
      let nameOfApplication = app.staticTexts["BitSound"]
      XCTAssertTrue(nameOfApplication.waitForExistence(timeout: 2)) // attendre tout chargement possible après ouverture de l'app
      
      // Étape 2 : Localiser les champs cliquables
      let emailTextField = app.textFields.matching(identifier: "your_email").firstMatch
      let showPasswordButton = app.buttons.matching(identifier: "show_password").firstMatch; showPasswordButton.tap()
      let passwordTextField = app.textFields.matching(identifier: "your_password").firstMatch
      let logInButton = app.buttons.matching(identifier: "login").firstMatch

      // ...
  }
  ```
]

#pagebreak()

#text(size: 13.7pt)[
  ```swift
  private func enterCredentials(email: String, password: String, error: String?, expVal: Bool?, 
                                emailTF: XCUIElement, passwordTF: XCUIElement, loginBT: XCUIElement) throws {
      emailTF.tap()
      emailTF.typeText(email)
      app.keyboards.buttons["Return"].tap() 
      // Nécessaire sinon le simulateur ne trouve pas le prochain champ de texte
      passwordTF.tap()
      passwordTF.typeText(password)
      app.keyboards.buttons["Return"].tap()
      loginBT.tap()
      // Vérification de l'apparition du message d'erreur 
      if let errorMessage = error  { 
          let errorLabel = app.staticTexts[errorMessage]
          XCTAssertNotEqual(errorLabel.exists, expVal)
      } else {
          try AuthError.allCases.forEach { error in
              if app.staticTexts[error.message].waitForExistence(timeout: 1) { throw error }
          }
      }
  }
  ```
]


#show: appendix

= Annexe

== Sources

#bibliography(title: none, "bibliography.yml", full: true)