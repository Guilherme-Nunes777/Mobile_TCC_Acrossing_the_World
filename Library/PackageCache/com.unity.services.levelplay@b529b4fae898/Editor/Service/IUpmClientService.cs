using System.Threading.Tasks;

namespace Unity.Services.LevelPlay.Editor
{
    interface IUpmClientService
    {
        Task AddPackageAsync(string packageIdentifier);
    }
}
