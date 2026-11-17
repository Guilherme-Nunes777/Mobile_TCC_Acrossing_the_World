using UnityEngine;
using UnityEngine.Events;

namespace Unity.Services.LevelPlay
{
    /// <summary>
    /// Manages a LevelPlay interstitial ad from a scene GameObject, exposing the
    /// <see cref="LevelPlayInterstitialAd"/> configuration and events in the Inspector,
    /// so interstitials can be set up without writing code.
    /// In the Unity Editor the interstitial is displayed as an editor mock ad; on Android and iOS devices the platform SDK is used.
    /// </summary>
    [AddComponentMenu("Monetization/Interstitial Ad (LevelPlay)")]
    [HelpURL("https://docs.unity.com/grow/levelplay/sdk/unity/")]
    public class LevelPlayInterstitialAdBehaviour : MonoBehaviour
    {
        [SerializeField]
        string m_AndroidAdUnitId;

        [SerializeField]
        string m_IOSAdUnitId;

        [SerializeField]
        bool m_LoadOnStart = true;

        [SerializeField]
        bool m_AutoReload = true;

        [SerializeField]
        string m_PlacementName;

        [SerializeField]
        double m_BidFloor;

        [SerializeField]
        UnityEvent<LevelPlayAdInfo> m_OnAdLoaded = new UnityEvent<LevelPlayAdInfo>();

        [SerializeField]
        UnityEvent<LevelPlayAdError> m_OnAdLoadFailed = new UnityEvent<LevelPlayAdError>();

        [SerializeField]
        UnityEvent<LevelPlayAdInfo> m_OnAdDisplayed = new UnityEvent<LevelPlayAdInfo>();

        [SerializeField]
        UnityEvent<LevelPlayAdInfo, LevelPlayAdError> m_OnAdDisplayFailed = new UnityEvent<LevelPlayAdInfo, LevelPlayAdError>();

        [SerializeField]
        UnityEvent<LevelPlayAdInfo> m_OnAdClicked = new UnityEvent<LevelPlayAdInfo>();

        [SerializeField]
        UnityEvent<LevelPlayAdInfo> m_OnAdClosed = new UnityEvent<LevelPlayAdInfo>();

        [SerializeField]
        UnityEvent<LevelPlayAdInfo> m_OnAdInfoChanged = new UnityEvent<LevelPlayAdInfo>();

        [SerializeField]
        UnityEvent<LevelPlayImpressionData> m_OnAdImpressionDataReady = new UnityEvent<LevelPlayImpressionData>();

        LevelPlayInterstitialAd m_Ad;

        bool m_AutoLoadStarted;

        /// <summary>
        /// Interstitial ad unit id used on Android, from the LevelPlay dashboard.
        /// </summary>
        public string AndroidAdUnitId { get => m_AndroidAdUnitId; set => m_AndroidAdUnitId = value; }

        /// <summary>
        /// Interstitial ad unit id used on iOS, from the LevelPlay dashboard.
        /// </summary>
        public string IOSAdUnitId { get => m_IOSAdUnitId; set => m_IOSAdUnitId = value; }

        /// <summary>
        /// The ad unit id used on the current platform. In the Unity Editor the id matching the active build target is used.
        /// </summary>
        public string AdUnitId => LevelPlayComponentUtility.SelectByPlatform(m_AndroidAdUnitId, m_IOSAdUnitId);

        /// <summary>
        /// Whether the interstitial is loaded automatically once the LevelPlay SDK is initialized.
        /// </summary>
        public bool LoadOnStart { get => m_LoadOnStart; set => m_LoadOnStart = value; }

        /// <summary>
        /// Whether the next interstitial is loaded automatically when the previous one is closed or fails to display.
        /// </summary>
        public bool AutoReload { get => m_AutoReload; set => m_AutoReload = value; }

        /// <summary>
        /// Optional placement name used by <see cref="ShowAd()"/> and <see cref="IsPlacementCapped()"/>.
        /// </summary>
        public string PlacementName { get => m_PlacementName; set => m_PlacementName = value; }

        /// <summary>
        /// Optional bid floor in USD. 0 or less leaves the value unset.
        /// </summary>
        public double BidFloor { get => m_BidFloor; set => m_BidFloor = value; }

        /// <summary>
        /// Invoked when the interstitial loads successfully.
        /// </summary>
        public UnityEvent<LevelPlayAdInfo> OnAdLoaded => m_OnAdLoaded;

        /// <summary>
        /// Invoked when the interstitial fails to load.
        /// </summary>
        public UnityEvent<LevelPlayAdError> OnAdLoadFailed => m_OnAdLoadFailed;

        /// <summary>
        /// Invoked when the interstitial is displayed.
        /// </summary>
        public UnityEvent<LevelPlayAdInfo> OnAdDisplayed => m_OnAdDisplayed;

        /// <summary>
        /// Invoked when the interstitial fails to display.
        /// </summary>
        public UnityEvent<LevelPlayAdInfo, LevelPlayAdError> OnAdDisplayFailed => m_OnAdDisplayFailed;

        /// <summary>
        /// Invoked when the user clicks the interstitial.
        /// </summary>
        public UnityEvent<LevelPlayAdInfo> OnAdClicked => m_OnAdClicked;

        /// <summary>
        /// Invoked when the user closes the interstitial.
        /// </summary>
        public UnityEvent<LevelPlayAdInfo> OnAdClosed => m_OnAdClosed;

        /// <summary>
        /// Invoked when the loaded ad's info changes, for example when revenue settles after the auction.
        /// </summary>
        public UnityEvent<LevelPlayAdInfo> OnAdInfoChanged => m_OnAdInfoChanged;

        /// <summary>
        /// Invoked when impression level revenue data is available for the interstitial.
        /// </summary>
        public UnityEvent<LevelPlayImpressionData> OnAdImpressionDataReady => m_OnAdImpressionDataReady;

        /// <summary>
        /// The underlying <see cref="LevelPlayInterstitialAd"/> instance, or null when the ad has not been created yet or was destroyed.
        /// </summary>
        public LevelPlayInterstitialAd Ad => m_Ad;

        void Start()
        {
            if (m_LoadOnStart)
            {
                LevelPlay.OnInitSuccess += HandleSdkInitializedForAutoLoad;
                if (LevelPlay.IsInitialized)
                {
                    HandleSdkInitializedForAutoLoad(null);
                }
            }
        }

        void OnDestroy()
        {
            LevelPlay.OnInitSuccess -= HandleSdkInitializedForAutoLoad;
            DestroyAd();
        }

        /// <summary>
        /// Loads the interstitial ad, creating it from the serialized configuration when needed.
        /// </summary>
        public void LoadAd()
        {
            if (m_Ad == null)
            {
                m_Ad = CreateAd();
            }

            m_Ad?.LoadAd();
        }

        string Placement => string.IsNullOrEmpty(m_PlacementName) ? null : m_PlacementName;

        /// <summary>
        /// Shows the interstitial ad using the serialized <see cref="PlacementName"/>.
        /// Logs a warning and does nothing when no ad is ready.
        /// </summary>
        public void ShowAd() => ShowAd(Placement);

        /// <summary>
        /// Shows the interstitial ad. Logs a warning and does nothing when no ad is ready.
        /// </summary>
        /// <param name="placementName">Placement name for the interstitial ad, or null for none.</param>
        public void ShowAd(string placementName)
        {
            if (m_Ad == null || !m_Ad.IsAdReady())
            {
                LevelPlayLogger.LogWarning($"Interstitial ad on the '{name}' GameObject is not ready to show. Call LoadAd and wait for OnAdLoaded.");
                return;
            }

            m_Ad.ShowAd(placementName);
        }

        /// <summary>
        /// Checks if the interstitial ad is loaded and ready to show.
        /// </summary>
        /// <returns>Returns true if the interstitial ad is ready, returns false if not.</returns>
        public bool IsAdReady() => m_Ad != null && m_Ad.IsAdReady();

        /// <summary>
        /// Checks if the serialized <see cref="PlacementName"/> is capped.
        /// </summary>
        /// <returns>Returns true if the placement is capped, returns false if not.</returns>
        public bool IsPlacementCapped() => LevelPlayInterstitialAd.IsPlacementCapped(Placement);

        /// <summary>
        /// Checks if a given placement name is capped.
        /// </summary>
        /// <param name="placementName">Placement name for the interstitial ad.</param>
        /// <returns>Returns true if the placement is capped, returns false if not.</returns>
        public bool IsPlacementCapped(string placementName) => LevelPlayInterstitialAd.IsPlacementCapped(placementName);

        /// <summary>
        /// Destroys the interstitial ad and releases its resources. The next call to <see cref="LoadAd"/> creates a new ad.
        /// </summary>
        public void DestroyAd()
        {
            if (m_Ad == null)
            {
                return;
            }

            UnsubscribeAdEvents(m_Ad);
            m_Ad.DestroyAd();
            m_Ad = null;
        }

        /// <summary>
        /// Gets the id of the loaded ad, or null when no ad has been created.
        /// </summary>
        /// <returns>The id of the ad.</returns>
        public string GetAdId() => m_Ad?.GetAdId();

        void HandleSdkInitializedForAutoLoad(LevelPlayConfiguration configuration)
        {
            LevelPlay.OnInitSuccess -= HandleSdkInitializedForAutoLoad;

            LevelPlayComponentUtility.RunOnMainThread(() =>
            {
                if (this == null || m_AutoLoadStarted)
                {
                    return;
                }

                m_AutoLoadStarted = true;
                LoadAd();
            });
        }

        LevelPlayInterstitialAd CreateAd()
        {
            var adUnitId = AdUnitId;
            if (string.IsNullOrEmpty(adUnitId))
            {
                LevelPlayLogger.LogWarning($"Interstitial ad unit id is not set for this platform on the '{name}' GameObject.");
                return null;
            }

            var builder = new LevelPlayInterstitialAd.Config.Builder();
            if (m_BidFloor > 0)
            {
                builder.SetBidFloor(m_BidFloor);
            }

            var ad = new LevelPlayInterstitialAd(adUnitId, builder.Build());
            ad.OnAdLoaded += HandleAdLoaded;
            ad.OnAdLoadFailed += HandleAdLoadFailed;
            ad.OnAdDisplayed += HandleAdDisplayed;
            ad.OnAdDisplayFailed += HandleAdDisplayFailed;
            ad.OnAdClicked += HandleAdClicked;
            ad.OnAdClosed += HandleAdClosed;
            ad.OnAdInfoChanged += HandleAdInfoChanged;
            ad.OnAdImpressionDataReady += HandleAdImpressionDataReady;
            return ad;
        }

        void UnsubscribeAdEvents(LevelPlayInterstitialAd ad)
        {
            ad.OnAdLoaded -= HandleAdLoaded;
            ad.OnAdLoadFailed -= HandleAdLoadFailed;
            ad.OnAdDisplayed -= HandleAdDisplayed;
            ad.OnAdDisplayFailed -= HandleAdDisplayFailed;
            ad.OnAdClicked -= HandleAdClicked;
            ad.OnAdClosed -= HandleAdClosed;
            ad.OnAdInfoChanged -= HandleAdInfoChanged;
            ad.OnAdImpressionDataReady -= HandleAdImpressionDataReady;
        }

        // Ad callbacks can arrive after the component was destroyed (e.g. scene unload while an ad is in flight),
        // so every handler bails out instead of touching a destroyed MonoBehaviour.
        void HandleAdLoaded(LevelPlayAdInfo info)
        {
            if (this == null)
            {
                return;
            }

            m_OnAdLoaded.Invoke(info);
        }

        void HandleAdLoadFailed(LevelPlayAdError error)
        {
            if (this == null)
            {
                return;
            }

            m_OnAdLoadFailed.Invoke(error);
        }

        void HandleAdDisplayed(LevelPlayAdInfo info)
        {
            if (this == null)
            {
                return;
            }

            m_OnAdDisplayed.Invoke(info);
        }

        void HandleAdDisplayFailed(LevelPlayAdInfo info, LevelPlayAdError error)
        {
            if (this == null)
            {
                return;
            }

            m_OnAdDisplayFailed.Invoke(info, error);

            if (m_AutoReload)
            {
                LoadAd();
            }
        }

        void HandleAdClicked(LevelPlayAdInfo info)
        {
            if (this == null)
            {
                return;
            }

            m_OnAdClicked.Invoke(info);
        }

        void HandleAdClosed(LevelPlayAdInfo info)
        {
            if (this == null)
            {
                return;
            }

            m_OnAdClosed.Invoke(info);

            if (m_AutoReload)
            {
                LoadAd();
            }
        }

        void HandleAdInfoChanged(LevelPlayAdInfo info)
        {
            if (this == null)
            {
                return;
            }

            m_OnAdInfoChanged.Invoke(info);
        }

        void HandleAdImpressionDataReady(LevelPlayImpressionData impressionData)
        {
            LevelPlayComponentUtility.RunOnMainThread(() =>
            {
                if (this == null)
                {
                    return;
                }

                m_OnAdImpressionDataReady.Invoke(impressionData);
            });
        }
    }
}
