package com.example.chitchat;

import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;

import okhttp3.Request;
import okhttp3.Response;

public class MainActivity extends AppCompatActivity implements HTTP_Server_Classifications {

    private RecyclerView mChitChatRecycler;
    private ChitChatAdapter mChitChatAdapter;
    private SwipeRefreshLayout mSwipeRefreshLayout;

    public String concatURL() { //Gather the URL from the interface
        return URL + "?" + "client=" + API_EMAIL + "&" + "key=" + API_KEY;
    }

    private String PUBLIC_URL = concatURL();

    private ArrayList<String> mMessages = new ArrayList<String>();
    private ArrayList<Integer> mLikes = new ArrayList<Integer>();
    private ArrayList<Integer> mDislikes = new ArrayList<Integer>();
    private ArrayList<String> mDates = new ArrayList<String>();
    private ArrayList<String> mIDs = new ArrayList<String>();

    private Button mPostButton;
    private EditText mText;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        mChitChatAdapter = new ChitChatAdapter();
        mChitChatRecycler = (RecyclerView) findViewById(R.id.chat_view);
        mChitChatRecycler.setLayoutManager(new LinearLayoutManager(this));
        mChitChatRecycler.setAdapter(mChitChatAdapter);

        //mHTTPClient = new OkHttpClient();
        mSwipeRefreshLayout = (SwipeRefreshLayout) findViewById(R.id.chat_swipe);
        mSwipeRefreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                refresh();
            }
        });
        mText = (EditText) findViewById(R.id.text_to_post);
        mPostButton = (Button) findViewById(R.id.post_button);
        mPostButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                //Note that this is an Open platform and that everyone will be able to see what is posted
                send_message(mText.getEditableText().toString());
                refresh(); //Refresh in the end
            }
        });

        refresh();
    }

    private void parseJSON(String jsonString) {
        mMessages.clear();
        try {
            JSONObject responseObject = new JSONObject(jsonString);
            JSONArray items = responseObject.getJSONArray("messages");
            for (int i = 0; i < items.length(); i++) {
                JSONObject item = items.getJSONObject(i);
                String mes = item.getString("message");
                int like = item.getInt("likes");
                int dlike = item.getInt("dislikes");
                String date = item.getString("date");
                String ID = item.getString("_id");

                mMessages.add(mes);
                mLikes.add(like);
                mDislikes.add(dlike);
                mDates.add(date);
                mIDs.add(ID);

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    public class ChitChatAdapter extends RecyclerView.Adapter<MainActivity.ChitChatHolder> {
        @NonNull
        @Override
        public MainActivity.ChitChatHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
            LayoutInflater li = LayoutInflater.from(getApplicationContext());
            return new MainActivity.ChitChatHolder(li.inflate(R.layout.chat_cell, parent, false));
        }

        @Override
        public void onBindViewHolder(@NonNull MainActivity.ChitChatHolder holder, int position) {
            holder.bind(mMessages.get(position), mLikes.get(position), mDislikes.get(position), mDates.get(position), position);
        }

        @Override
        public int getItemCount() {
            return mMessages.size();
        }
    }

    public class ChitChatHolder extends RecyclerView.ViewHolder {
        private int index;
        private TextView mMessage, mLikes, mDislikes, mDate;
        private Button mLikeButton, mDislikeButton;

        public ChitChatHolder(@NonNull View itemView) {
            super(itemView);
            mMessage = itemView.findViewById(R.id.cell_text);
            mLikes = itemView.findViewById(R.id.like_text);
            mDislikes = itemView.findViewById(R.id.dislike_text);
            mDate = itemView.findViewById(R.id.date_text);
            mLikeButton = itemView.findViewById(R.id.like_button);
            mLikeButton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    try {
                        like_post(mIDs.get(index));
                        mLikeButton.setEnabled(false); //disable button
                        mLikes.setText(Integer.getInteger(mLikes.getText().toString()) + 1);
                    } catch (Exception e) {
                        System.out.println("ERROR LIKING THE POST");
                    }
                    refresh(); //Refresh in the end
                }
            });
            mDislikeButton = itemView.findViewById(R.id.dislike_button);
            mDislikeButton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    try {
                        dislike_post(mIDs.get(index));
                        mDislikeButton.setEnabled(false); //disable button
                        mDislikes.setText(Integer.getInteger(mDislikes.getText().toString()) + 1);

                    } catch (Exception e) {
                        System.out.println("ERROR DISLIKING THE POST");
                    }
                    refresh(); //Refresh in the end
                }
            });

        }

        public void bind(String message, int likes, int dislikes, String date, int position) {
            mMessage.setText(message);
            mLikes.setText(Integer.toString(likes));
            mDislikes.setText(Integer.toString(dislikes));
            mDate.setText(date);
            index = position;

        }
    }


    //Refresh
    private class GetMessages extends AsyncTask<Void, Void, String> {
        @Override
        protected String doInBackground(Void... voids) {
            Request request = new Request.Builder().url(PUBLIC_URL).build();


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
            parseJSON(result);
            mChitChatAdapter.notifyDataSetChanged();
            mSwipeRefreshLayout.setRefreshing(false);
        }
    }

    private void refresh() {
        mMessages.clear();
        mLikes.clear();
        mDislikes.clear();
        mIDs.clear();
        mDates.clear();
        GetMessages rt = new GetMessages();
        rt.execute();
    }
    private void like_post(String ID) {
        Like l = new Like(ID);
        l.execute();
    }
    private void dislike_post(String ID) {
        Dislike dl = new Dislike(ID);
        dl.execute();
    }
    private void send_message(String message) {
        SendMessage sm = new SendMessage(message);
        sm.execute();

    }
}