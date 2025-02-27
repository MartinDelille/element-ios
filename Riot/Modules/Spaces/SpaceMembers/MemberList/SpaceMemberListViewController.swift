// File created from ScreenTemplate
// $ createScreen.sh Spaces/SpaceMembers/MemberList ShowSpaceMemberList
/*
 Copyright 2021 New Vector Ltd
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import UIKit

final class SpaceMemberListViewController: RoomParticipantsViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let emptySearchViewMargin: CGFloat = 8
    }
    
    // MARK: - Properties
    
    // MARK: Private

    private var viewModel: SpaceMemberListViewModelType!
    private var theme: Theme!
    private var errorPresenter: MXKErrorPresentation!
    private var activityPresenter: ActivityIndicatorPresenter!
    private var titleView: MainTitleView!
    private var emptyView: SearchEmptyView!

    private var emptyViewArtwork: UIImage {
        return ThemeService.shared().isCurrentThemeDark() ? Asset.Images.peopleEmptyScreenArtworkDark.image : Asset.Images.peopleEmptyScreenArtwork.image
    }
    
    // MARK: - Setup
    
    class func instantiate(with viewModel: SpaceMemberListViewModelType) -> SpaceMemberListViewController {
        let viewController = SpaceMemberListViewController()
        viewController.viewModel = viewModel
        viewController.showParticipantCustomAccessoryView = false
        viewController.theme = ThemeService.shared().theme
        viewController.emptyView = SearchEmptyView()
        return viewController
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.setupViews()
        self.activityPresenter = ActivityIndicatorPresenter()
        self.errorPresenter = MXKErrorAlertPresentation()
        
        self.registerThemeServiceDidChangeThemeNotification()
        self.update(theme: self.theme)
        
        self.viewModel.viewDelegate = self

        self.viewModel.process(viewAction: .loadData)
        
        self.title = ""
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.theme.statusBarStyle
    }
    
    // MARK: - Private
    
    private func update(theme: Theme) {
        self.theme = theme
        
        self.view.backgroundColor = theme.headerBackgroundColor
        
        if let navigationBar = self.navigationController?.navigationBar {
            theme.applyStyle(onNavigationBar: navigationBar)
        }
        
        theme.applyStyle(onSearchBar: self.searchBarView)
        self.titleView.update(theme: theme)
        self.emptyView.update(theme: theme)
    }
    
    private func registerThemeServiceDidChangeThemeNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: .themeServiceDidChangeTheme, object: nil)
    }
    
    @objc private func themeDidChange() {
        self.update(theme: ThemeService.shared().theme)
    }
    
    private func setupViews() {
        let cancelBarButtonItem = MXKBarButtonItem(title: VectorL10n.cancel, style: .plain) { [weak self] in
            self?.cancelButtonAction()
        }
        
        self.navigationItem.rightBarButtonItem = cancelBarButtonItem
        
        self.titleView = MainTitleView()
        self.titleView.titleLabel.text = VectorL10n.roomDetailsPeople
        self.navigationItem.titleView = self.titleView
        
        self.emptyView.frame = CGRect(x: Constants.emptySearchViewMargin, y: self.searchBarView.frame.maxY + 2 * Constants.emptySearchViewMargin, width: self.view.bounds.width - 2 * Constants.emptySearchViewMargin, height: 0)
        self.emptyView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.emptyView.alpha = 0
        self.view.insertSubview(self.emptyView, at: 0)
    }

    private func render(viewState: SpaceMemberListViewState) {
        switch viewState {
        case .loading:
            self.renderLoading()
        case .loaded(let space):
            self.renderLoaded(space: space)
        case .error(let error):
            self.render(error: error)
        }
    }
    
    private func renderLoading() {
        self.activityPresenter.presentActivityIndicator(on: self.view, animated: true)
    }
    
    private func renderLoaded(space: MXSpace) {
        self.activityPresenter.removeCurrentActivityIndicator(animated: true)
        self.mxRoom = space.room
        self.titleView.subtitleLabel.text = space.summary?.displayname
        self.emptyView.titleLabel.text = VectorL10n.spacesNoResultFoundTitle
        self.emptyView.detailLabel.text = VectorL10n.spacesNoMemberFoundDetail(space.summary?.displayname ?? "")
        self.emptyView.layoutIfNeeded()
    }
    
    private func render(error: Error) {
        self.activityPresenter.removeCurrentActivityIndicator(animated: true)
        self.errorPresenter.presentError(from: self, forError: error, animated: true, handler: nil)
    }

    @objc private func showDetail(for member: MXRoomMember, from sourceView: UIView?) {
        self.viewModel.process(viewAction: .complete(member, sourceView))
    }
    
    // MARK: - Actions

    @objc private func onAddParticipantButtonPressed() {
        self.errorPresenter.presentError(from: self, title: VectorL10n.spacesInvitesComingSoonTitle, message: VectorL10n.spacesComingSoonDetail(AppInfo.current.displayName), animated: true, handler: nil)
    }
    
    private func cancelButtonAction() {
        self.viewModel.process(viewAction: .cancel)
    }
    
    // MARK: - UISearchBarDelegate

    override func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    override func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        super.searchBar(searchBar, textDidChange: searchText)
        
        UIView.animate(withDuration: 0.2) {
            self.emptyView.alpha = self.tableView.numberOfSections == 0 ? 1 : 0
            self.tableView.alpha = self.tableView.numberOfSections == 0 ? 0 : 1
        }
    }
    
    // MARK: - MXKRoomMemberDetailsViewControllerDelegate

    override func roomMemberDetailsViewController(_ roomMemberDetailsViewController: MXKRoomMemberDetailsViewController!, startChatWithMemberId matrixId: String!, completion: (() -> Void)!) {
        completion()
        self.errorPresenter.presentError(from: self, title: VectorL10n.spacesComingSoonTitle, message: VectorL10n.spacesComingSoonDetail(AppInfo.current.displayName), animated: true, handler: nil)
    }

    override func roomMemberDetailsViewController(_ roomMemberDetailsViewController: MXKRoomMemberDetailsViewController!, placeVoipCallWithMemberId matrixId: String!, andVideo isVideoCall: Bool) {
        self.errorPresenter.presentError(from: self, title: VectorL10n.spacesComingSoonTitle, message: VectorL10n.spacesComingSoonDetail(AppInfo.current.displayName), animated: true, handler: nil)
    }
}


// MARK: - SpaceMemberListViewModelViewDelegate
extension SpaceMemberListViewController: SpaceMemberListViewModelViewDelegate {

    func spaceMemberListViewModel(_ viewModel: SpaceMemberListViewModelType, didUpdateViewState viewSate: SpaceMemberListViewState) {
        self.render(viewState: viewSate)
    }
}
