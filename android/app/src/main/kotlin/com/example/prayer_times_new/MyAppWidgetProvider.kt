package com.example.prayer_times_new

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import android.content.SharedPreferences

class MyAppWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onEnabled(context: Context) {
        // Widget pertama kali ditambahkan
    }

    override fun onDisabled(context: Context) {
        // Widget terakhir dihapus
    }

    companion object {
        fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            // ✅ Gunakan key yang sama dengan di Flutter
            val prefs: SharedPreferences = context.getSharedPreferences(
                "prayer_widget_prefs", 
                Context.MODE_PRIVATE
            )
            
            val prayerName = prefs.getString("prayer_name", "Subuh") ?: "Subuh"
            val prayerTime = prefs.getString("prayer_time", "04:30") ?: "04:30"
            val regionName = prefs.getString("region_name", "Lokasi Anda") ?: "Lokasi Anda"
            val date = prefs.getString("date", "") ?: ""

            val views = RemoteViews(context.packageName, R.layout.prayer_widget)
            views.setTextViewText(R.id.widget_prayer_name, prayerName)
            views.setTextViewText(R.id.widget_prayer_time, prayerTime)
            views.setTextViewText(R.id.widget_region, regionName)
            views.setTextViewText(R.id.widget_date, date)
            
            appWidgetManager.updateAppWidget(appWidgetId, views)
            
            // Debug log
            android.util.Log.d("Widget", "Updated widget $appWidgetId: $prayerName at $prayerTime")
        }
    }
}