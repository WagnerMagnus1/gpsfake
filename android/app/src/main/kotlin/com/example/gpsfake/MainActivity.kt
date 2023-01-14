package com.example.gpsfake

import android.content.Context
import android.content.Intent
import android.location.Location
import android.location.LocationManager
import android.os.Build
import android.os.SystemClock
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "example.com/channel")
        .setMethodCallHandler { call, result ->
          if (call.method == "updateLatitudeLongitude") {
            if (isMockLocationEnabled()) {
              setMock(
                  provider = LocationManager.GPS_PROVIDER,
                  latitude = -29.341929,
                  longitude = -49.735942
              )
            }
          } else {
            result.notImplemented()
          }
          if (call.method == "isMockLocationEnabled") {
            var isEnabledDeveloperSettingsGPS = isMockLocationEnabled()
            result.success(isEnabledDeveloperSettingsGPS)
          }
          if (call.method == "openSettingsUser") {
            startActivity(Intent(android.provider.Settings.ACTION_APPLICATION_DEVELOPMENT_SETTINGS))
          }
        }
  }

  fun isMockLocationEnabled(): Boolean {
    var mLocationManager = getSystemService(Context.LOCATION_SERVICE) as LocationManager
    var gps_enabled: Boolean;
    gps_enabled = mLocationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)
    return gps_enabled
  }

  fun setMock(provider: String, latitude: Double, longitude: Double) {
    var mLocationManager = getSystemService(Context.LOCATION_SERVICE) as LocationManager

    mLocationManager.addTestProvider(provider, false, false, false, false, false, true, true, 0, 5)

    var newLocation = Location(provider)

    newLocation.setLatitude(latitude)
    newLocation.setLongitude(longitude)
    newLocation.setAltitude(0.0)
    newLocation.setTime(System.currentTimeMillis())
    newLocation.setSpeed(0.01F)
    newLocation.setBearing(1F)
    newLocation.setAccuracy(3F)
    newLocation.setElapsedRealtimeNanos(SystemClock.elapsedRealtimeNanos())
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      newLocation.setBearingAccuracyDegrees(0.1F)
      newLocation.setVerticalAccuracyMeters(0.1F)
      newLocation.setSpeedAccuracyMetersPerSecond(0.01F)
    }
    mLocationManager.setTestProviderEnabled(provider, true)

    mLocationManager.setTestProviderLocation(provider, newLocation)
  }
}
