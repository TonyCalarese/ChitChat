package com.example.chitchat;

import android.os.AsyncTask;

import java.io.IOException;

import okhttp3.FormBody;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

public class SendMessage extends AsyncTask<Void, Void, String> implements HTTP_Server_Classifications {

    private String sMessage;
    private String messageURL(String message){
        return URL + "?" + "client=" + API_EMAIL + "&" + "key=" + API_KEY+ "&"+ "message="+message;
    }

    SendMessage(String message){ sMessage = message; }

    //Insert Sending function
    //Source of Reference: https://stackoverflow.com/questions/23456488/how-to-use-okhttp-to-make-a-post-request
    @Override
    protected String doInBackground(Void...voids) {
        RequestBody formBody = new FormBody.Builder()
                .add("message", sMessage)
                .build();
        Request request = new Request.Builder()
                .url(messageURL(sMessage))
                .post(formBody)
                .build();

        try {
            Response response = mHTTPClient.newCall(request).execute();
            return response.body().string();
            // Do something with the response.
        } catch (IOException e) {
            e.printStackTrace();
        }
        return "FAILED";
    }

}