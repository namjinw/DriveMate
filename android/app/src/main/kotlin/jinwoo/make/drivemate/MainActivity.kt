package jinwoo.make.drivemate

import android.util.Base64
import android.util.Log
import androidx.glance.appwidget.updateAll
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.launch

class MainActivity : FlutterActivity() {

    // Flutter 엔진 받아오기
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "kotlin").setMethodCallHandler { call ,result ->
            if (call.method == "getCar") {
                val carId = call.argument<String>("carId")!!
                val carNm = call.argument<String>("carNm")!!
                val carNo = call.argument<String>("carNo")!!
                val carImage = call.argument<ByteArray>("carImage")!!
                val temperature = call.argument<String>("temperature")!!
                val weather = call.argument<String>("weather")!!
                val location = call.argument<String>("location")!!
                val drvngPosblDstnc = call.argument<Int>("drvngPosblDstnc")!!
                // Byte를 문자열로 변환 후 저장
                val encodeImage = Base64.encodeToString(carImage, Base64.DEFAULT)

                val prefs = getSharedPreferences("AppWidget", MODE_PRIVATE)

                prefs.edit().apply {
                    putString("carId", carId)
                    putString("carNm", carNm)
                    putString("carNo", carNo)
                    putString("carImage", encodeImage)
                    putString("temperature", temperature)
                    putString("weather", weather)
                    putString("location", location)
                    putInt("drvngPosblDstnc", drvngPosblDstnc)
                    apply()
                }

                // 정보 업데이트 시 모든 위젯이 동시에 새로고침
                MainScope().launch {
                    CarControllerWidget().updateAll(context)
                }

                result.success(true)
            }
        }
    }
}
