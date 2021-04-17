//
//  SceneDelegate.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            FirebaseApp.configure()
            Auth.auth().settings?.isAppVerificationDisabledForTesting = true
            
            let keyValueStorage = UserDefaults.standard
            let urlHandler = UIApplication.shared
            
            let auth = Auth.auth()
            let firestore = Firestore.firestore()
            let phoneAuthProvider = Firebase.PhoneAuthProvider.provider()
            
            let firebaseAuthenticator = FirebaseAuthenticator(auth: auth,
                                                              phoneAuthProvider: phoneAuthProvider,
                                                              firestore: firestore)
            
            let userCreatorProvider = UserCreatorProvider(firestore: firestore)
            
            let uiFactoriesProvider = UIFactoriesProvider(keyValueStorage: keyValueStorage,
                                                          urlHandler: urlHandler,
                                                          userCreatorProvider: userCreatorProvider,
                                                          firestore: firestore,
                                                          authenticator: firebaseAuthenticator,
                                                          logoutProvider: firebaseAuthenticator,
                                                          userDeletionProvider: firebaseAuthenticator)
            let flowCoordinatorsProvider = FlowCoordinatorsProvider(uiFactoriesProvider: uiFactoriesProvider,
                                                                    authenticationStateProvider: firebaseAuthenticator)
            
            let appFlowCoordinator = flowCoordinatorsProvider.appFlowCoordinator
            appFlowCoordinator.install()

            window.rootViewController = appFlowCoordinator.rootViewController
            self.window = window
            window.makeKeyAndVisible()
            
            if let userActivity = connectionOptions.userActivities.first {
                self.scene(scene, continue: userActivity)
            } else {
                self.scene(scene, openURLContexts: connectionOptions.urlContexts)
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    }
}

