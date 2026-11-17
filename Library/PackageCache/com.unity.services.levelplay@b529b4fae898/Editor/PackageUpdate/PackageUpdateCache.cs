using UnityEditor;

namespace Unity.Services.LevelPlay.Editor
{
    class PackageUpdateCache : IPackageUpdateCache
    {
        const string k_SkippedVersionKey = "LevelPlay.PackageUpdate.SkippedVersion";
        const string k_UpdateCheckPerformedThisSessionKey = "LevelPlay.PackageUpdate.UpdateCheckPerformedThisSession";

        readonly string m_SkippedVersionKey;
        readonly string m_UpdateCheckPerformedThisSessionKey;

        internal PackageUpdateCache() : this($"{k_SkippedVersionKey}.{PlayerSettings.productGUID}", k_UpdateCheckPerformedThisSessionKey)
        {
        }

        internal PackageUpdateCache(string skippedVersionKey, string updateCheckPerformedThisSessionKey)
        {
            m_SkippedVersionKey = skippedVersionKey;
            m_UpdateCheckPerformedThisSessionKey = updateCheckPerformedThisSessionKey;
        }

        public bool UpdateCheckPerformedThisSession
        {
            get => SessionState.GetBool(m_UpdateCheckPerformedThisSessionKey, false);
            set => SessionState.SetBool(m_UpdateCheckPerformedThisSessionKey, value);
        }

        public string SkippedVersion
        {
            get
            {
                var skippedVersion = EditorPrefs.GetString(m_SkippedVersionKey, null);
                return string.IsNullOrEmpty(skippedVersion) ? null : skippedVersion;
            }
            set
            {
                if (string.IsNullOrEmpty(value))
                {
                    EditorPrefs.DeleteKey(m_SkippedVersionKey);
                }
                else
                {
                    EditorPrefs.SetString(m_SkippedVersionKey, value);
                }
            }
        }
    }
}
