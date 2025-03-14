// File created from SimpleUserProfileExample
// $ createScreen.sh Room/PollEditForm PollEditForm
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

import SwiftUI

@available(iOS 14.0, *)
struct PollTimelineView: View {
    
    // MARK: - Properties
    
    // MARK: Private
    
    @Environment(\.theme) private var theme: ThemeSwiftUI
    
    // MARK: Public
    
    @ObservedObject var viewModel: PollTimelineViewModel.Context
    
    var body: some View {
        let poll = viewModel.viewState.poll
        
        VStack(alignment: .leading, spacing: 16.0) {
            Text(poll.question)
                .font(theme.fonts.bodySB)
            
            VStack(spacing: 24.0) {
                ForEach(poll.answerOptions) { answerOption in
                    PollTimelineAnswerOptionButton(answerOption: answerOption,
                                                   pollClosed: poll.closed,
                                                   showResults: shouldDiscloseResults,
                                                   totalAnswerCount: poll.totalAnswerCount) {
                        viewModel.send(viewAction: .selectAnswerOptionWithIdentifier(answerOption.id))
                    }
                }
                .alert(isPresented: $viewModel.showsClosingFailureAlert) {
                    Alert(title: Text(VectorL10n.pollTimelineNotClosedTitle),
                          message: Text(VectorL10n.pollTimelineNotClosedSubtitle),
                          dismissButton: .default(Text(VectorL10n.ok)))
                }
            }
            .disabled(poll.closed)
            .fixedSize(horizontal: false, vertical: true)
            
            Text(totalVotesString)
                .font(theme.fonts.footnote)
                .foregroundColor(theme.colors.tertiaryContent)
                .alert(isPresented: $viewModel.showsAnsweringFailureAlert) {
                    Alert(title: Text(VectorL10n.pollTimelineVoteNotRegisteredTitle),
                          message: Text(VectorL10n.pollTimelineVoteNotRegisteredSubtitle),
                          dismissButton: .default(Text(VectorL10n.ok)))
                }
        }
        .padding([.horizontal, .top], 2.0)
        .padding([.bottom])
    }
    
    private var totalVotesString: String {
        let poll = viewModel.viewState.poll
        
        if poll.closed {
            if poll.totalAnswerCount == 1 {
                return VectorL10n.pollTimelineTotalFinalResultsOneVote
            } else {
                return VectorL10n.pollTimelineTotalFinalResults(Int(poll.totalAnswerCount))
            }
        }
        
        switch poll.totalAnswerCount {
        case 0:
            return VectorL10n.pollTimelineTotalNoVotes
        case 1:
            return (poll.hasCurrentUserVoted ?
                        VectorL10n.pollTimelineTotalOneVote :
                        VectorL10n.pollTimelineTotalOneVoteNotVoted)
        default:
            return (poll.hasCurrentUserVoted ?
                        VectorL10n.pollTimelineTotalVotes(Int(poll.totalAnswerCount)) :
                        VectorL10n.pollTimelineTotalVotesNotVoted(Int(poll.totalAnswerCount)))
        }
    }
    
    private var shouldDiscloseResults: Bool {
        let poll = viewModel.viewState.poll
        
        if poll.closed {
            return poll.totalAnswerCount > 0
        } else {
            return poll.type == .disclosed && poll.totalAnswerCount > 0 && poll.hasCurrentUserVoted
        }
    }
}

// MARK: - Previews

@available(iOS 14.0, *)
struct PollTimelineView_Previews: PreviewProvider {
    static let stateRenderer = MockPollTimelineScreenState.stateRenderer
    static var previews: some View {
        stateRenderer.screenGroup()
    }
}
