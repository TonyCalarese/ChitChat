package com.example.chitchat;

import okhttp3.OkHttpClient;

public interface HTTP_Server_Classifications {
    //Warning: if no messages appear then the server has most likely been taken down by David Kopec

    String API_KEY = "e781c246-6636-4e06-acd9-f5047b312508"; //API Key, critical for server response
    String API_EMAIL = "anthony.calarese@mymail.champlain.edu";
    String URL = "https://www.stepoutnyc.com/chitchat";
    String LIKE_URL = "https://www.stepoutnyc.com/chitchat/like/";
    String DISLIKE_URL = "https://www.stepoutnyc.com/chitchat/dislike/";
    OkHttpClient mHTTPClient = new OkHttpClient();

    String RESPONSE_TAG = "com.chitchat.response";
}
