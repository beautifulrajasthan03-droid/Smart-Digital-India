package com.smartdigitalindia.pro

import android.content.Context
import android.os.Bundle
import android.os.Vibrator
import android.widget.Button
import android.widget.LinearLayout
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.biometric.BiometricPrompt
import androidx.core.content.ContextCompat
import java.util.concurrent.Executor

class MainActivity : AppCompatActivity() {

    private lateinit var executor: Executor
    private lateinit var biometricPrompt: BiometricPrompt
    private lateinit var promptInfo: BiometricPrompt.PromptInfo

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        setContentView(R.layout.activity_main)

        val btnAuthenticate = findViewById<Button>(R.id.btnAuthenticate)
        val tvStatus = findViewById<TextView>(R.id.tvStatus)
        val mainLayout = findViewById<LinearLayout>(R.id.mainLayout)

        executor = ContextCompat.getMainExecutor(this)

        biometricPrompt = BiometricPrompt(this, executor,
            object : BiometricPrompt.AuthenticationCallback() {
                override fun onAuthenticationError(errorCode: Int, errString: CharSequence) {
                    super.onAuthenticationError(errorCode, errString)
                    Toast.makeText(applicationContext, "ऑथेंटिकेशन त्रुटि: $errString", Toast.LENGTH_SHORT).show()
                }

                override fun onAuthenticationSucceeded(result: BiometricPrompt.AuthenticationResult) {
                    super.onAuthenticationSucceeded(result)
                    
                    val vibrator = getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
                    vibrator.vibrate(200)

                    mainLayout.setBackgroundColor(ContextCompat.getColor(applicationContext, android.R.color.holo_green_light))
                    tvStatus.text = "सफलता! (Success) - सिस्टम सुरक्षित रूप से एक्टिव है।"
                    
                    Toast.makeText(applicationContext, "बायोमेट्रिक मिलान सफल! सिस्टम अनलॉक हो गया।", Toast.LONG).show()
                }

                override fun onAuthenticationFailed() {
                    super.onAuthenticationFailed()
                    Toast.makeText(applicationContext, "बायोमेट्रिक मैच नहीं हुआ। दोबारा कोशिश करें.", Toast.LENGTH_SHORT).show()
                }
            })

        promptInfo = BiometricPrompt.PromptInfo.Builder()
            .setTitle("Smart Digital India - सुरक्षा कवच")
            .setSubtitle("कृपया अपनी पहचान सत्यापित करने के लिए चेहरा या फिंगर स्कैन करें")
            .setNegativeButtonText("रद्द करें")
            .build()

        btnAuthenticate.setOnClickListener {
            biometricPrompt.authenticate(promptInfo)
        }
    }
}

