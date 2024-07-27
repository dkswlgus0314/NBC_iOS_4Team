import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        
        // Core Data Manager를 초기화
        let userDataManager = UserDataManager.shared

        // 로그인 뷰 컨트롤러를 루트 뷰 컨트롤러로 설정
        let loginViewController = LoginView()
        let navigationController = UINavigationController(rootViewController: loginViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func scene(_ scene: UIScene, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func scene(_ scene: UIScene, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
