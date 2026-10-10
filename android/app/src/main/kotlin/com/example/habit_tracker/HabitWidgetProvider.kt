package com.example.habit_tracker

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.content.res.Configuration
import android.graphics.Color
import android.net.Uri
import android.os.Bundle
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin
import es.antonborri.home_widget.HomeWidgetProvider
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.TimeZone

class HabitWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        for (id in appWidgetIds) {
            val views = RemoteViews(context.packageName, layoutFor(context, appWidgetManager, id))
            bind(context, id, views, widgetData)

            // Tapping anywhere except the arrows opens the shown tracker so the user can check in.
            val count = widgetData.getInt("hw_count", 0)
            val trackerId = if (count > 0) {
                widgetData.getString("hw_${currentIndex(context, id, widgetData, count)}_id", null)
            } else {
                null
            }
            val uri = trackerId?.let { Uri.parse("habittrail://tracker?id=$it") }
            views.setOnClickPendingIntent(
                R.id.widget_root,
                HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java, uri),
            )
            appWidgetManager.updateAppWidget(id, views)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action != ACTION_SWITCH) return

        val id = intent.getIntExtra(EXTRA_WIDGET_ID, AppWidgetManager.INVALID_APPWIDGET_ID)
        if (id == AppWidgetManager.INVALID_APPWIDGET_ID) return

        val data = HomeWidgetPlugin.getData(context)
        val count = data.getInt("hw_count", 0)
        if (count < 2) return

        val next = Math.floorMod(currentIndex(context, id, data, count) + intent.getIntExtra(EXTRA_STEP, 1), count)
        state(context).edit().putString("sel_$id", data.getString("hw_${next}_id", "")).apply()
        onUpdate(context, AppWidgetManager.getInstance(context), intArrayOf(id), data)
    }

    override fun onDeleted(context: Context, appWidgetIds: IntArray) {
        super.onDeleted(context, appWidgetIds)
        val editor = state(context).edit()
        appWidgetIds.forEach { editor.remove("sel_$it") }
        editor.apply()
    }

    // Re-render with a different layout when the user resizes the widget.
    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: Bundle,
    ) {
        super.onAppWidgetOptionsChanged(context, appWidgetManager, appWidgetId, newOptions)
        onUpdate(context, appWidgetManager, intArrayOf(appWidgetId), HomeWidgetPlugin.getData(context))
    }

    private fun state(context: Context): SharedPreferences =
        context.getSharedPreferences("habit_widget_state", Context.MODE_PRIVATE)

    // Each widget remembers its tracker by id so reordering or deleting trackers does not shift it.
    private fun currentIndex(context: Context, widgetId: Int, data: SharedPreferences, count: Int): Int {
        val selected = state(context).getString("sel_$widgetId", null)
        if (selected != null) {
            for (i in 0 until count) {
                if (data.getString("hw_${i}_id", "") == selected) return i
            }
        }
        return data.getInt("hw_default", 0).coerceIn(0, count - 1)
    }

    private fun switchIntent(context: Context, widgetId: Int, step: Int): PendingIntent {
        val intent = Intent(context, HabitWidgetProvider::class.java)
            .setAction(ACTION_SWITCH)
            .putExtra(EXTRA_WIDGET_ID, widgetId)
            .putExtra(EXTRA_STEP, step)
        return PendingIntent.getBroadcast(
            context,
            widgetId * 2 + if (step > 0) 1 else 0,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
    }

    // Height is fixed at 2 rows; width picks the layout: 2 columns small, 3 medium, 4 large.
    private fun layoutFor(context: Context, manager: AppWidgetManager, id: Int): Int {
        val options = manager.getAppWidgetOptions(id)
        val landscape = context.resources.configuration.orientation == Configuration.ORIENTATION_LANDSCAPE
        val width = options.getInt(
            if (landscape) AppWidgetManager.OPTION_APPWIDGET_MAX_WIDTH
            else AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH,
        )
        return when {
            width in 1..219 -> R.layout.habit_widget_small
            width in 220..319 -> R.layout.habit_widget
            width >= 320 -> R.layout.habit_widget_large
            else -> R.layout.habit_widget
        }
    }

    private fun bind(context: Context, widgetId: Int, views: RemoteViews, data: SharedPreferences) {
        val dayIds = intArrayOf(
            R.id.widget_day0, R.id.widget_day1, R.id.widget_day2, R.id.widget_day3,
            R.id.widget_day4, R.id.widget_day5, R.id.widget_day6,
        )
        // Views missing from the current layout are ignored by RemoteViews.
        val optional = intArrayOf(
            R.id.widget_streak_label, R.id.widget_status, R.id.widget_days, R.id.widget_progress_row,
        )
        val switcher = intArrayOf(R.id.widget_prev, R.id.widget_next, R.id.widget_page)

        val count = data.getInt("hw_count", 0)
        if (count == 0) {
            views.setTextViewText(R.id.widget_streak, "+")
            views.setViewVisibility(R.id.widget_flame, View.GONE)
            views.setTextViewText(R.id.widget_title, "No active habit")
            views.setTextViewText(R.id.widget_message, "Tap to start a new trail")
            views.setTextColor(R.id.widget_message, MUTED)
            views.setFloat(R.id.widget_streak, "setAlpha", 1f)
            (optional + switcher).forEach { views.setViewVisibility(it, View.GONE) }
            return
        }
        optional.forEach { views.setViewVisibility(it, View.VISIBLE) }

        val index = currentIndex(context, widgetId, data, count)
        val p = "hw_${index}_"

        val multiple = count > 1
        switcher.forEach { views.setViewVisibility(it, if (multiple) View.VISIBLE else View.GONE) }
        if (multiple) {
            views.setTextViewText(R.id.widget_prev, "\u2039")
            views.setTextViewText(R.id.widget_next, "\u203A")
            views.setTextViewText(R.id.widget_page, "${index + 1}/$count")
            views.setOnClickPendingIntent(R.id.widget_prev, switchIntent(context, widgetId, -1))
            views.setOnClickPendingIntent(R.id.widget_next, switchIntent(context, widgetId, 1))
        }

        // Data is written when the app runs; after midnight it describes yesterday.
        val today = SimpleDateFormat("yyyy-MM-dd", Locale.US).format(Date())
        val stale = data.getString("${p}date", "") != today
        val done = data.getBoolean("${p}checked", false) && !stale

        views.setViewVisibility(R.id.widget_flame, View.VISIBLE)
        val streak = data.getInt("${p}streak", 0)
        views.setTextViewText(R.id.widget_streak, "$streak")
        // A dimmed streak means today is not checked in yet.
        val alpha = if (done) 1f else 0.55f
        views.setFloat(R.id.widget_streak, "setAlpha", alpha)
        views.setFloat(R.id.widget_flame, "setAlpha", alpha)
        views.setTextViewText(R.id.widget_status, data.getString("${p}status", ""))
        views.setTextViewText(R.id.widget_title, data.getString("${p}title", ""))

        // The message changes daily and the set of 7 repeats every week.
        val slot = Math.floorMod(
            (System.currentTimeMillis() + TimeZone.getDefault().rawOffset) / DAY_MILLIS,
            MESSAGES_PER_WEEK.toLong(),
        ).toInt()
        val (message, messageColor) = if (done) {
            DONE_MESSAGES[slot] to GREEN
        } else if (slot == 0 && streak == 0) {
            "Start your streak today!" to LIME
        } else {
            PENDING_MESSAGES[slot] to LIME
        }
        views.setTextViewText(R.id.widget_message, message)
        views.setTextColor(R.id.widget_message, messageColor)

        views.setProgressBar(R.id.widget_progress, 100, data.getInt("${p}percent", 0), false)

        val firstDay = data.getInt("${p}first_day", 1)
        val days = data.getString("${p}days", "") ?: ""
        dayIds.forEachIndexed { i, viewId ->
            if (i >= days.length) {
                views.setViewVisibility(viewId, View.INVISIBLE)
                return@forEachIndexed
            }
            views.setViewVisibility(viewId, View.VISIBLE)
            val number = "${firstDay + i}"
            val (background, label, color) = when (days[i]) {
                's' -> Triple(R.drawable.widget_day_success, "\u2713", Color.WHITE)
                'f' -> Triple(R.drawable.widget_day_failed, "\u2715", Color.WHITE)
                't' -> Triple(R.drawable.widget_day_today, number, LIME)
                'p' -> Triple(R.drawable.widget_day_pending, number, AMBER)
                else -> Triple(R.drawable.widget_day_locked, number, MUTED)
            }
            views.setInt(viewId, "setBackgroundResource", background)
            views.setTextViewText(viewId, label)
            views.setTextColor(viewId, color)
        }
    }

    private companion object {
        const val ACTION_SWITCH = "com.example.habit_tracker.SWITCH_TRACKER"
        const val EXTRA_WIDGET_ID = "widget_id"
        const val EXTRA_STEP = "step"
        const val DAY_MILLIS = 86_400_000L
        const val MESSAGES_PER_WEEK = 7

        val PENDING_MESSAGES = arrayOf(
            "Don't let it break!",
            "Keep your streak alive today",
            "One check-in away from a win",
            "Small steps, big change",
            "Show up for yourself today",
            "Your future self is counting on you",
            "Tap to check in now",
        )
        val DONE_MESSAGES = arrayOf(
            "Done today. See you tomorrow!",
            "Nice work! Your streak is safe",
            "Another day in the books",
            "Consistency looks good on you",
            "That's how habits are built",
            "You showed up. Proud of you!",
            "Rest up and roll on tomorrow",
        )

        val LIME = Color.parseColor("#DDF276")
        val AMBER = Color.parseColor("#F5B544")
        val GREEN = Color.parseColor("#7FE0AE")
        val MUTED = Color.parseColor("#A9C4B8")
    }
}
