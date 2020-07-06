import QtQuick 2.4
import Ubuntu.Components 1.3
import QtQml.Models 2.1
import Qt.labs.settings 1.0

import "../js/pixiv.js" as Pixiv
import "../Theme.js" as Theme
import "../components"
import "../components/ListItems" as ListItems


MainView{
    id: mainView
    objectName: "mainView"
    applicationName: "harbour-prxrv.gusma18"

    width: units.gu(100)
    height: units.gu(76)

    Component.onCompleted: {
        window.minimumWidth = units.gu(100)
        window.minimumHeight = units.gu(76)
        loginCheck()
        requestMgr.downloadProgress.connect(updateProgress)
        requestMgr.allImagesSaved.connect(notifyDownloadsFinished)
        requestMgr.errorMessage.connect(showErrorMessage)
    }    

    Page {
            id: mainPage

            header: PageHeader {
                id: mainPageHeader
                property int selectedTabIndex: 0

                leadingActionBar.actions: [
                    Action {
                        text: i18n.tr("Accounts")
                        onTriggered: mainPage.header.selectedTabIndex = 0
                        iconName: mainPage.header.selectedTabIndex == 0 ? "tick" : ""
                    },

                    Action {
                        text: i18n.tr("Main")
                        onTriggered: mainPage.header.selectedTabIndex = 1
                        iconName: mainPage.header.selectedTabIndex == 1 ? "tick" : ""
                    },

                    Action {
                        text: i18n.tr("Settings")
                        onTriggered: mainPage.header.selectedTabIndex = 2
                        iconName: mainPage.header.selectedTabIndex == 2 ? "tick" : ""
                    }
                ]
                trailingActionBar {
                    actions: [
                        Action {
                            id: startAction
                            text: i18n.tr('About')
                            iconName: "info"
                            onTriggered: {
                                mainPage.pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
                            }
                        }
                    ]
                }

                contents: ListItemLayout {
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: units.gu(0.25)
                    title.text: "Prxrv" 
                    subtitle.text: mainPageHeader.leadingActionBar.actions[mainPageHeader.selectedTabIndex].text
                }

                title: "Prxrv"
            }

            ListView {
                id: view
                anchors {
                    top: mainPage.header.bottom
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }

                clip: true
                orientation: ListView.Horizontal
                interactive: false
                snapMode: ListView.SnapOneItem
                highlightMoveDuration: 0
                currentIndex: mainPage.header.selectedTabIndex

                model: ObjectModel {
                    Loader {
                        width: view.width
                        height: view.height
                        asynchronous: true
                        source: Qt.resolvedUrl("AccountsPage.qml")
                    }
                    Loader {
                        width: view.width
                        height: view.height
                        asynchronous: true
                        source: Qt.resolvedUrl("IMPage.qml")
                    }
                    Loader {
                        width: view.width
                        height: view.height
                        asynchronous: true
                        source: Qt.resolvedUrl("SettingsPage.qml")
                    }
                }
            }
        }

}
/*Page {
    id: mainPage

    property string version: ""
    property string buildNum: ""

    ListView {
        id: homeListView

        anchors.fill: parent

        
        header: Label { text: "Prxrv" }

       /* PullDownMenu {
            id: pullDownMenu
            MenuItem {
                // TODO
                text: qsTr("About")
                onClicked: {
                    pageStack.push("AboutPage.qml")
                }
                visible: false
            }
            MenuItem {
                text: qsTr("Accounts")
                onClicked: {
                    pageStack.push("AccountsPage.qml")
                }
            }
            MenuItem {
                text: qsTr("Settings")
                onClicked: {
                    pageStack.push("SettingsPage.qml")
                }
            }
        }
        BusyIndicator {
            anchors.centerIn: parent
            running: token == "" && Boolean(user.name)
        }

        model: ListModel {
//            ListElement {
//                label: qsTr("Stacc")
//                model: "activityModel"
//                page: "StaccPage.qml"
//            }
            ListElement {
                label: qsTr("New Works")
                model: "latestWorkModel"
                page: "LatestWorkPage.qml"
            }
            ListElement {
                label: qsTr("Recommendation")
                model: "recommendationModel"
                page: "RecommendationPage.qml"
            }
            ListElement {
                label: qsTr("Rankings")
                model: "rankingWorkModel"
                page: "RankingPage.qml"
            }
            ListElement {
                label: qsTr("Bookmarks")
                model: "favoriteWorkModel"
                page: "FavoriteWorkPage.qml"
            }
            ListElement {
                label: qsTr("Search")
                model: ""
                page: "TrendsPage.qml"
            }
            ListElement {
                label: qsTr("Profile")
                model: ""
                page: "ProfilePage.qml"
            }
            ListElement {
                label: qsTr("Downloads")
                model: "downloadsModel"
                page: "DownloadsPage.qml"
            }
            ListElement {
                label: qsTr("Moebooru")
                model: "booruModel"
                page: "/usr/share/harbour-mieru/qml/pages/MainPage.qml"
            }
        }

        /*delegate: ListItem {
            id: listItem
            width: parent.width
            visible: model != "booruModel" || booruEnabled
            contentHeight: Theme.itemSizeMedium
            Label {
                color: listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                anchors.centerIn: parent
                text: label
            }
            onClicked: {
                firstPage = pageStack.currentPage
                if (page == 'ProfilePage.qml') {
                    var _props =  {"userID": user['id'], "userName": user['name']}
                    pageStack.push(page, _props)
                } else if (page == 'FavoriteWorkPage.qml') {
                    if (model) currentModel = [model,]
                    var _props =  {"userID": user['id'], "userName": user['name'], "mine": true}
                    pageStack.push(page, _props)
                } else if (model === 'booruModel') {
                    pageStack.push(page)
                    toReloadAccounts = true
                } else if (token) {
                    if (model) currentModel = [model,]
                    coverIndex = [0,]
                    if (label === 'Stacc' && staccListMode) {
                        pageStack.push('StaccListPage.qml')
                    } else {
                        pageStack.push(page)
                    }
                }
            }
        }
    }


    /*onStatusChanged: {
        if (status == PageStatus.Active) {
            console.log('Debug mode:', debugOn)
            // TODO side menu
            if (!user.name) {
                pageStack.push("AccountsPage.qml")
            }
        }
    }

    Component.onCompleted: {
        loginCheck()
        requestMgr.downloadProgress.connect(updateProgress)
        requestMgr.allImagesSaved.connect(notifyDownloadsFinished)
        requestMgr.errorMessage.connect(showErrorMessage)
    }

}*/

