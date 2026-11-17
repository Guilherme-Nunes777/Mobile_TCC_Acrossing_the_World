using System.Threading.Tasks;

namespace Unity.Services.LevelPlay.Editor
{
    interface IPackageUpdateService
    {
        Task<UnityPackageVersion> GetAvailableUpdateAsync();
        Task UpdateToVersionAsync(UnityPackageVersion unityPackageVersion);
        void SkipVersion(UnityPackageVersion unityPackageVersion);
    }
}
