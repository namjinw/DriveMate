package jinwoo.make.drivemate

import android.R.attr.bitmap
import android.R.attr.button
import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.drawable.Icon
import android.util.Base64
import android.util.Log
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.Button
import androidx.glance.ColorFilter
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.GlanceTheme
import androidx.glance.Image
import androidx.glance.ImageProvider
import androidx.glance.action.ActionParameters
import androidx.glance.action.clickable
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.GlanceAppWidgetReceiver
import androidx.glance.appwidget.action.ActionCallback
import androidx.glance.appwidget.action.actionRunCallback
import androidx.glance.appwidget.cornerRadius
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.Row
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxHeight
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.layout.size
import androidx.glance.layout.width
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider

class CarControllerWidget : GlanceAppWidget() {
    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            // 아까 저장한 저장소 가져오기
            val prefs = context.getSharedPreferences("AppWidget", Context.MODE_PRIVATE)

            val carImage = prefs.getString("carImage", null)

            val bitmap = if (!carImage.isNullOrEmpty()) {
                val decodeImage = Base64.decode(carImage, Base64.DEFAULT) // 문자열 다시 byteArray로 바꾸기
                BitmapFactory.decodeByteArray(decodeImage, 0, decodeImage.size) // 비트맵으로 변환
            } else {
                null
            }

            GlanceTheme {
                CarControllerScreen(bitmap)
            }
        }
    }
}

@SuppressLint("RestrictedApi")
@Composable
fun CarControllerScreen(bitmap: Bitmap?) {
    Box(
        modifier = GlanceModifier.fillMaxSize(),
        contentAlignment = Alignment.TopCenter
    ) {
        Column(
            modifier = GlanceModifier
                .fillMaxWidth()
                .padding(horizontal = 16.dp)
        ) {
            Column(
                modifier = GlanceModifier
                    .fillMaxWidth()
                    .height(120.dp)
                    .cornerRadius(16.dp)
                    .background(color = Color.Black.copy(alpha = 0.55f))
            ) {
                if (bitmap != null) {
                    title(modifier = GlanceModifier.height(30.dp))
                    CarControl(
                        bitmap, modifier = GlanceModifier.defaultWeight()
                            .fillMaxSize()
                    )
                } else {

                    Column (
                        modifier = GlanceModifier.fillMaxSize(),
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Image(
                            provider = ImageProvider(R.drawable.logo),
                            contentDescription = "Logo",
                            modifier = GlanceModifier.size(40.dp),
                            colorFilter = ColorFilter.tint(ColorProvider(R.color.logo))
                        )
                        Spacer(modifier = GlanceModifier.height(8.dp))
                        Text(
                            text = "아직 등록된 차량이 없습니다.",
                            style = TextStyle(
                                color = ColorProvider(Color.White),
                                fontSize = 16.sp,
                                fontWeight = FontWeight.Bold
                            )
                        )
                    }
                }
            }
        }
    }
}

@SuppressLint("RestrictedApi")
@Composable
fun title(modifier: GlanceModifier) {
    Row(
        modifier = modifier
            .fillMaxWidth()
            .background(color = Color.Black)
            .padding(horizontal = 12.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Row(
            modifier = GlanceModifier.fillMaxHeight(),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Image(
                provider = ImageProvider(R.drawable.logo),
                contentDescription = "Logo",
                modifier = GlanceModifier.size(15.dp),
                colorFilter = ColorFilter.tint(ColorProvider(R.color.logo))
            )
            Spacer(modifier = GlanceModifier.width(5.dp))
            Text(
                text = "Drive Mate",
                style = TextStyle(
                    // F2 하고 suppress 누르면 됨
                    // 오류 원인: 구글이 "내부용"이라고 딱지 붙여놓은 기능을 우리가 가져다 썼기 때문
                    color = ColorProvider(Color.White),
                    fontSize = 12.sp,
                    fontWeight = FontWeight.Bold
                )
            )
        }

        Spacer(modifier = GlanceModifier.defaultWeight().fillMaxWidth())

        Image(
            provider = ImageProvider(R.drawable.settings),
            contentDescription = "setting",
            colorFilter = ColorFilter.tint(ColorProvider(Color.White)),
            modifier = GlanceModifier
                .size(15.dp)
        )
    }
}

@SuppressLint("RestrictedApi")
@Composable
fun CarControl(bitmap: Bitmap, modifier: GlanceModifier) {
    Row(
        modifier = modifier
            .fillMaxWidth()
            .padding(bottom = 8.dp, start = 16.dp, end = 16.dp),
        verticalAlignment = Alignment.Bottom
    ) {
        Image(
            provider = ImageProvider(bitmap),
            contentDescription = "Car",
            modifier = GlanceModifier
                .defaultWeight()
                .height(60.dp)
        )
        Spacer(modifier = GlanceModifier.width(8.dp))
        Row(
            modifier = GlanceModifier
                .fillMaxHeight(),
            verticalAlignment = Alignment.Bottom
        ) {
            button(R.drawable.lock)
            Spacer(modifier = GlanceModifier.width(8.dp))
            button(R.drawable.power_settings, size = 55.dp, iconSize = 25.dp)
            Spacer(modifier = GlanceModifier.width(8.dp))
            button(R.drawable.lock_open)
        }
    }
}

@SuppressLint("RestrictedApi", "ResourceType")
@Composable
fun button(id: Int, size: Dp = 40.dp, iconSize: Dp = 20.dp) {
    Box(
        modifier = GlanceModifier
            .size(size + 4.dp)
            .padding(4.dp)
            .cornerRadius(size + 4.dp)
            .background(colorProvider = ColorProvider(Color.White.copy(0.1f))),
        contentAlignment = Alignment.Center
    ) {
        Box(
            modifier = GlanceModifier
                .fillMaxSize()
                .cornerRadius(size)
                .background(colorProvider = ColorProvider(R.drawable.button))
                .clickable(
                    onClick = actionRunCallback<EmptyCallBack>()
                )
                .background(color = Color.Black),
            contentAlignment = Alignment.Center
        ) {
            Image(
                provider = ImageProvider(id),
                contentDescription = "Icon1",
                modifier = GlanceModifier.size(iconSize),
                colorFilter = ColorFilter.tint(ColorProvider(Color.Gray))
            )
        }
    }
}

class EmptyCallBack : ActionCallback {
    override suspend fun onAction(
        context: Context,
        glanceId: GlanceId,
        parameters: ActionParameters
    ) {

    }
}

class CarControllerWidgetReceiver : GlanceAppWidgetReceiver() {
    override val glanceAppWidget: GlanceAppWidget = CarControllerWidget()
}