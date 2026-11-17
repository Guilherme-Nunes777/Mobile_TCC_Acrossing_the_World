namespace Unity.Services.LevelPlay.Editor
{
    interface IPackageUpdateCache
    {
        bool UpdateCheckPerformedThisSession { get; set; }
        string SkippedVersion { get; set; }
    }
}
