using UnityEngine;
using UnityEngine.Events;

namespace Unity.Services.LevelPlay
{
    /// <summary>
    /// Displays a LevelPlay banner ad from a scene GameObject, exposing the
    /// <see cref="LevelPlayBannerAd"/> configuration and events in the Inspector,
    /// so banners can be set up without writing code.
    /// In the Unity Editor the banner is displayed as an editor mock ad; on Android and iOS devices the platform SDK is used.
    /// </summary>
    [AddComponentMenu("Monetization/Banner Ad (LevelPlay)")]
    [HelpURL("https://docs.unity.com/grow/levelplay/sdk/unity/")]
    public class LevelPlayBannerAdBehaviour : MonoBehaviour
    {
        /// <summary>
        /// Banner sizes selectable in the Inspector. Maps to <see cref="LevelPlayAdSize"/>.
        /// </summary>
        public enum SizePreset
        {
            /// <summary>
            /// Standard banner size. Maps to <see cref="LevelPlayAdSize.BANNER"/>.
            /// </summary>
            Banner = 0,

            /// <summary>
            /// Large banner size. Maps to <see cref="LevelPlayAdSize.LARGE"/>.
            /// </summary>
            Large = 1,

            /// <summary>
            /// Medium rectangle size. Maps to <see cref="LevelPlayAdSize.MEDIUM_RECTANGLE"/>.
            /// </summary>
            MediumRectangle = 2,

            /// <summary>
            /// Leaderboard size. Maps to <see cref="LevelPlayAdSize.LEADERBOARD"/>.
            /// </summary>
            Leaderboard = 3,

            /// <summary>
            /// Adaptive banner sized to the screen or to <see cref="AdaptiveWidth"/>.
            /// Maps to <see cref="LevelPlayAdSize.CreateAdaptiveAdSize"/>.
            /// </summary>
            Adaptive = 4,

            /// <summary>
            /// Custom dimensions from <see cref="CustomWidth"/> and <see cref="CustomHeight"/>.
            /// Maps to <see cref="LevelPlayAdSize.CreateCustomBannerSize"/>.
            /// </summary>
            Custom = 5,
        }

        /// <summary>
        /// Banner positions selectable in the Inspector. Maps to <see cref="LevelPlayBannerPosition"/>.
        /// </summary>
        public enum PositionPreset
        {
            /// <summary>
            /// Maps to <see cref="LevelPlayBannerPosition.TopLeft"/>.
            /// </summary>
            TopLeft = 0,

            /// <summary>
            /// Maps to <see cref="LevelPlayBannerPosition.TopCenter"/>.
            /// </summary>
            TopCenter = 1,

            /// <summary>
            /// Maps to <see cref="LevelPlayBannerPosition.TopRight"/>.
            /// </summary>
            TopRight = 2,

            /// <summary>
            /// Maps to <see cref="LevelPlayBannerPosition.CenterLeft"/>.
            /// </summary>
            CenterLeft = 3,

            /// <summary>
            /// Maps to <see cref="LevelPlayBannerPosition.Center"/>.
            /// </summary>
            Center = 4,

            /// <summary>
            /// Maps to <see cref="LevelPlayBannerPosition.CenterRight"/>.
            /// </summary>
            CenterRight = 5,

            /// <summary>
            /// Maps to <see cref="LevelPlayBannerPosition.BottomLeft"/>.
            /// </summary>
            BottomLeft = 6,

            /// <summary>
            /// Maps to <see cref="LevelPlayBannerPosition.BottomCenter"/>.
            /// </summary>
            BottomCenter = 7,

            /// <summary>
            /// Maps to <see cref="LevelPlayBannerPosition.BottomRight"/>.
            /// </summary>
            BottomRight = 8,

            /// <summary>
            /// A custom position from <see cref="CustomPosition"/>, measured from the top-left corner of the screen.
            /// </summary>
            Custom = 9,
        }

        [SerializeField]
        string m_AndroidAdUnitId;

        [SerializeField]
        string m_IOSAdUnitId;

        [SerializeField]
        bool m_LoadOnStart = true;

        [SerializeField]
        bool m_DisplayOnLoad = true;

        [SerializeField]
        SizePreset m_Size = SizePreset.Banner;

        [SerializeField]
        int m_AdaptiveWidth = -1;

        [SerializeField]
        int m_CustomWidth = 320;

        [SerializeField]
        int m_CustomHeight = 50;

        [SerializeField]
        PositionPreset m_Position = PositionPreset.BottomCenter;

        [SerializeField]
        Vector2 m_CustomPosition;

        [SerializeField]
        string m_PlacementName;

        [SerializeField]
        bool m_RespectSafeArea;

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
        UnityEvent<LevelPlayAdInfo> m_OnAdExpanded = new UnityEvent<LevelPlayAdInfo>();

        [SerializeField]
        UnityEvent<LevelPlayAdInfo> m_OnAdCollapsed = new UnityEvent<LevelPlayAdInfo>();

        [SerializeField]
        UnityEvent<LevelPlayAdInfo> m_OnAdLeftApplication = new UnityEvent<LevelPlayAdInfo>();

        [SerializeField]
        UnityEvent<LevelPlayImpressionData> m_OnAdImpressionDataReady = new UnityEvent<LevelPlayImpressionData>();

        LevelPlayBannerAd m_Ad;

        bool m_AutoLoadStarted;

        /// <summary>
        /// Banner ad unit id used on Android, from the LevelPlay dashboard.
        /// </summary>
        public string AndroidAdUnitId { get => m_AndroidAdUnitId; set => m_AndroidAdUnitId = value; }

        /// <summary>
        /// Banner ad unit id used on iOS, from the LevelPlay dashboard.
        /// </summary>
        public string IOSAdUnitId { get => m_IOSAdUnitId; set => m_IOSAdUnitId = value; }

        /// <summary>
        /// The ad unit id used on the current platform. In the Unity Editor the id matching the active build target is used.
        /// </summary>
        public string AdUnitId => LevelPlayComponentUtility.SelectByPlatform(m_AndroidAdUnitId, m_IOSAdUnitId);

        /// <summary>
        /// Whether the banner is loaded automatically once the LevelPlay SDK is initialized.
        /// </summary>
        public bool LoadOnStart { get => m_LoadOnStart; set => m_LoadOnStart = value; }

        /// <summary>
        /// Whether the banner is displayed immediately after it loads.
        /// </summary>
        public bool DisplayOnLoad { get => m_DisplayOnLoad; set => m_DisplayOnLoad = value; }

        /// <summary>
        /// Size of the banner ad.
        /// </summary>
        public SizePreset Size { get => m_Size; set => m_Size = value; }

        /// <summary>
        /// Custom width of the adaptive banner container, used when <see cref="Size"/> is
        /// <see cref="SizePreset.Adaptive"/>. -1 uses the screen width.
        /// </summary>
        public int AdaptiveWidth { get => m_AdaptiveWidth; set => m_AdaptiveWidth = value; }

        /// <summary>
        /// Width of the banner, used when <see cref="Size"/> is <see cref="SizePreset.Custom"/>.
        /// </summary>
        public int CustomWidth { get => m_CustomWidth; set => m_CustomWidth = value; }

        /// <summary>
        /// Height of the banner, used when <see cref="Size"/> is <see cref="SizePreset.Custom"/>.
        /// </summary>
        public int CustomHeight { get => m_CustomHeight; set => m_CustomHeight = value; }

        /// <summary>
        /// Position on the screen where the banner is displayed.
        /// </summary>
        public PositionPreset Position { get => m_Position; set => m_Position = value; }

        /// <summary>
        /// Offset from the top-left corner of the screen, used when <see cref="Position"/> is
        /// <see cref="PositionPreset.Custom"/>.
        /// </summary>
        public Vector2 CustomPosition { get => m_CustomPosition; set => m_CustomPosition = value; }

        /// <summary>
        /// Optional placement name used for reporting and targeting.
        /// </summary>
        public string PlacementName { get => m_PlacementName; set => m_PlacementName = value; }

        /// <summary>
        /// Whether the banner is displayed within the safe area of the screen.
        /// </summary>
        public bool RespectSafeArea { get => m_RespectSafeArea; set => m_RespectSafeArea = value; }

        /// <summary>
        /// Optional bid floor in USD. 0 or less leaves the value unset.
        /// </summary>
        public double BidFloor { get => m_BidFloor; set => m_BidFloor = value; }

        /// <summary>
        /// Invoked when the banner loads successfully.
        /// </summary>
        public UnityEvent<LevelPlayAdInfo> OnAdLoaded => m_OnAdLoaded;

        /// <summary>
        /// Invoked when the banner fails to load.
        /// </summary>
        public UnityEvent<LevelPlayAdError> OnAdLoadFailed => m_OnAdLoadFailed;

        /// <summary>
        /// Invoked when the banner becomes visible.
        /// </summary>
        public UnityEvent<LevelPlayAdInfo> OnAdDisplayed => m_OnAdDisplayed;

        /// <summary>
        /// Invoked when the banner fails to display.
        /// </summary>
        public UnityEvent<LevelPlayAdInfo, LevelPlayAdError> OnAdDisplayFailed => m_OnAdDisplayFailed;

        /// <summary>
        /// Invoked when the user clicks the banner.
        /// </summary>
        public UnityEvent<LevelPlayAdInfo> OnAdClicked => m_OnAdClicked;

        /// <summary>
        /// Invoked when the banner expands to cover the screen.
        /// </summary>
        public UnityEvent<LevelPlayAdInfo> OnAdExpanded => m_OnAdExpanded;

        /// <summary>
        /// Invoked when the banner collapses back from the expanded state.
        /// </summary>
        public UnityEvent<LevelPlayAdInfo> OnAdCollapsed => m_OnAdCollapsed;

        /// <summary>
        /// Invoked when the app is backgrounded after the user clicked the banner.
        /// </summary>
        public UnityEvent<LevelPlayAdInfo> OnAdLeftApplication => m_OnAdLeftApplication;

        /// <summary>
        /// Invoked when impression level revenue data is available for the banner.
        /// </summary>
        public UnityEvent<LevelPlayImpressionData> OnAdImpressionDataReady => m_OnAdImpressionDataReady;

        /// <summary>
        /// The underlying <see cref="LevelPlayBannerAd"/> instance, or null when the ad has not been created yet or was destroyed.
        /// </summary>
        public LevelPlayBannerAd Ad => m_Ad;

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
        /// Loads the banner ad, creating it from the serialized configuration when needed.
        /// </summary>
        public void LoadAd()
        {
            if (m_Ad == null)
            {
                m_Ad = CreateAd();
            }

            m_Ad?.LoadAd();
        }

        /// <summary>
        /// Displays the banner ad to the user. Does nothing before the ad is loaded.
        /// </summary>
        public void ShowAd() => m_Ad?.ShowAd();

        /// <summary>
        /// Hides the banner ad without destroying it. Does nothing before the ad is loaded.
        /// </summary>
        public void HideAd() => m_Ad?.HideAd();

        /// <summary>
        /// Destroys the banner ad and releases its resources. The next call to <see cref="LoadAd"/> creates a new ad.
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
        /// Pauses the auto-refreshing of the banner ad. Does nothing before the ad is loaded.
        /// </summary>
        public void PauseAutoRefresh() => m_Ad?.PauseAutoRefresh();

        /// <summary>
        /// Resumes the auto-refreshing of the banner ad after a pause. Does nothing before the ad is loaded.
        /// </summary>
        public void ResumeAutoRefresh() => m_Ad?.ResumeAutoRefresh();

        /// <summary>
        /// Gets the id of the loaded ad, or null when no ad has been created.
        /// </summary>
        /// <returns>The id of the ad.</returns>
        public string GetAdId() => m_Ad?.GetAdId();

        /// <summary>
        /// Gets the ad unit id used on the current platform.
        /// </summary>
        /// <returns>The id of the ad unit.</returns>
        public string GetAdUnitId() => m_Ad != null ? m_Ad.GetAdUnitId() : AdUnitId;

        /// <summary>
        /// Gets the size of the banner: the size of the created ad, or the size built from the
        /// serialized configuration when no ad exists yet.
        /// </summary>
        /// <returns>The size of the ad.</returns>
        public LevelPlayAdSize GetAdSize() => m_Ad != null ? m_Ad.GetAdSize() : BuildAdSize();

        /// <summary>
        /// Gets the position of the banner: the position of the created ad, or the position built
        /// from the serialized configuration when no ad exists yet.
        /// </summary>
        /// <returns>The position of the ad.</returns>
        public LevelPlayBannerPosition GetPosition() => m_Ad != null ? m_Ad.GetPosition() : BuildPosition();

        /// <summary>
        /// Gets the placement name associated with the banner.
        /// </summary>
        /// <returns>The placement name of the ad.</returns>
        public string GetPlacementName() => m_Ad != null ? m_Ad.GetPlacementName() : m_PlacementName;

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

        LevelPlayBannerAd CreateAd()
        {
            var adUnitId = AdUnitId;
            if (string.IsNullOrEmpty(adUnitId))
            {
                LevelPlayLogger.LogWarning($"Banner ad unit id is not set for this platform on the '{name}' GameObject.");
                return null;
            }

            var builder = new LevelPlayBannerAd.Config.Builder()
                .SetSize(BuildAdSize())
                .SetPosition(BuildPosition())
                .SetDisplayOnLoad(m_DisplayOnLoad)
                .SetRespectSafeArea(m_RespectSafeArea)
                .SetPlacementName(string.IsNullOrEmpty(m_PlacementName) ? null : m_PlacementName);

            if (m_BidFloor > 0)
            {
                builder.SetBidFloor(m_BidFloor);
            }

            var ad = new LevelPlayBannerAd(adUnitId, builder.Build());
            ad.OnAdLoaded += HandleAdLoaded;
            ad.OnAdLoadFailed += HandleAdLoadFailed;
            ad.OnAdDisplayed += HandleAdDisplayed;
            ad.OnAdDisplayFailed += HandleAdDisplayFailed;
            ad.OnAdClicked += HandleAdClicked;
            ad.OnAdExpanded += HandleAdExpanded;
            ad.OnAdCollapsed += HandleAdCollapsed;
            ad.OnAdLeftApplication += HandleAdLeftApplication;
            ad.OnAdImpressionDataReady += HandleAdImpressionDataReady;
            return ad;
        }

        void UnsubscribeAdEvents(LevelPlayBannerAd ad)
        {
            ad.OnAdLoaded -= HandleAdLoaded;
            ad.OnAdLoadFailed -= HandleAdLoadFailed;
            ad.OnAdDisplayed -= HandleAdDisplayed;
            ad.OnAdDisplayFailed -= HandleAdDisplayFailed;
            ad.OnAdClicked -= HandleAdClicked;
            ad.OnAdExpanded -= HandleAdExpanded;
            ad.OnAdCollapsed -= HandleAdCollapsed;
            ad.OnAdLeftApplication -= HandleAdLeftApplication;
            ad.OnAdImpressionDataReady -= HandleAdImpressionDataReady;
        }

        LevelPlayAdSize BuildAdSize()
        {
            switch (m_Size)
            {
                case SizePreset.Large:
                    return LevelPlayAdSize.LARGE;
                case SizePreset.MediumRectangle:
                    return LevelPlayAdSize.MEDIUM_RECTANGLE;
                case SizePreset.Leaderboard:
                    return LevelPlayAdSize.LEADERBOARD;
                case SizePreset.Adaptive:
                    return LevelPlayAdSize.CreateAdaptiveAdSize(m_AdaptiveWidth);
                case SizePreset.Custom:
                    return LevelPlayAdSize.CreateCustomBannerSize(m_CustomWidth, m_CustomHeight);
                default:
                    return LevelPlayAdSize.BANNER;
            }
        }

        LevelPlayBannerPosition BuildPosition()
        {
            switch (m_Position)
            {
                case PositionPreset.TopLeft:
                    return LevelPlayBannerPosition.TopLeft;
                case PositionPreset.TopCenter:
                    return LevelPlayBannerPosition.TopCenter;
                case PositionPreset.TopRight:
                    return LevelPlayBannerPosition.TopRight;
                case PositionPreset.CenterLeft:
                    return LevelPlayBannerPosition.CenterLeft;
                case PositionPreset.Center:
                    return LevelPlayBannerPosition.Center;
                case PositionPreset.CenterRight:
                    return LevelPlayBannerPosition.CenterRight;
                case PositionPreset.BottomLeft:
                    return LevelPlayBannerPosition.BottomLeft;
                case PositionPreset.BottomRight:
                    return LevelPlayBannerPosition.BottomRight;
                case PositionPreset.Custom:
                    return new LevelPlayBannerPosition(m_CustomPosition);
                default:
                    return LevelPlayBannerPosition.BottomCenter;
            }
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
        }

        void HandleAdClicked(LevelPlayAdInfo info)
        {
            if (this == null)
            {
                return;
            }

            m_OnAdClicked.Invoke(info);
        }

        void HandleAdExpanded(LevelPlayAdInfo info)
        {
            if (this == null)
            {
                return;
            }

            m_OnAdExpanded.Invoke(info);
        }

        void HandleAdCollapsed(LevelPlayAdInfo info)
        {
            if (this == null)
            {
                return;
            }

            m_OnAdCollapsed.Invoke(info);
        }

        void HandleAdLeftApplication(LevelPlayAdInfo info)
        {
            if (this == null)
            {
                return;
            }

            m_OnAdLeftApplication.Invoke(info);
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
