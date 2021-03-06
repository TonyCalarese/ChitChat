package com.example.chitchat;

import android.os.AsyncTask;
import android.util.Log;

import okhttp3.Request;
import okhttp3.Response;

public class Dislike extends AsyncTask<Void, Void, String> implements HTTP_Server_Classifications {
    private String sID;
    public String concatDISLIKEURL(String id) {
        return DISLIKE_URL + id + "?" + "client=" + API_EMAIL + "&" + "key=" + API_KEY;
    }

    Dislike(String ID){
        sID = ID;
    }
    @Override
    protected String doInBackground(Void...voids) {
        Request request = new Request.Builder().url(concatDISLIKEURL(sID)).build();

        try (Response response = mHTTPClient.newCall(request).execute()) {
            return response.body().string();
        } catch (Exception e) {
            e.printStackTrace();
            return "Error: Could not complete request.";
        }
    }
    @Override
    protected void onPostExecute(String result) {
        super.onPostExecute(result);
        Log.d(RESPONSE_TAG, result);

    }
}

