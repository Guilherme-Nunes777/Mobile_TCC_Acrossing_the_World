using UnityEngine;
using UnityEngine.Events;

namespace Unity.Services.LevelPlay
{
    /// <summary>
    /// Initializes the LevelPlay SDK from a scene GameObject and exposes the initialization
    /// settings and events in the Inspector, so mediation can be set up without writing code.
    /// In the Unity Editor initialization is simulated; on Android and iOS devices the platform SDK is used.
    /// </summary>
    [AddComponentMenu("Monetization/LevelPlay SDK")]
    [DisallowMultipleComponent]
    [DefaultExecutionOrder(100)]
    [HelpURL("https://docs.unity.com/grow/levelplay/sdk/unity/")]
    public class LevelPlaySdkBehaviour : MonoBehaviour
    {
        static LevelPlaySdkBehaviour s_PersistentInstance;

        [SerializeField]
        string m_AndroidAppKey;

        [SerializeField]
        string m_IOSAppKey;

        [SerializeField]
        string m_UserId;

        [SerializeField]
        bool m_InitializeOnStart = true;

        [SerializeField]
        bool m_PersistAcrossScenes = true;

        [SerializeField]
        bool m_PauseGameDuringAd;

        [SerializeField]
        UnityEvent<LevelPlayConfiguration> m_OnInitSuccess = new UnityEvent<LevelPlayConfiguration>();

        [SerializeField]
        UnityEvent<LevelPlayInitError> m_OnInitFailed = new UnityEvent<LevelPlayInitError>();

        /// <summary>
        /// LevelPlay app key used on Android, from the LevelPlay dashboard.
        /// </summary>
        public string AndroidAppKey { get => m_AndroidAppKey; set => m_AndroidAppKey = value; }

        /// <summary>
        /// LevelPlay app key used on iOS, from the LevelPlay dashboard.
        /// </summary>
        public string IOSAppKey { get => m_IOSAppKey; set => m_IOSAppKey = value; }

        /// <summary>
        /// Optional user id forwarded to the SDK during initialization.
        /// </summary>
        public string UserId { get => m_UserId; set => m_UserId = value; }

        /// <summary>
        /// Whether the SDK is initialized automatically when this component starts.
        /// </summary>
        public bool InitializeOnStart { get => m_InitializeOnStart; set => m_InitializeOnStart = value; }

        /// <summary>
        /// Whether this GameObject is kept alive across scene loads. When enabled, a duplicate
        /// LevelPlay SDK object loaded in a later scene destroys itself.
        /// </summary>
        public bool PersistAcrossScenes { get => m_PersistAcrossScenes; set => m_PersistAcrossScenes = value; }

        /// <summary>
        /// Whether the Unity game is paused while a full screen ad is displayed. iOS only, no-op on Android.
        /// </summary>
        public bool PauseGameDuringAd { get => m_PauseGameDuringAd; set => m_PauseGameDuringAd = value; }

        /// <summary>
        /// Invoked when the LevelPlay SDK initializes successfully.
        /// </summary>
        public UnityEvent<LevelPlayConfiguration> OnInitSuccess => m_OnInitSuccess;

        /// <summary>
        /// Invoked when the LevelPlay SDK initialization fails.
        /// </summary>
        public UnityEvent<LevelPlayInitError> OnInitFailed => m_OnInitFailed;

        /// <summary>
        /// The app key used on the current platform. In the Unity Editor the key matching the
        /// active build target is used.
        /// </summary>
        public string AppKey => LevelPlayComponentUtility.SelectByPlatform(m_AndroidAppKey, m_IOSAppKey);

        void Awake()
        {
            if (!m_PersistAcrossScenes)
            {
                return;
            }

            if (s_PersistentInstance != null && s_PersistentInstance != this)
            {
                Destroy(gameObject);
                return;
            }

            s_PersistentInstance = this;
            DontDestroyOnLoad(gameObject);
        }

        void Start()
        {
            SubscribeSdkEvents();

            if (m_InitializeOnStart)
            {
                Initialize();
            }
        }

        void OnDestroy()
        {
            UnsubscribeSdkEvents();

            if (s_PersistentInstance == this)
            {
                s_PersistentInstance = null;
            }
        }

        /// <summary>
        /// Initializes the LevelPlay SDK with the app key of the current platform and the configured user id.
        /// Called automatically on Start when <see cref="InitializeOnStart"/> is enabled.
        /// </summary>
        public void Initialize()
        {
            if (LevelPlay.IsInitialized)
            {
                LevelPlayLogger.LogVerbose($"LevelPlay SDK is already initialized, skipping initialization from the '{name}' GameObject.");
                return;
            }

            var appKey = AppKey;
            if (string.IsNullOrEmpty(appKey))
            {
                LevelPlayLogger.LogWarning($"LevelPlay SDK cannot initialize without an App Key. Set it on the '{name}' GameObject.");
                return;
            }

            SubscribeSdkEvents();

            if (m_PauseGameDuringAd)
            {
                LevelPlay.SetPauseGame(true);
            }

            LevelPlay.Init(appKey, string.IsNullOrEmpty(m_UserId) ? null : m_UserId);
        }

        /// <summary>
        /// Sets the pause game flag. See <see cref="LevelPlay.SetPauseGame"/>.
        /// </summary>
        /// <param name="pause">Is the game paused during ad display</param>
        public void SetPauseGame(bool pause) => LevelPlay.SetPauseGame(pause);

        void SubscribeSdkEvents()
        {
            UnsubscribeSdkEvents();
            LevelPlay.OnInitSuccess += HandleInitSuccess;
            LevelPlay.OnInitFailed += HandleInitFailed;
        }

        void UnsubscribeSdkEvents()
        {
            LevelPlay.OnInitSuccess -= HandleInitSuccess;
            LevelPlay.OnInitFailed -= HandleInitFailed;
        }

        void HandleInitSuccess(LevelPlayConfiguration configuration)
        {
            LevelPlayComponentUtility.RunOnMainThread(() =>
            {
                if (this == null)
                {
                    return;
                }

                m_OnInitSuccess.Invoke(configuration);
            });
        }

        void HandleInitFailed(LevelPlayInitError error)
        {
            LevelPlayComponentUtility.RunOnMainThread(() =>
            {
                if (this == null)
                {
                    return;
                }

                m_OnInitFailed.Invoke(error);
            });
        }
    }
}
