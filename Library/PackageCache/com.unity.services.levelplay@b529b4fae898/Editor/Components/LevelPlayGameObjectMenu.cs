using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;

namespace Unity.Services.LevelPlay.Editor
{
    static class LevelPlayGameObjectMenu
    {
        const int k_MenuPriority = 10;
        const string k_SdkGameObjectName = "LevelPlay";

        [MenuItem("GameObject/Monetization/LevelPlay SDK", false, k_MenuPriority)]
        internal static void CreateLevelPlaySdk(MenuCommand menuCommand)
        {
            if (!IsPrimaryInvocation(menuCommand))
            {
                return;
            }

            var existingSdk = FindSdk();
            if (existingSdk != null)
            {
                Selection.activeGameObject = existingSdk.gameObject;
                EditorGUIUtility.PingObject(existingSdk.gameObject);
                return;
            }

            // Always created at the scene root, ignoring the selected object: DontDestroyOnLoad only applies to root GameObjects.
            CreateRootGameObject<LevelPlaySdkBehaviour>(k_SdkGameObjectName);
            SendCreateEvent("LevelPlaySDK");
        }

        [MenuItem("GameObject/Monetization/Banner Ad (LevelPlay)", false, k_MenuPriority + 1)]
        internal static void CreateBannerAd(MenuCommand menuCommand)
        {
            if (!IsPrimaryInvocation(menuCommand))
            {
                return;
            }

            CreateAdGameObject<LevelPlayBannerAdBehaviour>("Banner Ad (LevelPlay)");
            SendCreateEvent("Banner");
        }

        [MenuItem("GameObject/Monetization/Interstitial Ad (LevelPlay)", false, k_MenuPriority + 2)]
        internal static void CreateInterstitialAd(MenuCommand menuCommand)
        {
            if (!IsPrimaryInvocation(menuCommand))
            {
                return;
            }

            CreateAdGameObject<LevelPlayInterstitialAdBehaviour>("Interstitial Ad (LevelPlay)");
            SendCreateEvent("Interstitial");
        }

        [MenuItem("GameObject/Monetization/Rewarded Ad (LevelPlay)", false, k_MenuPriority + 3)]
        internal static void CreateRewardedAd(MenuCommand menuCommand)
        {
            if (!IsPrimaryInvocation(menuCommand))
            {
                return;
            }

            CreateAdGameObject<LevelPlayRewardedAdBehaviour>("Rewarded Ad (LevelPlay)");
            SendCreateEvent("Rewarded");
        }

        // With several GameObjects selected, Unity invokes a GameObject menu item once per selected object.
        // Only the invocation for the active object creates anything; once it has run the selection moves
        // to the new object, so the remaining invocations are skipped as well.
        internal static bool IsPrimaryInvocation(MenuCommand menuCommand) =>
            menuCommand?.context == null || menuCommand.context == Selection.activeObject;

        static void SendCreateEvent(string objectType)
        {
            EditorServices.Instance.EditorAnalyticsService.SendCreateGameObject(objectType);
        }

        static void CreateRootGameObject<T>(string name) where T : Component
        {
            var gameObject = ObjectFactory.CreateGameObject(name, typeof(T));
            GameObjectUtility.EnsureUniqueNameForSibling(gameObject);
            Selection.activeGameObject = gameObject;
        }

        static void CreateAdGameObject<T>(string name) where T : Component
        {
            EnsureSdkExists();
            CreateRootGameObject<T>(name);
        }

        static void EnsureSdkExists()
        {
            if (FindSdk() != null)
            {
                return;
            }

            ObjectFactory.CreateGameObject(k_SdkGameObjectName, typeof(LevelPlaySdkBehaviour));
        }

        static LevelPlaySdkBehaviour FindSdk() =>
            StageUtility.GetCurrentStageHandle().FindComponentOfType<LevelPlaySdkBehaviour>();
    }
}
