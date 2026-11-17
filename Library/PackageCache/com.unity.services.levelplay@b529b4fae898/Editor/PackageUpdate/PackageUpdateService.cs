using System;
using System.Threading.Tasks;

namespace Unity.Services.LevelPlay.Editor
{
    class PackageUpdateService : IPackageUpdateService
    {
        readonly ILevelPlayNetworkManager m_LevelPlayNetworkManager;
        readonly IPackageTypeService m_PackageTypeService;
        readonly IUpmClientService m_UpmClientService;
        readonly IPackageUpdateCache m_PackageUpdateCache;
        readonly ILevelPlayLogger m_Logger;
        readonly bool m_IsBatchMode;
        readonly VersionComparer m_VersionComparer = new VersionComparer();

        internal PackageUpdateService(
            ILevelPlayNetworkManager levelPlayNetworkManager,
            IPackageTypeService packageTypeService,
            IUpmClientService upmClientService,
            IPackageUpdateCache packageUpdateCache,
            ILevelPlayLogger logger,
            bool isBatchMode)
        {
            m_LevelPlayNetworkManager = levelPlayNetworkManager;
            m_PackageTypeService = packageTypeService;
            m_UpmClientService = upmClientService;
            m_PackageUpdateCache = packageUpdateCache;
            m_Logger = logger;
            m_IsBatchMode = isBatchMode;
        }

        public async Task<UnityPackageVersion> GetAvailableUpdateAsync()
        {
            if (m_IsBatchMode)
            {
                return null;
            }

            if (m_PackageUpdateCache.UpdateCheckPerformedThisSession)
            {
                return null;
            }

            try
            {
                await m_LevelPlayNetworkManager.GetVersionsWebRequest();
            }
            catch (Exception e)
            {
                m_Logger.LogVerbose($"Failed to fetch versions json for the package update check with : {e.Message}");
            }

            try
            {
                m_LevelPlayNetworkManager.LoadVersionsFromJson();
            }
            catch (Exception e)
            {
                m_Logger.LogVerbose($"Failed to load versions json for the package update check with : {e.Message}");
                return null;
            }

            m_PackageUpdateCache.UpdateCheckPerformedThisSession = true;

            var currentVersion = m_LevelPlayNetworkManager.UnityPackageVersion();
            var latestVersion = m_LevelPlayNetworkManager.LatestDiscoverableUnityPackageVersion();
            if (currentVersion == null || latestVersion == null)
            {
                m_Logger.LogVerbose("Package update check skipped : the current or latest package version is unknown.");
                return null;
            }

            if (m_VersionComparer.Compare(latestVersion.Version, currentVersion) <= 0)
            {
                m_Logger.LogVerbose($"Package update check : version {currentVersion} is up to date (latest discoverable version is {latestVersion.Version}).");
                return null;
            }

            if (latestVersion.Version == m_PackageUpdateCache.SkippedVersion)
            {
                m_Logger.LogVerbose($"Package update check : version {latestVersion.Version} was skipped by the user.");
                return null;
            }

            m_Logger.LogVerbose($"Package update check : version {latestVersion.Version} is available (current version is {currentVersion}).");
            return latestVersion;
        }

        public async Task UpdateToVersionAsync(UnityPackageVersion unityPackageVersion)
        {
            if (unityPackageVersion == null)
            {
                return;
            }

            m_PackageUpdateCache.SkippedVersion = null;

            try
            {
                switch (m_PackageTypeService.PackageType)
                {
                    case PackageType.DotUnityPackage:
                        await m_LevelPlayNetworkManager.Install(unityPackageVersion);
                        break;
                    case PackageType.Upm:
                        await m_UpmClientService.AddPackageAsync($"{Constants.k_PackageName}@{unityPackageVersion.Version}");
                        break;
                }
            }
            catch (Exception e)
            {
                m_Logger.LogError($"Failed to update the LevelPlay package to {unityPackageVersion.Version} with : {e.Message}");
            }
        }

        public void SkipVersion(UnityPackageVersion unityPackageVersion)
        {
            if (unityPackageVersion == null)
            {
                return;
            }

            m_PackageUpdateCache.SkippedVersion = unityPackageVersion.Version;
        }
    }
}
