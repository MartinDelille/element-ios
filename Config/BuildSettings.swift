// 
// Copyright 2020 Vector Creations Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import Keys

/// BuildSettings provides settings computed at build time.
/// In future, it may be automatically generated from xcconfig files
@objcMembers
final class BuildSettings: NSObject {
    
    // MARK: - Bundle Settings
    static var applicationGroupIdentifier: String {
        guard let applicationGroupIdentifier = Bundle.app.object(forInfoDictionaryKey: "applicationGroupIdentifier") as? String else {
            fatalError("applicationGroupIdentifier should be defined")
        }
        return applicationGroupIdentifier
    }
    
    static var baseBundleIdentifier: String {
        guard let baseBundleIdentifier = Bundle.app.object(forInfoDictionaryKey: "baseBundleIdentifier") as? String else {
            fatalError("baseBundleIdentifier should be defined")
        }
        return baseBundleIdentifier
    }
    
    static var keychainAccessGroup: String {
        guard let keychainAccessGroup = Bundle.app.object(forInfoDictionaryKey: "keychainAccessGroup") as? String else {
            fatalError("keychainAccessGroup should be defined")
        }
        return keychainAccessGroup
    }
    
    static var applicationURLScheme: String? {
        guard let urlTypes = Bundle.app.object(forInfoDictionaryKey: "CFBundleURLTypes") as? [AnyObject],
              let urlTypeDictionary = urlTypes.first as? [String: AnyObject],
              let urlSchemes = urlTypeDictionary["CFBundleURLSchemes"] as? [AnyObject],
              let externalURLScheme = urlSchemes.first as? String else {
            return nil
        }
        
        return externalURLScheme
    }
    
    static var pushKitAppIdProd: String {
        return baseBundleIdentifier + ".ios.voip.prod"
    }
    
    static var pushKitAppIdDev: String {
        return baseBundleIdentifier + ".ios.voip.dev"
    }
    
    static var pusherAppIdProd: String {
        return baseBundleIdentifier + ".ios.prod"
    }
    
    static var pusherAppIdDev: String {
        return baseBundleIdentifier + ".ios.dev"
    }
    
    static var pushKitAppId: String {
        #if DEBUG
        return pushKitAppIdDev
        #else
        return pushKitAppIdProd
        #endif
    }
    
    static var pusherAppId: String {
        #if DEBUG
        return pusherAppIdDev
        #else
        return pusherAppIdProd
        #endif
    }
    
    // Element-Web instance for the app
    static let applicationWebAppUrlString = "https://app.element.io"
    
    
    // MARK: - Server configuration
    
    // Default servers proposed on the authentication screen
    static let serverConfigDefaultHomeserverUrlString = "https://matrix.org"
    static let serverConfigDefaultIdentityServerUrlString = "https://vector.im"
    
    static let serverConfigSygnalAPIUrlString = "https://matrix.org/_matrix/push/v1/notify"
    
    
    // MARK: - Legal URLs
    
    // Note: Set empty strings to hide the related entry in application settings
    static let applicationCopyrightUrlString = "https://element.io/copyright"
    static let applicationPrivacyPolicyUrlString = "https://element.io/privacy"
    static let applicationTermsConditionsUrlString = "https://element.io/terms-of-service"
    static let applicationHelpUrlString =
    "https://element.io/help"
    
    
    // MARK: - Permalinks
    // Hosts/Paths for URLs that will considered as valid permalinks. Those permalinks are opened within the app.
    static let permalinkSupportedHosts: [String: [String]] = [
        "app.element.io": [],
        "staging.element.io": [],
        "develop.element.io": [],
        "mobile.element.io": [""],
        // Historical ones
        "riot.im": ["/app", "/staging", "/develop"],
        "www.riot.im": ["/app", "/staging", "/develop"],
        "vector.im": ["/app", "/staging", "/develop"],
        "www.vector.im": ["/app", "/staging", "/develop"],
        // Official Matrix ones
        "matrix.to": ["/"],
        "www.matrix.to": ["/"],
        // Client Permalinks (for use with `BuildSettings.clientPermalinkBaseUrl`)
//        "example.com": ["/"],
//        "www.example.com": ["/"],
    ]
    
    // For use in clients that use a custom base url for permalinks rather than matrix.to.
    // This baseURL is used to generate permalinks within the app (E.g. timeline message permalinks).
    // Optional String that when set is used as permalink base, when nil matrix.to format is used.
    // Example value would be "https://www.example.com", note there is no trailing '/'.
    static let clientPermalinkBaseUrl: String? = nil
    
    // MARK: - VoIP
    static var allowVoIPUsage: Bool {
        #if canImport(JitsiMeetSDK)
        return true
        #else
        return false
        #endif
    }
    static let stunServerFallbackUrlString: String? = "stun:turn.matrix.org"
    
    // MARK: -  Public rooms Directory
    #warning("Unused build setting: should this be implemented in ShowDirectory?")
    static let publicRoomsAllowServerChange: Bool = true
    // List of homeservers for the public rooms directory
    static let publicRoomsDirectoryServers = [
        "matrix.org",
        "gitter.im"
    ]
    
    // MARK: -  Rooms Screen
    static let roomsAllowToJoinPublicRooms: Bool = true
    
    // MARK: - Analytics
    #if DEBUG
    /// Host to use for PostHog analytics during development. Set to nil to disable analytics in debug builds.
    static let analyticsHost: String? = "https://posthog-poc.lab.element.dev"
    /// Public key for submitting analytics during development. Set to nil to disable analytics in debug builds.
    static let analyticsKey: String? = "rs-pJjsYJTuAkXJfhaMmPUNBhWliDyTKLOOxike6ck8"
    #else
    /// Host to use for PostHog analytics. Set to nil to disable analytics.
    static let analyticsHost: String? = "https://posthog.hss.element.io"
    /// Public key for submitting analytics. Set to nil to disable analytics.
    static let analyticsKey: String? = "phc_Jzsm6DTm6V2705zeU5dcNvQDlonOR68XvX2sh1sEOHO"
    #endif
    
    /// The URL to open with more information about analytics terms.
    static let analyticsTermsURL = URL(string: "https://element.io/cookie-policy")!
    
    
    // MARK: - Bug report
    static let bugReportEndpointUrlString = "https://riot.im/bugreports"
    // Use the name allocated by the bug report server
    static let bugReportApplicationId = "riot-ios"
    
    
    // MARK: - Integrations
    static let integrationsUiUrlString = "https://scalar.vector.im/"
    static let integrationsRestApiUrlString = "https://scalar.vector.im/api"
    // Widgets in those paths require a scalar token
    static let integrationsScalarWidgetsPaths = [
        "https://scalar.vector.im/_matrix/integrations/v1",
        "https://scalar.vector.im/api",
        "https://scalar-staging.vector.im/_matrix/integrations/v1",
        "https://scalar-staging.vector.im/api",
        "https://scalar-staging.riot.im/scalar/api",
    ]
    // Jitsi server used outside integrations to create conference calls from the call button in the timeline
    static let jitsiServerUrl: URL = URL(string: "https://jitsi.riot.im")!

    
    // MARK: - Features
    
    /// Setting to force protection by pin code
    static let forcePinProtection: Bool = false
    
    /// Max allowed time to continue using the app without prompting PIN
    static let pinCodeGraceTimeInSeconds: TimeInterval = 0
    
    /// Force non-jailbroken app usage
    static let forceNonJailbrokenUsage: Bool = true
    
    static let allowSendingStickers: Bool = true
    
    static let allowLocalContactsAccess: Bool = true
    
    static let allowInviteExernalUsers: Bool = true
    
    static let enableSideMenu: Bool = true
    
    /// Whether to read the `io.element.functional_members` state event and exclude any service members when computing a room's name and avatar.
    static let supportFunctionalMembers: Bool = true
    
    // MARK: - Feature Specifics
    
    /// Not allowed pin codes. User won't be able to select one of the pin in the list.
    static let notAllowedPINs: [String] = []
    
    /// Maximum number of allowed pin failures when unlocking, before force logging out the user. Defaults to `3`
    static let maxAllowedNumberOfPinFailures: Int = 3
    
    /// Maximum number of allowed biometrics failures when unlocking, before fallbacking the user to the pin if set or logging out the user. Defaults to `5`
    static let maxAllowedNumberOfBiometricsFailures: Int = 5
    
    /// Indicates should the app log out the user when number of PIN failures reaches `maxAllowedNumberOfPinFailures`. Defaults to `false`
    static let logOutUserWhenPINFailuresExceeded: Bool = false
    
    /// Indicates should the app log out the user when number of biometrics failures reaches `maxAllowedNumberOfBiometricsFailures`. Defaults to `false`
    static let logOutUserWhenBiometricsFailuresExceeded: Bool = false
    
    static let showNotificationsV2: Bool = true
    
    // MARK: - Main Tabs
    
    static let homeScreenShowFavouritesTab: Bool = true
    static let homeScreenShowPeopleTab: Bool = true
    static let homeScreenShowRoomsTab: Bool = true
    static let homeScreenShowCommunitiesTab: Bool = true

    // MARK: - General Settings Screen
    
    static let settingsScreenShowUserFirstName: Bool = false
    static let settingsScreenShowUserSurname: Bool = false
    static let settingsScreenAllowAddingEmailThreepids: Bool = true
    static let settingsScreenAllowAddingPhoneThreepids: Bool = true
    static let settingsScreenShowThreepidExplanatory: Bool = true
    static let settingsScreenShowDiscoverySettings: Bool = true
    static let settingsScreenAllowIdentityServerConfig: Bool = true
    static let settingsScreenShowConfirmMediaSize: Bool = true
    static let settingsScreenShowAdvancedSettings: Bool = true
    static let settingsScreenShowLabSettings: Bool = true
    static let settingsScreenAllowChangingRageshakeSettings: Bool = true
    static let settingsScreenAllowChangingCrashUsageDataSettings: Bool = true
    static let settingsScreenAllowBugReportingManually: Bool = true
    static let settingsScreenAllowDeactivatingAccount: Bool = true
    static let settingsScreenShowChangePassword:Bool = true
    static let settingsScreenShowInviteFriends:Bool = true
    static let settingsScreenShowEnableStunServerFallback: Bool = true
    static let settingsScreenShowNotificationDecodedContentOption: Bool = true
    static let settingsScreenShowNsfwRoomsOption: Bool = true
    static let settingsSecurityScreenShowSessions:Bool = true
    static let settingsSecurityScreenShowSetupBackup:Bool = true
    static let settingsSecurityScreenShowRestoreBackup:Bool = true
    static let settingsSecurityScreenShowDeleteBackup:Bool = true
    static let settingsSecurityScreenShowCryptographyInfo:Bool = true
    static let settingsSecurityScreenShowCryptographyExport:Bool = true
    static let settingsSecurityScreenShowAdvancedUnverifiedDevices:Bool = true

    // MARK: - Timeline settings
    static let roomInputToolbarCompressionMode = MXKRoomInputToolbarCompressionModePrompt
    
    // MARK: - Room Creation Screen
    
    static let roomCreationScreenAllowEncryptionConfiguration: Bool = true
    static let roomCreationScreenRoomIsEncrypted: Bool = true
    static let roomCreationScreenAllowRoomTypeConfiguration: Bool = true
    static let roomCreationScreenRoomIsPublic: Bool = false
    
    // MARK: - Room Screen
    
    static let roomScreenAllowVoIPForDirectRoom: Bool = true
    static let roomScreenAllowVoIPForNonDirectRoom: Bool = true
    static let roomScreenAllowCameraAction: Bool = true
    static let roomScreenAllowMediaLibraryAction: Bool = true
    static let roomScreenAllowStickerAction: Bool = true
    static let roomScreenAllowFilesAction: Bool = true
    
    // Timeline style
    static let roomScreenAllowTimelineStyleConfiguration: Bool = false
    static let roomScreenTimelineDefaultStyleIdentifier: RoomTimelineStyleIdentifier = .plain
    static var roomScreenEnableMessageBubblesByDefault: Bool {
        return self.roomScreenTimelineDefaultStyleIdentifier == .bubble
    }

    /// Allow split view detail view stacking    
    static let allowSplitViewDetailsScreenStacking: Bool = true
    
    // MARK: - Room Contextual Menu

    static let roomContextualMenuShowMoreOptionForMessages: Bool = true
    static let roomContextualMenuShowMoreOptionForStates: Bool = true
    static let roomContextualMenuShowReportContentOption: Bool = true

    // MARK: - Room Info Screen
    
    static let roomInfoScreenShowIntegrations: Bool = true

    // MARK: - Room Settings Screen
    
    static let roomSettingsScreenShowLowPriorityOption: Bool = true
    static let roomSettingsScreenShowDirectChatOption: Bool = true
    static let roomSettingsScreenAllowChangingAccessSettings: Bool = true
    static let roomSettingsScreenAllowChangingHistorySettings: Bool = true
    static let roomSettingsScreenShowAddressSettings: Bool = true
    static let roomSettingsScreenShowFlairSettings: Bool = true
    static let roomSettingsScreenShowAdvancedSettings: Bool = true
    static let roomSettingsScreenAdvancedShowEncryptToVerifiedOption: Bool = true

    // MARK: - Room Member Screen
    
    static let roomMemberScreenShowIgnore: Bool = true

    // MARK: - Message
    static let messageDetailsAllowShare: Bool = true
    static let messageDetailsAllowPermalink: Bool = true
    static let messageDetailsAllowViewSource: Bool = true
    static let messageDetailsAllowSave: Bool = true
    static let messageDetailsAllowCopyMedia: Bool = true
    static let messageDetailsAllowPasteMedia: Bool = true
    
    // MARK: - Notifications
    static let decryptNotificationsByDefault: Bool = true
    
    // MARK: - HTTP
    /// Additional HTTP headers will be sent by all requests. Not recommended to use request-specific headers, like `Authorization`.
    /// Empty dictionary by default.
    static let httpAdditionalHeaders: [String: String] = [:]
    
    
    // MARK: - Authentication Screen
    static let authScreenShowRegister = true
    static let authScreenShowPhoneNumber = true
    static let authScreenShowForgotPassword = true
    static let authScreenShowCustomServerOptions = true
    
    // MARK: - Unified Search
    static let unifiedSearchScreenShowPublicDirectory = true
    
    // MARK: - Secrets Recovery
    static let secretsRecoveryAllowReset = true
    
    // MARK: - Polls
    
    static var pollsEnabled: Bool {
        guard #available(iOS 14, *) else {
            return false
        }
        
        return true
    }
    
    // MARK: - Location Sharing
    
    static let tileServerMapURL = URL(string: "https://api.maptiler.com/maps/streets/style.json?key=" + RiotKeys().mapTilerAPIKey)!
    
    static var locationSharingEnabled: Bool {
        guard #available(iOS 14, *) else {
            return false
        }
        
        return false
    }
}
