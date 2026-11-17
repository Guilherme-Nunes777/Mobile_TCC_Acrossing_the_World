using UnityEditor;
using UnityEngine;

namespace Unity.Services.LevelPlay.Editor
{
    abstract class LevelPlayBehaviourEditor : UnityEditor.Editor
    {
        public override bool RequiresConstantRepaint()
        {
            return Application.isPlaying;
        }

        public override void OnInspectorGUI()
        {
            DrawDefaultInspector();

            if (!Application.isPlaying)
            {
                return;
            }

            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Play Mode Controls", EditorStyles.boldLabel);
            DrawPlayModeControls();
        }

        protected abstract void DrawPlayModeControls();
    }

    [CustomEditor(typeof(LevelPlaySdkBehaviour))]
    class LevelPlaySdkBehaviourEditor : LevelPlayBehaviourEditor
    {
        protected override void DrawPlayModeControls()
        {
            var behaviour = (LevelPlaySdkBehaviour)target;

            if (GUILayout.Button("Initialize"))
            {
                behaviour.Initialize();
            }
        }
    }

    [CustomEditor(typeof(LevelPlayBannerAdBehaviour))]
    class LevelPlayBannerAdBehaviourEditor : LevelPlayBehaviourEditor
    {
        protected override void DrawPlayModeControls()
        {
            var behaviour = (LevelPlayBannerAdBehaviour)target;
            EditorGUILayout.LabelField("Ad Created", behaviour.Ad != null ? "Yes" : "No");

            using (new EditorGUILayout.HorizontalScope())
            {
                if (GUILayout.Button("Load"))
                {
                    behaviour.LoadAd();
                }

                if (GUILayout.Button("Show"))
                {
                    behaviour.ShowAd();
                }

                if (GUILayout.Button("Hide"))
                {
                    behaviour.HideAd();
                }

                if (GUILayout.Button("Destroy"))
                {
                    behaviour.DestroyAd();
                }
            }
        }
    }

    [CustomEditor(typeof(LevelPlayInterstitialAdBehaviour))]
    class LevelPlayInterstitialAdBehaviourEditor : LevelPlayBehaviourEditor
    {
        protected override void DrawPlayModeControls()
        {
            var behaviour = (LevelPlayInterstitialAdBehaviour)target;
            EditorGUILayout.LabelField("Ad Ready", behaviour.IsAdReady() ? "Yes" : "No");

            using (new EditorGUILayout.HorizontalScope())
            {
                if (GUILayout.Button("Load"))
                {
                    behaviour.LoadAd();
                }

                if (GUILayout.Button("Show"))
                {
                    behaviour.ShowAd();
                }

                if (GUILayout.Button("Destroy"))
                {
                    behaviour.DestroyAd();
                }
            }
        }
    }

    [CustomEditor(typeof(LevelPlayRewardedAdBehaviour))]
    class LevelPlayRewardedAdBehaviourEditor : LevelPlayBehaviourEditor
    {
        protected override void DrawPlayModeControls()
        {
            var behaviour = (LevelPlayRewardedAdBehaviour)target;
            EditorGUILayout.LabelField("Ad Ready", behaviour.IsAdReady() ? "Yes" : "No");

            var reward = behaviour.GetReward();
            if (reward != null)
            {
                EditorGUILayout.LabelField("Reward", $"{reward.Name}: {reward.Amount}");
            }

            using (new EditorGUILayout.HorizontalScope())
            {
                if (GUILayout.Button("Load"))
                {
                    behaviour.LoadAd();
                }

                if (GUILayout.Button("Show"))
                {
                    behaviour.ShowAd();
                }

                if (GUILayout.Button("Destroy"))
                {
                    behaviour.DestroyAd();
                }
            }
        }
    }
}
