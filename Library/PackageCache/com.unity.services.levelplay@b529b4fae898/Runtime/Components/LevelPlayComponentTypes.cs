using System;
using System.Threading;

namespace Unity.Services.LevelPlay
{
    static class LevelPlayComponentUtility
    {
        internal static string SelectByPlatform(string androidValue, string iosValue)
        {
#if UNITY_ANDROID
            return androidValue;
#elif UNITY_IOS
            return iosValue;
#else
            return string.IsNullOrEmpty(androidValue) ? iosValue : androidValue;
#endif
        }

        internal static void RunOnMainThread(Action action)
        {
            var unityContext = ThreadUtil.UnitySynchronizationContext;
            if (unityContext == null || SynchronizationContext.Current == unityContext)
            {
                action();
                return;
            }

            ThreadUtil.Post(_ => action());
        }
    }
}
