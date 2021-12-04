package com.example.recorder;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.media.AudioFormat;
import android.media.AudioManager;
import android.media.AudioRecord;
import android.media.MediaPlayer;
import android.media.MediaRecorder;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import android.view.View;
import android.widget.Button;

import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;

import java.io.BufferedOutputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

public class MainActivity extends AppCompatActivity {
    // Part I  : select the audio file in the local folder to play.
    Button selectPlayButton;

    // Part II : generate and play a anchored chirp.
//    EditText frequencyEditor;
    Button generatePlayButton;
    int frequency = 0;
    final static int FREQ_L = 4000;
    final static int FREQ_H = 6000;

    final static String GENERATE_FILENAME = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS).getAbsolutePath() + "/generate.wav";

    // Part III:
    // record audio and save it to a local file according to the sample rate entered by the user.
//    EditText sampleRateEditor;
    Button startRecordButton, stopRecordButton;
    int bufferSize = 0;
    int sampleRate = 0;
    boolean isRecording = false;
    final static int channelConfiguration = AudioFormat.CHANNEL_IN_STEREO;   // dual channel
    final static int audioEncoding = AudioFormat.ENCODING_PCM_16BIT;         // 16 bits

    final static String HOST_NAME = "192.168.241.1";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        getPermission();

        // Part I
        selectPlayButton = findViewById(R.id.select_play_button);
        selectPlayButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
                intent.setType("audio/*");
                intent.addCategory(Intent.CATEGORY_OPENABLE);
                startActivityForResult(intent, 1);
            }
        });

        // Part II
//        frequencyEditor = findViewById(R.id.frequency_editor);
        generatePlayButton = findViewById(R.id.generate_play_button);
        generatePlayButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
//                String frequencyText = frequencyEditor.getText().toString();
//                try {
//                    frequency = Integer.parseInt(frequencyText);
//                } catch (NumberFormatException e) {
//                    Log.e("Part II", "Incorrect frequency");
//                    Toast.makeText(MainActivity.this, "Frequency is incorrect.", Toast.LENGTH_SHORT).show();
//                    return;
//                }
                // generate and play
                generateSound();
                Log.d("Play", "to play");
//                play(null, GENERATE_FILENAME);
                Log.d("Play", "played");
//                uploadRecording();
            }
        });

        // Part III
//        sampleRateEditor = findViewById(R.id.sample_rate_editor);
        startRecordButton = findViewById(R.id.start_record_button);
        stopRecordButton = findViewById(R.id.stop_record_button);
        stopRecordButton.setEnabled(false);
        startRecordButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
//                String sampleRateText = sampleRateEditor.getText().toString();
//                try {
//                    sampleRate = Integer.parseInt(sampleRateText);
//                } catch (NumberFormatException e) {
//                    Log.e("Part III", "Incorrect sample rate.");
//                    Toast.makeText(MainActivity.this, "Sample rate is incorrect.", Toast.LENGTH_SHORT).show();
//                    return;
//                }
                stopRecordButton.setEnabled(true);
                startRecordButton.setEnabled(false);
                Thread thread = new Thread(new Runnable() {
                    @Override
                    public void run() {
                        String temp = Environment.getExternalStorageDirectory().getAbsolutePath()
                                + "/Music/raw.wav";
                        Timestamp now = new Timestamp(System.currentTimeMillis());
                        @SuppressLint("SimpleDateFormat")
                        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd-HH-mm-ss");
                        String name = Environment.getExternalStorageDirectory().getAbsolutePath()
                                + "/Music/" + format.format(now) + ".wav";

                        startRecord(temp);
                        copyWav(temp, name);
                    }
                });
                thread.start();
            }
        });
        stopRecordButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                isRecording = false;
                stopRecordButton.setEnabled(false);
                startRecordButton.setEnabled(true);
            }
        });
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }

    // ---------------------------I-----------------------------

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode != 1 || resultCode != Activity.RESULT_OK) return;

        assert data != null;
        Uri uri = data.getData();
        if (uri != null) {
            play(uri, null);
        } else {
            Log.e("Part I", "Fail to select file.");
        }
    }

    private void play(Uri uri, String filename) {
        MediaPlayer mediaPlayer = new MediaPlayer();
        mediaPlayer.setAudioStreamType(AudioManager.STREAM_MUSIC);
        final long[] now = new long[1];
        try {
            if (uri != null) mediaPlayer.setDataSource(getApplicationContext(), uri);
            else mediaPlayer.setDataSource(filename);
            mediaPlayer.setOnPreparedListener(new MediaPlayer.OnPreparedListener() {
                @Override
                public void onPrepared(MediaPlayer mp) {
                    mp.start();
                    now[0] = System.currentTimeMillis();
                    Log.d("Part I & II", "Prepared. Start to play.");
                }
            });
            mediaPlayer.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
                @Override
                public void onCompletion(MediaPlayer mp) {
                    Log.d("During", System.currentTimeMillis() - now[0] + "ms");
                    Log.d("Part I & II", "Finish playing. Reset.");
                    mp.release();
                }
            });
            mediaPlayer.prepareAsync();
        } catch (IOException e) {
            Log.e("Part I & II", "Fail to init player");
            e.printStackTrace();
        }
    }


    // --------------------------II-----------------------------
    public void generateSound() {
        try {
            FileOutputStream outFile = new FileOutputStream(GENERATE_FILENAME);
            // 16位双通道
            long longSampleRate = 48000;
            // 音频数据总长度=(采样率 * 通道数 * 比特数 / 8) * 持续时间(s)
            long totalAudioLen = (longSampleRate * 2 * 16 / 8) / 2;
            double k = (double) (FREQ_H - FREQ_L) / 2;
            // 为wav文件写文件头
            writeWaveHeader(outFile, totalAudioLen, 48000);
            //
            byte[] data = new byte[4];
            for (long i = 0; i < longSampleRate / 2; i++) {   // 0.5s
                double tl = (double) i / longSampleRate;
                short vl = (short) (32768 * Math.cos(2 * Math.PI * (FREQ_L*tl + k*tl*tl/2)));
                double tr = ((double) i + 0.5) / longSampleRate;
                short vr = (short) (32768 * Math.cos(2 * Math.PI * (FREQ_L*tr + k*tr*tr/2)));
                data[0] = (byte)(vl & 0xFF);
                data[1] = (byte)((vl >> 8) & 0xFF);
                data[2] = (byte)(vr & 0xFF);
                data[3] = (byte)((vr >> 8) & 0xFF);
                outFile.write(data, 0, 4);
            }

        } catch (Exception e)
        {
            e.printStackTrace();
        }
    }


    // --------------------------III----------------------------

    public void startRecord(String name) {
        File file = new File(name);
        if (file.exists()) file.delete();
        try {
            file.createNewFile();
        } catch (IOException e) {
            throw new IllegalStateException("Unable to create " + file.toString());
        }

        try {
            DataOutputStream dos = new DataOutputStream(new BufferedOutputStream(new FileOutputStream(file)));
            bufferSize = AudioRecord.getMinBufferSize(sampleRate, channelConfiguration, audioEncoding);
            AudioRecord audioRecord = new AudioRecord(MediaRecorder.AudioSource.MIC,
                    sampleRate, channelConfiguration, audioEncoding, bufferSize);
            byte[] buffer = new byte[bufferSize];
            audioRecord.startRecording();
            isRecording = true;

            while (isRecording) {
                int bufferReadSize = audioRecord.read(buffer, 0, bufferSize);
                for (int i = 0; i < bufferReadSize; i++)
                    dos.write(buffer[i]);
            }

            audioRecord.stop();
            dos.close();
        } catch (Throwable e) {
            Log.e("Part III", "Fail to record");
            e.printStackTrace();
        }
    }

    public void copyWav(String inName, String outName) {
        FileInputStream inFile;
        FileOutputStream outFile;
        long totalAudioLen = 0;
        byte[] data = new byte[bufferSize];
        try {
            inFile = new FileInputStream(inName);
            outFile = new FileOutputStream(outName);
            totalAudioLen = inFile.getChannel().size();
            writeWaveHeader(outFile, totalAudioLen, sampleRate);
            while(inFile.read(data) != -1) {
                outFile.write(data);
            }
            inFile.close();
            outFile.close();
        } catch (Throwable e) {
            Log.e("Part III", "Fail to transform");
            e.printStackTrace();
        }
    }

    private void writeWaveHeader(FileOutputStream outFile, long totalAudioLen, int sampleRate)
            throws IOException {
        int channels = 2;
        long totalDataLen = totalAudioLen + 36;
        long byteRate = 16 * sampleRate * channels / 8;

        byte[] header = new byte[44];
        header[0] = 'R'; // RIFF/WAVE header
        header[1] = 'I';
        header[2] = 'F';
        header[3] = 'F';
        header[4] = (byte) (totalDataLen & 0xff);
        header[5] = (byte) ((totalDataLen >> 8) & 0xff);
        header[6] = (byte) ((totalDataLen >> 16) & 0xff);
        header[7] = (byte) ((totalDataLen >> 24) & 0xff);
        header[8] = 'W';
        header[9] = 'A';
        header[10] = 'V';
        header[11] = 'E';
        header[12] = 'f'; // 'fmt ' chunk
        header[13] = 'm';
        header[14] = 't';
        header[15] = ' ';
        header[16] = 16;
        header[17] = 0;
        header[18] = 0;
        header[19] = 0;
        header[20] = 1; // WAV type format = 1
        header[21] = 0;
        header[22] = (byte) channels; //指示是单声道还是双声道
        header[23] = 0;
        header[24] = (byte) ((long) sampleRate & 0xff); //采样频率
        header[25] = (byte) (((long) sampleRate >> 8) & 0xff);
        header[26] = (byte) (((long) sampleRate >> 16) & 0xff);
        header[27] = (byte) (((long) sampleRate >> 24) & 0xff);
        header[28] = (byte) (byteRate & 0xff); //每分钟录到的字节数
        header[29] = (byte) ((byteRate >> 8) & 0xff);
        header[30] = (byte) ((byteRate >> 16) & 0xff);
        header[31] = (byte) ((byteRate >> 24) & 0xff);
        header[32] = (byte) (2 * 16 / 8); // block align
        header[33] = 0;
        header[34] = 16; // bits per sample
        header[35] = 0;
        header[36] = 'd';
        header[37] = 'a';
        header[38] = 't';
        header[39] = 'a';
        header[40] = (byte) (totalAudioLen & 0xff); //真实数据的长度
        header[41] = (byte) ((totalAudioLen >> 8) & 0xff);
        header[42] = (byte) ((totalAudioLen >> 16) & 0xff);
        header[43] = (byte) ((totalAudioLen >> 24) & 0xff);
        //把header写入wav文件
        outFile.write(header, 0, 44);
    }

    private void getPermission() {
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO) != PackageManager.PERMISSION_GRANTED ||
                ActivityCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED ||
                ActivityCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, new String[]{
                    Manifest.permission.RECORD_AUDIO,
                    Manifest.permission.WRITE_EXTERNAL_STORAGE,
                    Manifest.permission.READ_EXTERNAL_STORAGE}, 0);
        }
    }

    private void uploadRecording() {
        FTPClient ftpClient = new FTPClient();
        try {
            ftpClient.connect(HOST_NAME);

            if (ftpClient.login("Zheng", "060143")) {
                ftpClient.enterLocalPassiveMode();
                ftpClient.setFileType(FTP.BINARY_FILE_TYPE);

                FileInputStream inFile = new FileInputStream(new File(GENERATE_FILENAME));
                boolean ok = ftpClient.storeFile("remote.wav", inFile);
                inFile.close();

                if (ok) Log.d("Upload", "succeed");
                ftpClient.logout();
                ftpClient.disconnect();
            }
        } catch (Exception e) {
            Log.e("Upload", "failed");
            e.printStackTrace();
        }
    }
}