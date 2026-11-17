using UnityEditor;
using UnityEngine;

namespace Unity.Services.LevelPlay.Editor
{
    class LevelPlayPackageUpdateWindow : EditorWindow
    {
        internal const string k_WindowTitleBarText = "Ads Mediation";
        internal const string k_WindowTitle = "Ads Mediation Package Update";
        internal const string k_MessageTextFormat = "Update to the latest Ads Mediation package version {0} to access improvements and optimizations for Unity LevelPlay.";
        internal const string k_UpdateButtonText = "Update";
        internal const string k_NotNowButtonText = "Not now";
        internal const string k_SkipThisVersionButtonText = "Skip this version";

        const string k_UnityLogoIconName = "UnityLogo";
        const float k_WindowWidth = 272f;
        const float k_WindowHeight = 340f;
        const float k_ButtonHeight = 28f;
        const float k_ButtonSpacing = 8f;
        const float k_SkipButtonSpacing = 24f;
        const float k_Padding = 16f;
        const float k_IconSize = 56f;

        static readonly Color k_BackgroundColor = new Color(0.16f, 0.16f, 0.17f);
        static readonly Color k_MessageColor = new Color(0.78f, 0.78f, 0.8f);
        static readonly Color k_UpdateButtonColor = new Color(0.6f, 1.2f, 2.4f);

        [SerializeField] internal string m_AvailableVersionString;
        internal IPackageUpdateService m_PackageUpdateService;
        internal IEditorAnalyticsService m_EditorAnalyticsService;
        UnityPackageVersion m_AvailableVersion;

        internal static LevelPlayPackageUpdateWindow ShowWindow(IPackageUpdateService packageUpdateService, UnityPackageVersion availableVersion)
        {
            var window = CreateInstance<LevelPlayPackageUpdateWindow>();
            window.Initialize(packageUpdateService, EditorServices.Instance.EditorAnalyticsService, availableVersion);
            window.titleContent = new GUIContent(k_WindowTitleBarText);
            window.minSize = new Vector2(k_WindowWidth, k_WindowHeight);
            window.maxSize = new Vector2(k_WindowWidth, k_WindowHeight);
            var main = EditorGUIUtility.GetMainWindowPosition();
            window.position = new Rect(
                main.center.x - (k_WindowWidth / 2f),
                main.center.y - (k_WindowHeight / 2f),
                k_WindowWidth,
                k_WindowHeight);
            window.ShowUtility();
            window.m_EditorAnalyticsService.SendPackageUpdateWindowEvent(EditorAnalyticsService.LevelPlayAction.PackageUpdateWindowDisplayed);
            return window;
        }

        internal void Initialize(IPackageUpdateService packageUpdateService, IEditorAnalyticsService editorAnalyticsService, UnityPackageVersion availableVersion)
        {
            m_PackageUpdateService = packageUpdateService;
            m_EditorAnalyticsService = editorAnalyticsService;
            m_AvailableVersion = availableVersion;
            m_AvailableVersionString = availableVersion != null ? availableVersion.Version : null;
        }

        internal string GetMessageText()
        {
            return string.Format(k_MessageTextFormat, m_AvailableVersionString);
        }

        internal bool TryRestoreState()
        {
            if (string.IsNullOrEmpty(m_AvailableVersionString))
            {
                return false;
            }

            if (m_AvailableVersion == null)
            {
                m_AvailableVersion = new UnityPackageVersion(m_AvailableVersionString, ironSourceSdkVersion: null);
            }

            if (m_PackageUpdateService == null)
            {
                m_PackageUpdateService = EditorServices.Instance.PackageUpdateService;
            }

            if (m_EditorAnalyticsService == null)
            {
                m_EditorAnalyticsService = EditorServices.Instance.EditorAnalyticsService;
            }

            return true;
        }

        void OnGUI()
        {
            if (!TryRestoreState())
            {
                Close();
                return;
            }

            minSize = new Vector2(k_WindowWidth, k_WindowHeight);
            maxSize = new Vector2(k_WindowWidth, k_WindowHeight);

            EditorGUI.DrawRect(new Rect(0f, 0f, position.width, position.height), k_BackgroundColor);

            GUILayout.BeginHorizontal();
            GUILayout.Space(k_Padding);
            GUILayout.BeginVertical();
            GUILayout.Space(k_Padding);

            var unityLogo = EditorGUIUtility.IconContent(k_UnityLogoIconName);
            if (unityLogo != null && unityLogo.image != null)
            {
                GUILayout.BeginHorizontal();
                GUILayout.FlexibleSpace();
                GUILayout.Label(unityLogo.image, GUILayout.Width(k_IconSize), GUILayout.Height(k_IconSize));
                GUILayout.FlexibleSpace();
                GUILayout.EndHorizontal();
            }

            GUILayout.Space(8f);
            GUILayout.Label(k_WindowTitle, CreateLabelStyle(EditorStyles.boldLabel, 14, Color.white));
            GUILayout.Space(6f);
            GUILayout.Label(GetMessageText(), CreateLabelStyle(EditorStyles.label, 12, k_MessageColor));
            GUILayout.FlexibleSpace();

            DrawButton(k_UpdateButtonText, k_UpdateButtonColor, OnUpdateClicked);
            GUILayout.Space(k_ButtonSpacing);
            DrawButton(k_NotNowButtonText, Color.white, OnNotNowClicked);
            GUILayout.Space(k_SkipButtonSpacing);
            DrawButton(k_SkipThisVersionButtonText, Color.white, OnSkipThisVersionClicked);
            GUILayout.Space(k_ButtonSpacing);

            GUILayout.Space(k_Padding);
            GUILayout.EndVertical();
            GUILayout.Space(k_Padding);
            GUILayout.EndHorizontal();
        }

        void DrawButton(string text, Color backgroundColor, System.Action onClick)
        {
            var previousBackgroundColor = GUI.backgroundColor;
            GUI.backgroundColor = backgroundColor;
            var clicked = GUILayout.Button(text, GUILayout.Height(k_ButtonHeight));
            GUI.backgroundColor = previousBackgroundColor;

            if (clicked)
            {
                onClick();
                Close();
                GUIUtility.ExitGUI();
            }
        }

        static GUIStyle CreateLabelStyle(GUIStyle baseStyle, int fontSize, Color textColor)
        {
            return new GUIStyle(baseStyle)
            {
                fontSize = fontSize,
                wordWrap = true,
                alignment = TextAnchor.MiddleCenter,
                normal = { textColor = textColor },
            };
        }

        internal void OnUpdateClicked()
        {
            m_EditorAnalyticsService.SendPackageUpdateWindowEvent(EditorAnalyticsService.LevelPlayAction.PackageUpdateWindowUpdate);
            _ = m_PackageUpdateService.UpdateToVersionAsync(m_AvailableVersion);
        }

        internal void OnNotNowClicked()
        {
            m_EditorAnalyticsService.SendPackageUpdateWindowEvent(EditorAnalyticsService.LevelPlayAction.PackageUpdateWindowNotNow);
        }

        internal void OnSkipThisVersionClicked()
        {
            m_EditorAnalyticsService.SendPackageUpdateWindowEvent(EditorAnalyticsService.LevelPlayAction.PackageUpdateWindowSkipThisVersion);
            m_PackageUpdateService.SkipVersion(m_AvailableVersion);
        }
    }
}
