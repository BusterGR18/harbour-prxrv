import QtQuick 2.2
import Sailfish.Silica 1.0

import "../js/pixiv.js" as Pixiv
import "../js/prxrv.js" as Prxrv

Page {
    id: recommendationPage

    property int currentPage: 1
    property int currentIndex: -1

    property bool isNewModel: true

    property var thumbUrls: []
    property var thumbStatus: []    // 0: pending, 1: loading, 2: finished, -1: failed

    function addRecommendedWork(resp_j) {

        requestLock = false;

        if (!resp_j) return;

        var works = resp_j['illusts'];
        console.log('found works:', works.length);

        if (debugOn) console.log('adding works to recommendationModel');
        for (var i in works) {

            var square128 = works[i]['image_urls']['px_128x128'],
                    master480 = works[i]['image_urls']['px_480mw'],
                    squareM = works[i]['image_urls']['square_medium'];
            if (!square128 && squareM) square128 = squareM.replace("360x360_70", "128x128");
            if (!master480 && squareM) master480 = squareM.replace("360x360_70", "480x960").replace("square", "master");

            var authorIcon50 = works[i]['user']['profile_image_urls']['px_50x50'];
            var authorIconM = works[i]['user']['profile_image_urls']['medium'];
            if (!authorIcon50 && authorIconM)
                authorIcon50 = authorIconM.replace('_170.', '_50.');

            recommendationModel.append({
                workID: works[i]['id'],
                title: works[i]['title'],
                headerText: works[i]['title'],
                square128: square128,
                master480: master480,
                large: works[i]['image_urls']['large'],
                authorIcon: authorIcon50,
                authorID: works[i]['user']['id'],
                authorName: works[i]['user']['name'],
                isManga: works[i]['is_manga'] || false,
                favoriteID: works[i]['favorite_id'] || 0
            });

            thumbUrls.push(square128);
            thumbStatus.push(0);
        }

        Prxrv.getThumb(thumbUrls, '128x128');
    }

    function getWork() {
        Pixiv.getRecommendation(token, currentPage, addRecommendedWork);
    }

    // TODO status -1: failed, retry
    function setThumbs() {
        for (var i=0; i<thumbUrls.length; i++) {
            if (thumbStatus[i] > 1) continue;
            var thumb_url = thumbUrls[i];
            if (!thumb_url) continue;
            var thumb_path = Prxrv.getThumb(thumb_url, '128x128');
            if (thumb_path) {
                recommendationModel.get(i).square128 = thumb_path;
                thumbStatus[i] = 2;
            } else {
                thumbStatus[i] = 1;
            }
        }
    }


    Component {
        id: recommendationDelegate

        BackgroundItem {
            width: gridView.cellWidth
            height: width

            Image {
                anchors.centerIn: parent
                width: gridView.cellWidth
                height: width
                source: square128

                Image {
                    visible: isManga
                    anchors.left: parent.left
                    anchors.top: parent.top
                    source: "../images/manga-icon.svg"
                }
                Image {
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    source: favoriteID ? "../images/btn-done.svg" : "../images/btn-like.svg"

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            currentIndex = index
                            Prxrv.toggleBookmarkIcon(workID, favoriteID)
                        }
                    }
                }
            }

            onClicked: {
                var _props = {"workID": workID, "authorID": authorID, "currentIndex": index, "overwriteUrl": true}
                pageStack.push("DetailPage.qml", _props)
            }
        }
    }

    SilicaGridView {
        id: gridView

        anchors.fill: parent
        cellWidth: width / 3
        cellHeight: cellWidth

        model: recommendationModel
        delegate: recommendationDelegate

        header: PageHeader {
            title: qsTr("Recommendation")
        }

        PullDownMenu {
            id: pullDownMenu
            MenuItem {
                text: qsTr("Refresh")
                onClicked: {
                    if (loginCheck()) {
                        recommendationModel.clear()
                        currentPage = 1
                        getWork()
                    }
                }
            }
        }

        BusyIndicator {
            size: BusyIndicatorSize.Large
            anchors.centerIn: parent
            running: requestLock || !recommendationModel.count
        }

        onAtYEndChanged: {
            if (debugOn) console.log('at y end changed')
            if (gridView.atYEnd) {
                console.log('gridView at end')
                if ( !requestLock && recommendationModel.count > 0 && loginCheck() ) {
                    requestLock = true
                    currentPage += 1
                    getWork()
                }
            }
        }

    }

    Component.onCompleted: {
        console.log("onCompleted")
        if (isNewModel) {
            worksModelStack.push(recommendationModel)
            isNewModel = false
        }
        if (recommendationModel.count == 0) {
            if(loginCheck()) {
                currentPage = 1
                getWork()
            } else {
                // Try again
            }
        }

        // px128 local cache
        requestMgr.allCacheDone.connect(setThumbs);
    }

    Component.onDestruction: {
        requestMgr.allCacheDone.disconnect(setThumbs);
    }
}