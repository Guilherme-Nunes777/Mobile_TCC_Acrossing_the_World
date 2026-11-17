using System;
using System.Collections.Generic;

namespace Unity.Services.LevelPlay.Editor
{
    sealed class UnityPackageVersion : IEquatable<UnityPackageVersion>
    {
        internal string Version { get; }
        internal string IronSourceSdkVersion { get; }
        internal bool IsDiscoverable { get; }

        internal UnityPackageVersion(string version, string ironSourceSdkVersion, bool isDiscoverable = true)
        {
            Version = version;
            IronSourceSdkVersion = ironSourceSdkVersion;
            IsDiscoverable = isDiscoverable;
        }

        internal UnityPackageVersion(string version, Dictionary<string, object> jsonDictionary)
        {
            Version = version;
            IronSourceSdkVersion = jsonDictionary["ironSourceSdkVersion"] as string;
            var isDiscoverable = false;
            if (jsonDictionary.TryGetValue("isDiscoverable", out var isDiscoverableValue) && isDiscoverableValue is bool parsedIsDiscoverable)
            {
                isDiscoverable = parsedIsDiscoverable;
            }
            IsDiscoverable = isDiscoverable;
        }

        public bool Equals(UnityPackageVersion other)
        {
            if (other == null)
            {
                return false;
            }

            if (!Version.Equals(other.Version))
            {
                return false;
            }

            if (!IronSourceSdkVersion.Equals(other.IronSourceSdkVersion))
            {
                return false;
            }

            if (IsDiscoverable != other.IsDiscoverable)
            {
                return false;
            }

            return true;
        }
    }
}
