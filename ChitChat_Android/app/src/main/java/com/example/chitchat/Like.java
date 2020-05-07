package com.example.chitchat;

import android.os.AsyncTask;
import android.util.Log;

import okhttp3.Request;
import okhttp3.Response;

public class Like extends AsyncTask<Void, Void, String> implements HTTP_Server_Classifications {
    private String sID;
    public String concatLIKEURL(String id) {
        return LIKE_URL + id + "?" + "client=" + API_EMAIL + "&" + "key=" + API_KEY;
    }

    Like(String ID){
        sID = ID;
    }
    @Override
    protected String doInBackground(Void...voids) {
        Request request = new Request.Builder().url(concatLIKEURL(sID)).build();


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