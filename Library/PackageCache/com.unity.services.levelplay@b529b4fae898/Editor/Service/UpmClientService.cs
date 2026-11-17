using System.IO;
using System.Threading.Tasks;
using UnityEditor.PackageManager;

namespace Unity.Services.LevelPlay.Editor
{
    class UpmClientService : IUpmClientService
    {
        public async Task AddPackageAsync(string packageIdentifier)
        {
            var request = Client.Add(packageIdentifier);
            while (!request.IsCompleted)
            {
                await Task.Yield();
            }

            if (request.Status == StatusCode.Failure)
            {
                throw new IOException($"Failed to install package {packageIdentifier} with : {request.Error?.message}");
            }
        }
    }
}
