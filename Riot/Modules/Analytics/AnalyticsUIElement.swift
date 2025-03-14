// 
// Copyright 2021 New Vector Ltd
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

import AnalyticsEvents

/// A tappable UI element that can be track in Analytics.
@objc enum AnalyticsUIElement: Int {
    case sendMessageButton
    
    /// The element name reported to the AnalyticsEvent.
    var elementName: AnalyticsEvent.Click.Name {
        switch self {
        // Note: This is a test element that doesn't need to be captured.
        // It will likely be removed when the AnalyticsEvent.Click is updated.
        case .sendMessageButton:
            return .SendMessageButton
        }
    }
}
