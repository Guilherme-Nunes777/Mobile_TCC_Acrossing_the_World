# Microsoft GDK Sample: Social Manager

**Relevant areas:** User Sign-in, Social Manager API, Friends

# Description

The Unity Social Manager sample demonstrates the usage of XBOX Live Social Manager using the Unity game engine. You can alter friend groups based on different levels of presence & relationships to find a specific group of users from the XBOX Services API.

![Screenshot of sample](../images/SocialManager-001.png)

# Building the Sample

For general information on how to run Unity GDK samples, see the samples section of the com.unity.microosft.gdk package documentation.

![Screenshot of Package Manager UI](../images/SocialManager-002.png)

# Noteable Code Files

**XboxManager.cs**: Contains initialization of the XBOX GDK & XBOX Live Services APIs,
along with signing in a user & querying various information, such as Sandbox
& Title ID.

**XboxSocialManager.cs**: Contains APIs demonstrating the usage of the
XBOX Live Social Manager.

# Running the Sample

You will need an XBOX Live test account signed in to execute social
group changes & retrieving user statuses.

The desktop's sandbox **must** be set to XDKS.1.

**IMPORTANT:** In order to see results in the friends
section, you must have at least one friend linked to the XBOX user
logged in, via Friends or Favorites. A refresh is automatically
triggered on some XBOX Services events, such as presence changes or
social group updates.

*Social Group commands:*

-   '*All Friends'*

    -   XblPresenceFilter = XblPresenceFilter.All

    -   XblRelationshipFilter = XblRelationshipFilter.Friends

-   'All Favorites'

    -   XblPresenceFilter = XblPresenceFilter.All

    -   XblRelationshipFilter = XblRelationshipFilter.Favorite

-   *'All Online Friends'*

    -   XblPresenceFilter = XblPresenceFilter.AllOnline

    -   XblRelationshipFilter = XblRelationshipFilter.Friends

-   *'In-Title Friends'*

    -   XblPresenceFilter = XblPresenceFilter.TitleOnline

    -   XblRelationshipFilter = XblRelationshipFilter.Friends

**IMPORTANT:** These use a pre-defined combination of XBOX Services
presence & relationship filters to determine the retrieved XBOX users
related to the calling XBOX user.

*Friends section commands:*

-   '*Gamertag ... Status'* -- displays the gamertag & connection
    status of the first five users found that meet the social criteria
    of the current social group setting. Upon selection, it also
    displays the user's XBOX profile, via XBOX UI.

**IMPORTANT:** These are only displayed if there is a user that meets
the given criteria from the pre-defined filters. Otherwise, they remain
blank.

*Additional commands:*

-   '*Sign In'* -- allows for a new user to sign in using the XBOX user
    selection UI.

-   '*Refresh' ­*-- manually refreshes the user list of XBOX users.

-   '*Close' --* Closes the sample.
