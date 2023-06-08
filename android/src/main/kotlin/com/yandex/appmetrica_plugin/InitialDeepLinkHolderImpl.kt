package com.yandex.appmetrica_plugin

import android.app.Activity
import com.yandex.android.metrica.flutter.pigeon.Pigeon

class InitialDeepLinkHolderImpl : Pigeon.InitialDeepLinkHolderPigeon {

    var activity: Activity? = null

    override fun getInitialDeeplink(): String? = activity?.intent?.dataString
}
