import QtQuick 2.4
import Ubuntu.Components 1.3


import "../js/pixiv.js" as Pixiv
import "../Theme.js" as Theme
import "../components/ListItems" as ListItems

    ScrollView{
        id: rootItem
        anchors.fill: parent

        Column{
            width: rootItem.width
            
            ListItems.SectionDivider {
            text: "Welcome to Prxrv"
            }

            ListItems.Page{
                text: "New Works"
                pageUrl: Qt.resolvedUrl("LatestWorkPage.qml")
            }

            ListItems.Page{
                text: "Recommendation"
                pageUrl: Qt.resolvedUrl("RecommendationPage.qml")
            }

            ListItems.Page{
                text: "Rankings"
                pageUrl: Qt.resolvedUrl("RankingPage.qml")
            }

            ListItems.Page{
                text: "Bookmarks"
                pageUrl: Qt.resolvedUrl("FavoriteWorkPage.qml")
            }

            ListItems.Page{
                text: "Search"
                pageUrl: Qt.resolvedUrl("TrendsPage.qml")
            }

            ListItems.Page{
                text: "Profile"
                pageUrl: Qt.resolvedUrl("ProfilePage.qml")
            }

            ListItems.Page{
                text: "Downloads"
                pageUrl: Qt.resolvedUrl("DownloadsPage.qml")
            }
        }

    }