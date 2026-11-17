using System;
using UnityEditor;
using UnityEngine;
using System.Threading.Tasks;
using Unity.Services.LevelPlay.Editor.Analytics;

namespace Unity.Services.LevelPlay.Editor
{
    class OnLoadService : IOnLoadService
    {
        [InitializeOnLoadMethod]
        static async void InitializeOnLoad()
        {
            try
            {
                var onLoadService = EditorServices.Instance.OnLoadService;
                await onLoadService.OnLoad();
            }
            catch (Exception e)
            {
                EditorServices.Instance.LevelPlayLogger.LogException(e);
            }
        }

        readonly IMigrationService m_MigrationService;
        readonly ILevelPlaySdkInstaller m_LevelPlaySdkInstaller;
        readonly IApiUsageDetectionService m_ApiUsageDetectionService;
        readonly IEditorAnalyticsService m_EditorAnalyticsService;
        readonly IPackageUpdateService m_PackageUpdateService;

        internal OnLoadService(
            ILevelPlaySdkInstaller levelPlaySdkInstaller,
            IMigrationService migrationService,
            IApiUsageDetectionService apiUsageDetectionService,
            IEditorAnalyticsService editorAnalyticsService,
            IPackageUpdateService packageUpdateService)
        {
            m_MigrationService = migrationService;
            m_LevelPlaySdkInstaller = levelPlaySdkInstaller;
            m_ApiUsageDetectionService = apiUsageDetectionService;
            m_EditorAnalyticsService = editorAnalyticsService;
            m_PackageUpdateService = packageUpdateService;
        }

        public async Task OnLoad()
        {
            SchedulePackageUpdatePrompt();

            ServicesCoreDependencyInstaller.InstallServicesCoreIfNotFound();
            MobileDependencyResolverInstaller.InstallPlayServicesResolverIfNeeded();
            EnvironmentVariables.BuildManifestPath();

            await m_LevelPlaySdkInstaller.OnLoad();

            m_MigrationService.Migrate();

            EditorSessionTracker.NewSession();
            var initUsageDetection = new InitUsageDetection(m_ApiUsageDetectionService, m_EditorAnalyticsService);
            _ = initUsageDetection.Run();
        }

        void SchedulePackageUpdatePrompt()
        {
#if !AdsMediation_BuilderProject
            if (Application.isBatchMode)
            {
                return;
            }

            EditorApplication.update -= PromptForPackageUpdateWhenEditorIsReady;
            EditorApplication.update += PromptForPackageUpdateWhenEditorIsReady;
#endif
        }

        async void PromptForPackageUpdateWhenEditorIsReady()
        {
            if (EditorApplication.isCompiling || EditorApplication.isUpdating)
            {
                return;
            }

            EditorApplication.update -= PromptForPackageUpdateWhenEditorIsReady;

            try
            {
                await PromptForPackageUpdateIfAvailableAsync();
            }
            catch (Exception e)
            {
                EditorServices.Instance.LevelPlayLogger.LogException(e);
            }
        }

        internal async Task PromptForPackageUpdateIfAvailableAsync()
        {
            var availableUpdate = await m_PackageUpdateService.GetAvailableUpdateAsync();
            if (availableUpdate != null)
            {
                LevelPlayPackageUpdateWindow.ShowWindow(m_PackageUpdateService, availableUpdate);
            }
        }
    }
}
