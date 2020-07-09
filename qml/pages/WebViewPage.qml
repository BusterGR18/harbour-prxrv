import QtQuick 2.9
import Ubuntu.Components 1.3
import Morph.Web 0.1
import QtWebEngine 1.7

Page {
    property string initUrl: "http://touch.pixiv.net/"


    id: mwebview
    anchors {
        top: parent.top
        left: parent.left
        right: parent.right
        bottom: parent.bottom
    }
    Header: PageHeader {
            visible: false
    }

    WebContext {
            id: webcontext
    }

    WebView {
            id: webview

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            // TODO error page
            context: webcontext
            url: initUrl

            //settings.allowRunningInsecureContent: true

            Component.onCompleted: {
                settings.localStorageEnabled = true
            }

        }

        ProgressBar {
            height: units.dp(3)
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }

            showProgressPercentage: false
            value: (webview.loadProgress / 100)
            visible: (webview.loading && !webview.lastLoadStopped)
        }

    /*SilicaWebView {
        id: webView

        header: PageHeader {
            title: webView.title
        }

        anchors.fill: parent
        url: initUrl
        experimental.userAgent: "Mozilla/5.0 (iPad; CPU OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5355d Safari/8536.25"
        //experimental.userAgent: "Mozilla/5.0 (Linux; U; Android 4.0.3; ko-kr; LG-L160L Build/IML74K) AppleWebkit/534.30    (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30"
        //experimental.deviceWidth: 560

        BusyIndicator {
            size: BusyIndicatorSize.Large
            anchors.centerIn: parent
            running: webView.loading
        }

        onVerticalVelocityChanged: {
            if (verticalVelocity > 0) {
                panel.open = false
            } else if (verticalVelocity < 0) {
                panel.open = true
            }
        }

    }

    FontLoader {
        source: '../fonts/fontawesome-webfont.ttf'
    }

    DockedPanel {
        id: panel

        width: parent.width
        height: 72

        dock: Dock.Bottom
        open: true

        Row {
            anchors.centerIn: parent
            height: parent.height
            width: parent.width
            Label {
                height: parent.height
                width: parent.width / 3
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: 'FontAwesome'
                font.pixelSize: Theme.fontSizeLarge
                text: '\uf060'
                color: webView.canGoBack ? Theme.primaryColor : Theme.secondaryHighlightColor

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (webView.canGoBack) webView.goBack()
                    }
                }
            }
            Label {
                height: parent.height
                width: parent.width / 3
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: 'FontAwesome'
                font.pixelSize: Theme.fontSizeLarge
                text: webView.loading ? '\uf00d' : '\uf021'
                color: Theme.primaryColor

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        webView.loading ? webView.stop() : webView.reload()
                    }
                }
            }
            Label {
                height: parent.height
                width: parent.width / 3
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: 'FontAwesome'
                font.pixelSize: Theme.fontSizeLarge
                text: '\uf061'
                color: webView.canGoForward ? Theme.primaryColor : Theme.secondaryHighlightColor

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (webView.canGoForward) webView.goForward()
                    }
                }
            }
        }
    }*/
}
