/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <QScopedPointer>
#include <QGuiApplication>
#include <QQuickView>
#include <QQmlContext>
#include <QTextCodec>
#include <QQuickStyle>
#include <QQmlApplicationEngine> 
#include <QCoreApplication>
#include <QGuiApplication>

#include "pxvnamfactory.h"
#include "pxvimageprovider.h"
#include "requestmgr.h"
#include "cachemgr.h"
#include "utils.h"

int main(int argc, char *argv[])
{

    QTextCodec *codec = QTextCodec::codecForName("UTF-8");
    QTextCodec::setCodecForLocale(codec);

    //QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    //QScopedPointer<QQuickView> view(SailfishApp::createView());

    QGuiApplication *app = new QGuiApplication(argc, (char**)argv);
    app->setApplicationName("harbour-prxrv.gusma18");
    QCoreApplication::setAttribute(Qt::AA_UseHighDpiPixmaps);
    QCoreApplication::setAttribute(Qt::AA_UseHighDpiPixmaps);
    qputenv("QT_SCALE_FACTOR", "2.0");

    QQmlApplicationEngine engine;
    QQuickStyle::setStyle("Suru");
    QQuickView *view = new QQuickView();    

    

    PxvNAMFactory pnamf;    
    view.engine()->setNetworkAccessManagerFactory(&pnamf);

    PxvImageProvider* pxvImageProvider = new PxvImageProvider;
    view.engine()->addImageProvider(QLatin1String("pxv"), pxvImageProvider);

    RequestMgr requestMgr;
    view.rootContext()->setContextProperty("requestMgr", &requestMgr);

    CacheMgr cacheMgr;
    cacheMgr.setQNetworkAccessManager(view.engine()->networkAccessManager());
    view.rootContext()->setContextProperty("cacheMgr", &cacheMgr);

    Utils utils;
    view.rootContext()->setContextProperty("utils", &utils);
    
    engine.load(QUrl(QStringLiteral("qrc:///qml/harbour-prxrv.qml")));

    return app->exec();
}

