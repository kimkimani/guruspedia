---
layout: blog
status: publish
published: true
url: /complete-guide-to-making-api-calls-in-android-using-retrofit/
title: A Complete Guide to Making API Calls in Android using Retrofit
description: In this article, you will build an android app using Retrofit. One library that stands out for API HTTP communication is Retrofit to facilitate communication between your android application and an external server(API).
date: 2023-07-20T00:00:00-01:00
topics: [Android Studio]
author: joseph-chege
excerpt_separator: <!--more-->
images:

  - url: /complete-guide-to-making-api-calls-in-android-using-retrofit/hero.png
    alt: A Complete Guide to Making API Calls in Android using Retrofit
---

Modern applications allow us to get connected to the world like never before. However, how is this structure so effective in providing a robust connection between different applications and data sharing between different devices? API (Application Programming Interface) allows developers to build complex features and expose application functionalities as resources.
<!--more-->

The purpose of an API is to communicate between the client and the server using HTTP protocols. This includes the processes of data transfers, data security, and distributions to different networks and third-party applications.

As an android developer, you want that perfect architecture that will allow your users to get connected to data sources using APIs. You can use many libraries to facilitate communication between your android application and an external server(API). One library that stands out for API HTTP communication is Retrofit.

In this article, you will build an android app using Retrofit.

### Prerequisites

To continue with this article, it is helpful to have the following:

- [Node.js](https://nodejs.org/en/) installed on your computer.
- [Postman](https://www.postman.com/downloads/) installed on your computer.
- The latest version [Android Studio](https://developer.android.com/studio) is installed on your computer.
- Prior experience working with Android Studio and Java.

### What is Retrofit

[Retrofit](https://square.github.io/retrofit/) is a type-safe HTTP client for Android. Retrofit helps you consume HTTP RESTful web APIs using Java. It offers methods and simpler syntax to make and call API requests.

### What is Strapi

[Strapi is an open-source headless CMS based on Node.js](https://strapi.io/). It lets you develop and manage any content of your application. This allows you to build backend API faster with efficiency and customizability advantages.

Strapi allows you to run your servers as headless CMS. This allows you to manage your backend content and customize any content to your liking. You get the power and flexibility to choose, while the presentation channel best fits your content model. Strapi then generates REST API endpoints that you can use with any frontend of your choice.

### Setting up a Strapi Backend

We can have any API ready using the Strapi CMS with a few steps. Using Strapi we will model simple Tasks data using Strapi CMS. Let's dive in and create a Strapi server locally. Navigate o where you want Strapi to live on your computer and run the following command. We will create this application using Strapi CLI (Command Line Interface) installation script to get Strapi running locally as follows:

```bash
###npm
npx create-strapi-app@latest strapi-android-backend

###yarn
yarn create strapi-app strapi-android-backend
```

Once you run the above command, select **Quickstart (recommended)**. This will create a `strapi-android-backend` folder containing Strapi ready-to-run scripts. Once the installation is done, Strapi will be launched on your default browser. Alternatively, you can change the directory to `strapi-android-backend`.

```bash
cd strapi-android-backend
```

Then run the following command to start the Strapi backend:

```bash
###npm
npm run develop

###yarn
yarn develop
```

Finally, navigate to `http://localhost:1337/admin`. Using either of the above methods, a Strapi Dashboard will be launched on your browser.

![Making API Calls in Android using Retrofit](/complete-guide-to-making-api-calls-in-android-using-retrofit/strapi.png)

Go ahead and provide the registration credentials to access the Dashboard workspace panel and start managing the content using Strapi.

![Making API Calls in Android using Retrofit](/complete-guide-to-making-api-calls-in-android-using-retrofit/dashboard.png)

Note: The above quickstart selection will create a Strapi backend using SQLite as the default database. If you want to use a different database architecture, you can still do that using Strapi. Strapi supports major databases such as MongoDB, MySQL, PostgreSQL, and MariaDB. To set Strapi with the database of your choice, ensure you select **Custom (manual settings)**, which will allow you to choose your preferred database.

### Modeling data using Strapi

Once Strapi is up and running, you only need to add the data models you consume using your Android studio. Here we are using a Task use case. Therefore, let's dive in and implement the task blueprint.

First, navigate to the **Content-Type Builder** section and **Create new collection type**.

![Making API Calls in Android using Retrofit](/complete-guide-to-making-api-calls-in-android-using-retrofit/content-type.png)

Proceed and provide the Configurations for your task collection as follows.

![Making API Calls in Android using Retrofit](/complete-guide-to-making-api-calls-in-android-using-retrofit/collection.png)

Strapi will use this naming to generate the API routes and database tables/collections.

Click **Continue** and add the necessary field for your collection type.

![A Complete Guide to Making API Calls in Android using Retrofit](/complete-guide-to-making-api-calls-in-android-using-retrofit/add-fields.png)

In this example, we will use three fields:

- A title for each task.
- A description field explaining the task in detail.
- A done Boolean value to track completed tasks

Go ahead and select Text and the field title as follows:

![A Complete Guide to Making API Calls in Android using Retrofit](/complete-guide-to-making-api-calls-in-android-using-retrofit/title.png)

Click **Add another field** and add the description of type Text.

Click **Add another field** and select a type of Boolean. And the name **done** to the new Boolean field.

![A Complete Guide to Making API Calls in Android using Retrofit](/complete-guide-to-making-api-calls-in-android-using-retrofit/done.png)

Each item will have a default false value when adding a new task. On the above screen, navigate to **ADVANCED SETTINGS** and add false as the Default value as follows:

![A Complete Guide to Making API Calls in Android using Retrofit](/complete-guide-to-making-api-calls-in-android-using-retrofit/done-value.png)

Click **Finish** and finally **Save** to build the above data architecture of your backend content. Below is how your structure should look like:

![A Complete Guide to Making API Calls in Android using Retrofit](/complete-guide-to-making-api-calls-in-android-using-retrofit/fields.png)

### Adding data to your Backend

Now that the collection is set. Let's add a few sample data to the Tasks collection.

Navigate to the **Content Manager** section and click **Create new entry** on your tasks **COLLECTION TYPE**.

![A Complete Guide to Making API Calls in Android using Retrofit](/complete-guide-to-making-api-calls-in-android-using-retrofit/content-manage.png)

Create a new entry as follows:

![Making API Calls in Android using Retrofit](/complete-guide-to-making-api-calls-in-android-using-retrofit/new-entry.png)

Click **Save** to add the entry to the draft list and finally, click **Publish** to make the entry accessible outside Strapi.

Using the above method as an example, add a couple of Tasks entries to your Strapi CMS backend. You should have a list of tasks as such:

![Making API Calls in Android using Retrofit](/complete-guide-to-making-api-calls-in-android-using-retrofit/entries.png)

### Creating the API Access Token

Now, to access the data, we need to allow access from the Strapi workspace. Therefore, go ahead and generate an API access token as follows:

Navigate to the **Setting** section and select API tokens.

![Making API Calls in Android using Retrofit](/complete-guide-to-making-api-calls-in-android-using-retrofit/token.png)

Click **Create new API Token** and set a new token as follows:

![Making API Calls in Android using Retrofit](/complete-guide-to-making-api-calls-in-android-using-retrofit/create-token.png)

Finally, click **Save**. This will generate an API token allowing you to access your backend securely.

![Making API Calls in Android using Retrofit](/complete-guide-to-making-api-calls-in-android-using-retrofit/generated-token.png)

Ensure to copy this token. You won’t be able to see it again once you navigate outside this page for security reasons.

Finally, navigate to **Settings** → **Roles** and set the role of **Public** Permissions as follows:

!Making API Calls in Android using Retrofit](/complete-guide-to-making-api-calls-in-android-using-retrofit/permissions.png)

Note: each permission displays a Bound route to the backend: For example:

- Find - GET `/api/tasks`
- Create - POST `/api/tasks`
- Update - PUT `/api/tasks/:id` where id is the task being updated.
- Delete - DELETE `/api/tasks/:id` where id is the task being deleted.

Here each permission represents an HTTP method and its associated route. We will use these routes for this data.

Click **Save** to add these changes.

Let’s dive and consume this backend in android using the Retrofit library.

### Setting up Android Studio

Go ahead and launch your Android Studio. Create a new project using an Empty Activity. Click Next and set up your application as follows:

![Making API Calls in Android using Retrofit](/complete-guide-to-making-api-calls-in-android-using-retrofit/android.png)

We will build this application using Java. Ensure you select it as such.

Once the application is set, navigate to the `build.gradle` file and add the Retrofit dependencies.

```bash
implementation 'com.squareup.retrofit2:retrofit:2.9.0'
implementation 'com.squareup.retrofit2:converter-gson:2.9.0'
```

Here we are adding:

- Retrofit itself. This allows you to access Retrofit classes through which your API interfaces are turned into callable objects.
- [Gson Converter](https://github.com/google/gson###gson). A library that allows you to convert Java Objects into their JSON representation. It provides `toJson()` and `fromJson()` methods for serialization and deserialization of Java Objects to and from JSON objects that the server can understand.

Note: To get the latest available dependencies, you can always check [Retrofit documentation](https://square.github.io/retrofit/).

We are accessing a server that is outside this project. Therefore, we need internet permissions to access the Strapi backend. Navigate to the `AndroidManifest.xml` file and add the following permission.

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

Strapi is running locally. This means it doesn’t have the [cleartext network traffic](https://android-developers.googleblog.com/2016/04/protecting-against-unintentional.html) for HTTP URLs.

Therefore, on your `application` element of the `AndroidManifest.xml` file, declare it as follows:

```bash
android:usesCleartextTraffic="true"
```

The android is ready to execute the request to the backend and back. Let’s dive and implement the actual Retrofit configuration to this application and consume the task data we created on the Strapi backend.

### Connecting Strapi Backend with Android

Using Retrofit, we will connect the Backend(Strapi) with the Frontend (Android). We will use the Strapi route and the token we generated to connect the two using a retrofit instance.

First, create a new model and name it `Api`.

![Making API Calls in Android using Retrofit](/complete-guide-to-making-api-calls-in-android-using-retrofit/package.png)

Inside this package, create a new Java class file and call it `ApiClient`. Here we will create the HTTP client used for requests and responses.

Inside the create class:

```java
public class ApiClient {
}
```

- Create the add the Retrofit instance, the Strapi URL, and the token we generated as follows:

```java
private static Retrofit retrofit;
private static final String base_url = "http://192.168.100.8:1337/";
private static final String token = "your_strapi_api_token"
```

The server is running locally; therefore, we will use the local host domain that maps to the port `1337` running the Strapi backend. Note: when using android studio, the URL `http://localhost:1337/` won’t work. Use your local IP address instead. To get this IP, run `ipconfig` on your terminal:

![Making API Calls in Android using Retrofit](/complete-guide-to-making-api-calls-in-android-using-retrofit/ipconfig.png)

Copy the IPv4 Address and replace it with the localhost keyword, i.e., `http://192.168.100.8:1337/`.

Also, don't forget to replace the `your_strapi_api_token` token value with the actual token you copied earlier on the Strapi backend.

- Using OkHttpClient, create an Interceptor to execute an Authorization header to execute the token and allow safe access to the backend as follows:

Note: OkHttp dependency shipped with Retrofit dependency

```java
public static final OkHttpClient client = new OkHttpClient.Builder().addInterceptor(new Interceptor() {
   @NonNull
   @Override
   public okhttp3.Response intercept(@NonNull Chain chain) throws IOException {
     Request newRequest = chain.request().newBuilder()
         .addHeader("Authorization", "Bearer " + token)
         .build();
     return chain.proceed(newRequest);
   }
}).build();
```

This will observe requests from the server and the corresponding responses coming back into the server.

- Create a `ApiConnection()` singleton HTTP client to execute Retrofit.

```java
public static Retrofit ApiConnection(){
   if (retrofit == null){
     retrofit = new Retrofit.Builder()
       .baseUrl(base_url)
       .client(client)
       .addConverterFactory(GsonConverterFactory.create())
       .build();
   }
   return retrofit;
}
```

Ensure you pass the `base_url` here. Also, execute the `client Interceptor` to execute the Authorization headers.

### Creating Models

We created a model that represents the Task data on the Strapi Backend. Now, we need to represent the same model to the android studio to process these data from the server. First, we need to understand the structure of the data we have. This will allow you to perfectly serialize and deserialize the data based on its object representation.

To do so, send a simple GET request to `http://localhost:1337/api/tasks` using Postman as follows:

![A Complete Guide to Making API Calls in Android using Retrofit](/complete-guide-to-making-api-calls-in-android-using-retrofit/postman.png)

To display these data to android, we will process the response given back by the server. Each task has a response as repressed in the above Postman test.

Here is the HTTP response body that you should always expect from the API whenever you send a GET request

```JSON
{
   "data": [
     {
       "id": 1,
       "attributes": {
         "title": "Create a Strapi Backend",
         "description": "Build a task Api using the Strapi backend as the headless cms",
         "done": false,
         "createdAt": "2022-10-04T15:12:07.989Z",
         "updatedAt": "2022-10-04T15:12:42.658Z",
         "publishedAt": "2022-10-04T15:12:42.653Z"
       }
     }
   [
}
```

The response is represented using a nested JSON object. We need to parse this structure to android. From these data, we have an object array of `data`. We have two objects, the `id` and `attributes`. Inside `attributes`, we have a nested object of title, description, done, etc.

We need to parse them into android to get the nested JSON objects. To comfortably create the correct model for the above-nested object, always start creating the models from the innermost objects.

Therefore, the first model will contain the attributes nested object of title, description, done, etc. Create a new package and name it `model`.

![A Complete Guide to Making API Calls in Android using Retrofit](/complete-guide-to-making-api-calls-in-android-using-retrofit/package.png)

Inside this package, create a new Java file `Attributes` and create a model to get the attributes nested object as follows:

```java
public class Attributes {

   @SerializedName("title")
   @Expose
   private String title;

   @SerializedName("description")
   @Expose
   private String description;

   @SerializedName("done")
   @Expose
   private Boolean done;

   public Attributes(String title, String description, Boolean done) {
     this.title = title;
     this.description = description;
     this.done = done;
   }

   public boolean isDone() {
     return done;
   }

   public String getTitle() {
     return title;
   }

   public String getDescription() {
     return description;
   }
}
```

The next object represents the `id` and attributes of the nested object. Go ahead and create a new Java class `Tasks` inside the model package and add the following:

```java
public class Tasks {

   @SerializedName("id")
   private int id;

   @SerializedName("attributes")
   private Attributes attributes;

   public Tasks(int id, Attributes attributes) {
     this.id = id;
     this.attributes = attributes;
   }

   public int getId() {
     return id;
   }
   public Attributes getAttribute() {
     return attributes;
   }
}
```

This `Tasks` model represents the id values and the objects associated with the `Attributes` model we created above.

Finally, create a model to parse the object array of `data`. Inside the model package, create a new Java file `DataResponse`. This will represent an array list of `data` from the `Tasks` created above as follows:

```java
public class DataResponse {

   @SerializedName("data")
   @Expose
   private List<Tasks> data = null;

   public List<Tasks> getData() {
     return data;
   }
}
```

Up to this point, we have the model needed to serialize objects and parse them to android. Now we need a model to deserialization the Java Objects to a JSON object that the server can understand. This will help us send new data (POST) to the server.

Typically, if you send the data using Postman, the following is the request body you send to add a new Task:

```json
{
   "data": {
     "title": "This is title",
     "description": "This is description"
   }
}
```

We need to represent the above body using android. Replicate this request body to make a POST request using Retrofit using Android. Go ahead and create a `DataRequest` Java class inside the model folder as follows:

```java
public class DataRequest {

   @SerializedName("data")
   Attributes attributes;

   public DataRequest(String title, String description, Boolean done) {

     this.attributes = new Attributes(title,description,done);
   }
}
```

### Create Retrofit Interface

To process these models to the backend server, let's add the API endpoints to Android.

Under the `Api` package, create a new Java class and name it `ApiService`. Make sure you create this class as an interface.

![A Complete Guide to Making API Calls in Android using Retrofit](/complete-guide-to-making-api-calls-in-android-using-retrofit/interface.png)

Here we will execute HTTP built-in methods such as GET, PUT, POST, and DELETE using Retrofit @GET, @POST, @PUT, and @DELETE annotations. Each method will have a bound path/route to execute the operation on the backend and map the route to the `base_url` created in the Retrofit client.

Go ahead and add the following interface to the `ApiService` file as follows:

```java
public interface ApiService {

   @GET("api/tasks")
   Call<DataResponse> getTasks(
   );

   @POST("api/tasks")
   Call<DataRequest> createTask(
       @Body DataRequest dataRequest
   );

   @PUT("api/tasks/{id}")
   Call<DataRequest> updateTask(
       @Path("id") int id,
       @Body DataRequest dataRequest
   );

   @DELETE("api/tasks/{id}")
   Call<DataRequest> deleteTask(
       @Path("id") int id
   );
}
```

Note that each method executes based on the Data models we created. For example, to get Tasks from the server, `DataResponse`. This model has the response from the server that gets the array list of the Tasks from the response Object.

To add a task (POST), pass the `DataRequest` as the request body. This way, a request is sent to add a new task containing the right body that the server understands.

Updating a task involves sending new update data to the server. Hence, ensure the `@Body` is set to send the appropriate request to the server.

Methods such as PUT(update) and DELETE execute the `@Path` parameter that defines the id of the specific task that such operations are being executed.

### Setting the Application UI

To display these data to an android app. Let's first build some UI elements. To show data, we will use android RecyclerView and map each item to the screen using RecyclerView Adapter.

First, navigate to the `layout` folder and create a new XML file. Name it `task_list.xml`. Here we will create the view that we will use to display a single task as follows:

```xml
<?xml version="1.0" encoding="utf-8"?>
<androidx.cardview.widget.CardView
   xmlns:android="http://schemas.android.com/apk/res/android"
   xmlns:tools="http://schemas.android.com/tools"
   xmlns:app="http://schemas.android.com/apk/res-auto"
   android:layout_width="match_parent"
   android:layout_height="wrap_content"
   android:layout_margin="4dp"
   android:id="@+id/card"
   app:contentPadding="8dp"
   app:cardCornerRadius="8dp"
   app:cardElevation="4dp">

   <androidx.constraintlayout.widget.ConstraintLayout
     android:layout_width="match_parent"
     android:layout_height="100dp"
     android:layout_margin="4dp"
     android:orientation="vertical">

     <TextView
       android:id="@+id/title"
       android:layout_width="wrap_content"
       android:layout_height="wrap_content"
       android:textSize="20sp"
       android:textStyle="bold"
       app:layout_constraintStart_toStartOf="parent"
       app:layout_constraintTop_toTopOf="parent"
       tools:text="Title" />

     <TextView
       android:id="@+id/description"
       android:layout_width="wrap_content"
       android:layout_height="wrap_content"
       android:layout_marginTop="12dp"
       android:textStyle="italic"
       app:layout_constraintStart_toStartOf="parent"
       app:layout_constraintTop_toBottomOf="@id/title"
       tools:text="Description" />

     <TextView
       android:id="@+id/done"
       android:layout_width="wrap_content"
       android:layout_height="wrap_content"
       android:layout_marginEnd="4dp"
       android:text="COMPLETED"
       android:visibility="gone"
       app:layout_constraintEnd_toEndOf="parent"
       app:layout_constraintTop_toBottomOf="@+id/description" />
   </androidx.constraintlayout.widget.ConstraintLayout>
</androidx.cardview.widget.CardView>
```

![A Complete Guide to Making API Calls in Android using Retrofit](/complete-guide-to-making-api-calls-in-android-using-retrofit/task-layout.png)

Basically, each task will be displayed in a CardView. Here a card will have three TextViews, the title, description, and done. Note that TextView for displaying the done value has its visibility set as `"gone"`. This means this value won't be displayed in the View. The value of done is a Boolean value. Therefore, when a Task is Done, we will update the done value from the default false to true and make the TextView visible to indicate a COMPLETED task.

The above layout only displays a single task. However, we have a list of multiple tasks. Here we will set a RecyclerView that will basically "Recycle" the above layout for each available task. Navigate to the `layout` folder and update the `activity_main.xml` file as follows:

```xml
<?xml version="1.0" encoding="utf-8"?>
<androidx.coordinatorlayout.widget.CoordinatorLayout xmlns:android="http://schemas.android.com/apk/res/android"
   xmlns:app="http://schemas.android.com/apk/res-auto"
   xmlns:tools="http://schemas.android.com/tools"
   android:layout_width="match_parent"
   android:layout_height="match_parent"
   tools:context=".MainActivity">

   <androidx.recyclerview.widget.RecyclerView
     android:id="@+id/recyclerview"
     android:layout_width="match_parent"
     android:layout_height="match_parent"
     app:layoutManager="androidx.recyclerview.widget.LinearLayoutManager"
     tools:listitem="@layout/task_list" />

   <com.google.android.material.floatingactionbutton.FloatingActionButton
     android:id="@+id/fab"
     android:layout_width="wrap_content"
     android:layout_height="wrap_content"
     android:layout_gravity="bottom|end"
     android:layout_marginEnd="16dp"
     android:layout_marginBottom="16dp"
     android:elevation="12dp"
     android:foregroundGravity="center"
     android:src="@drawable/ic_baseline_add_24"
     app:backgroundTint="###14D18F"
     app:fabSize="normal"
     tools:ignore="ImageContrastCheck"/>
</androidx.coordinatorlayout.widget.CoordinatorLayout>
```

![A Complete Guide to Making API Calls in Android using Retrofit](/complete-guide-to-making-api-calls-in-android-using-retrofit/RecyclerView-layout.png)

The above RecyclerView represents a list of tasks that will be displayed here. Also, note we have added a `floatingactionbutton` to the layout. We will use the button to invoke the activity to add new Task items to the backend server we created.

Remember to create a new vector asset in your drawable folder for `ic_baseline_add_24` used in the above `FloatingActionButton`.

Finally, we need a layout to input new data. We will execute this operation on a different activity. Therefore, go ahead and create a new Empty activity. Call it `CreateTask`.

![A Complete Guide to Making API Calls in Android using Retrofit](/complete-guide-to-making-api-calls-in-android-using-retrofit/create-new-activity.png)

This will create a file inside the layout `directory`. Go ahead and add the following `EditText` views and an Add Button to this file as follows:

```xml
<?xml version="1.0" encoding="utf-8"?>
   <LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
     xmlns:app="http://schemas.android.com/apk/res-auto"
     xmlns:tools="http://schemas.android.com/tools"
     android:layout_width="match_parent"
     android:layout_height="match_parent"
     android:orientation="vertical"
     android:padding="16dp"
     tools:context=".CreateTask">

     <TextView
       android:layout_width="wrap_content"
       android:layout_height="wrap_content"
       android:layout_marginTop="16dp"
       android:text="Add New a Task"
       android:textSize="22sp"
       android:textStyle="bold"
       android:layout_gravity="center"
       android:layout_marginBottom="32dp" />

     <com.google.android.material.textfield.TextInputLayout
       android:id="@+id/title"
       android:layout_width="match_parent"
       android:layout_marginBottom="8dp"
       android:layout_height="wrap_content">
       <EditText
         android:id="@+id/enter_title"
         android:layout_width="match_parent"
         android:layout_height="wrap_content"
         android:inputType="textCapWords"
         android:hint="Enter Title"/>
     </com.google.android.material.textfield.TextInputLayout>
     <com.google.android.material.textfield.TextInputLayout
       android:id="@+id/description"
       android:layout_width="match_parent"
       android:layout_height="wrap_content"
       android:layout_marginTop="16dp"
       android:layout_marginBottom="8dp">
       <EditText
         android:id="@+id/enter_description"
         android:layout_width="match_parent"
         android:layout_height="wrap_content"
         android:maxLines="2"
         android:inputType="text"
         android:hint="Enter Description" />
     </com.google.android.material.textfield.TextInputLayout>

   <Button
     android:id="@+id/add"
     android:layout_width="184dp"
     android:layout_marginTop="16dp"
     android:layout_height="wrap_content"
     android:layout_gravity="center"
     android:text="Add Task" />
</LinearLayout>
```

![A Complete Guide to Making API Calls in Android using Retrofit](/complete-guide-to-making-api-calls-in-android-using-retrofit/create-task-layout.png)

Excellent work! We now have the needed layouts ready. Let's now dive in and create the actual log of handling the logic of data handling from Strapi to android and vice versa using Retrofit.

### Creating the application Adapter

To display the data, we need to create an Adapter that will map the data to the RecyclerView. Go ahead and create a new Java file and call it `TasksAdapter`.

```java
public class TasksAdapter {
}
```

This class will extend to a RecyclerView Adapter as follows:

```java
public class TasksAdapter extends RecyclerView.Adapter<TasksAdapter.MyViewHolder>{
   
}
```

Now go ahead and implement the necessary methods:

![A Complete Guide to Making API Calls in Android using Retrofit](/complete-guide-to-making-api-calls-in-android-using-retrofit/adapter-methods.png)

```java
public class TasksAdapter extends RecyclerView.Adapter<TasksAdapter.MyViewHolder>{

   @NonNull
   @Override
   public TasksAdapter.MyViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
     return null;
   }

   @Override
   public void onBindViewHolder(@NonNull TasksAdapter.MyViewHolder holder, int position) {

   }

   @Override
   public int getItemCount() {
     return 0;
   }
}
```

Right below the `TasksAdapter` adapter, define the following values and a constructor TasksAdapter for the Adapter context and the data we want to process.

```java
Context context;
ApiService apiService;
List<Tasks> tasksList;
String stringTitle;
String stringDes;

public TasksAdapter(Context context, List<Tasks> tasksList) {
   this.tasksList = tasksList;
   this.context = context;
}
```

Inside the `onCreateViewHolder`, we will load the `task_list.xml` layout.

```java
@NonNull
@Override
public MyViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {

   View view;
   LayoutInflater layoutInflater = LayoutInflater.from(context);
   view = layoutInflater.inflate(R.layout.task_list,parent, false);
   return new MyViewHolder(view);
}
```

Create `MyViewHolder` that extends to the RecyclerView ViewHolder as follows.

```java
public static class MyViewHolder extends RecyclerView.ViewHolder{

   TextView title;
   TextView description;
   TextView isdone;
   CardView card;

   public MyViewHolder(@NonNull View itemView) {
     super(itemView);
     title = itemView.findViewById(R.id.title);
     description = itemView.findViewById(R.id.description);
     isdone = itemView.findViewById(R.id.done);
     card = itemView.findViewById(R.id.card);
   }
}
```

Here, we will load the views from the `task_list.xml` based on their ids. This view represents a single task defined in the `task_list.xml` file.

Update the `getItemCount()` method as follows:

```java

@Override
public int getItemCount() {
   return tasksList.size();
}
```

This will return the size(number) of the available Tasks.

Inside this adapter, we will handle the updating and deleting methods.

To update a Task, create an `update()` as follows:

Here we are passing the value of the task's id to be updated.

```java
private void update(int id){

   apiService = ApiClient.ApiConnection().create(ApiService.class);

   DataRequest data = new DataRequest(stringTitle,stringDes,true);

   Call<DataRequest> call = apiService.updateTask(id, data);
   call.enqueue(new Callback<DataRequest>() {
     @Override
     public void onResponse(@NonNull Call<DataRequest> call, @NonNull Response<DataRequest> response) {
     
       Toast.makeText(context, "Task Updated", Toast.LENGTH_SHORT).show();
     }

     @Override
     public void onFailure(@NonNull Call<DataRequest> call, @NonNull Throwable t) {
       
       Toast.makeText(context, t.getMessage(), Toast.LENGTH_LONG).show();
     }
   });
}
```

Likewise, do the same to delete a Task:

```java
private void delete(int id){

   //Call the interface
   apiService = ApiClient.ApiConnection().create(ApiService.class);
   Call<DataRequest> call = apiService.deleteTask(id);
   call.enqueue(new Callback<DataRequest>() {
     @Override
     public void onResponse(@NonNull Call<DataRequest> call, @NonNull Response<DataRequest> response) {
     
       Toast.makeText(context, "Task Deleted", Toast.LENGTH_SHORT).show();
     }

     @Override
     public void onFailure(@NonNull Call<DataRequest> call, @NonNull Throwable t) {
       
       Toast.makeText(context, t.getMessage(), Toast.LENGTH_LONG).show();
     }
   });
}
```

To map the data to the RecyclerView, head over to the `onBindViewHolder` method and make the following changes.

```java
@SuppressLint("ResourceAsColor")
@Override
public void onBindViewHolder(@NonNull MyViewHolder holder, int position) {

   Tasks item = tasksList.get(position);

   holder.title.setText(item.getAttribute().getTitle());
   holder.description.setText(item.getAttribute().getDescription());

   if(item.getAttribute().()){
     holder.isdone.setVisibility(View.VISIBLE);
     holder.card.setCardBackgroundColor(Color.parseColor("###14D18F"));
   }
}
```

This will get the data and map it to the respective view. For isDone, we are checking if the value is true or false. If the value is true (represented by isDone), set the TextView for this element as visible and change the card background colour of that specific Task.

Still, inside the `onBindViewHolder` method, let's handle the updating and deleting of a task. Here, we will add an `OnClickListener` to each card. When clicked, we will create a dialog with delete and update buttons. When an update button is clicked, the Task will be updated to true to indicate the task is done.

First, add the following string values that will be sent alongside the update parameters inside the `onBindViewHolder`.

```java
stringTitle = item.getAttribute().getTitle();
stringDes = item.getAttribute().getDescription();
```

And `OnClickListener` listener to the card and a dialog as follows:

```java
holder.card.setOnClickListener(new View.OnClickListener() {
   @Override
   public void onClick(View view) {
     
     AlertDialog.Builder builder = new AlertDialog.Builder(context);
     builder.setTitle("Introducing work from Everywhere");
     builder.setMessage("Track your Tasks. What do you want to do with this Task?");
     builder.setCancelable(false);
     builder.setPositiveButton("Done", new DialogInterface.OnClickListener() {
       @Override
       public void onClick(DialogInterface dialog, int which) {
         update(item.getId());
         dialog.dismiss();
         ((MainActivity) context).getAll();
       }
     });

     builder.setNegativeButton("Delete", new DialogInterface.OnClickListener() {
       @Override
       public void onClick(DialogInterface dialog, int which) {
         delete(item.getId());
         dialog.dismiss();
         ((MainActivity) context).getAll();
       }
     });

     builder.setNeutralButton("Cancel", new DialogInterface.OnClickListener() {
       @Override
       public void onClick(DialogInterface dialog, int i){
         dialog.dismiss();
       }
     });
     builder.show();
   }
});
```

Now we are ready to display them to the MainActivity.

### Displaying Tasks from Strapi API on Android

Navigate to `MainActivity` and make some changes to display the Tasks. Inside the `MainActivity` class, add the following values:

```java
ApiService apiService;
List<Tasks> tasksList;
RecyclerView recyclerView;
FloatingActionButton floatingActionButton;
```

Inside `onCreate()`, add the following to inflate the View:

```java
recyclerView = findViewById(R.id.recyclerview);
floatingActionButton = findViewById(R.id.fab);
tasksList = new ArrayList<>();
```

Attach an `OnClickListener` to the `FloatingActionButton` to open the `CreateTask` Activity.

```java
floatingActionButton.setOnClickListener(new View.OnClickListener() {
   @Override
   public void onClick(View v) {
     startActivity(new Intent(MainActivity.this, CreateTask.class));
   }
});
```

Create a `getAll()` to get the Tasks and display them in the RecyclerView Adapter as follows:

```java
public void getAll() {
   //Call the interface
   apiService = ApiClient.ApiConnection().create(ApiService.class);

   Call<DataResponse> call = apiService.getTasks();
   call.enqueue(new Callback<DataResponse>() {
     @Override
     public void onResponse(@NonNull Call<DataResponse> call, @NonNull Response<DataResponse> response) {

       DataResponse dataResponse = response.body();
       assert dataResponse != null;
       tasksList = new ArrayList<>(dataResponse.getData());
       dataView(tasksList);
     }

     @Override
     public void onFailure(@NonNull Call<DataResponse> call, @NonNull Throwable t) {
       Toast.makeText(getApplicationContext(), t.getMessage(), Toast.LENGTH_LONG).show();
     }
   });
}
```

Create a `dataView` method to load the list of tasks to the Adapter.

```java
private void dataView(List<Tasks> tasks) {
   TasksAdapter tasksAdapter = new TasksAdapter(this,tasks);
   recyclerView.setLayoutManager(new LinearLayoutManager(this));
   recyclerView.setAdapter(tasksAdapter);
}
```

Now go ahead and call the `getAll()` method inside `onCreate()`. Likewise, this application involves other operations. Whenever the application Resumes the MainActivity, we want to always call the `getAll()` method. Go ahead and implement an `onResume()` as follows:

```java
@Override
protected void onResume() {
   super.onResume();
   getAll();
}
```

Let’s test the application and see what we have up to this point. Run the application using your android emulator to test. This may not work on your real Device. The server hosting the data is running locally. Thus we can only access the data using the locally created android emulator.

![A Complete Guide to Making API Calls in Android using Retrofit](/complete-guide-to-making-api-calls-in-android-using-retrofit/get-data.png)

You should get the above screen with the list of Tasks we added earlier. When you click each Item/Card, a dialog will be launched as follows:

![A Complete Guide to Making API Calls in Android using Retrofit](/complete-guide-to-making-api-calls-in-android-using-retrofit/dialog.png)

If you click delete, that specific item will be deleted from the server, and the android UI will be updated with the new list of available tasks. The update button will update the task to true. Then change the background colour and set the task as completed.

![A Complete Guide to Making API Calls in Android using Retrofit](/complete-guide-to-making-api-calls-in-android-using-retrofit/update.png)

### Adding Task Data to the Server using Android

If you click `FloatingActionButton`, the CreateTask activity will be launched. Let’s go ahead and implement the log to add a new task inside the CreateTask activity.

Inside the CreateTask activity, add the following variables:

```java
String title, description;
EditText editTextTitle, editTextDes;
Button AddTask;
ApiService apiService;
```

Inside the `onCreate()` method add the following:

```java
editTextTitle = findViewById(R.id.enter_title);
editTextDes = findViewById(R.id.enter_description);
AddTask = findViewById(R.id.add);
```

Add an `OnClickListener` to the button as follows:

```java
AddTask.setOnClickListener(new View.OnClickListener() {
   @Override
   public void onClick(View v) {

     title = editTextTitle.getText().toString();
     description = editTextDes.getText().toString();

     if (title.trim().equals("")){
       editTextDes.setError("Title is required");
     }else if(description.trim().equals("")){
       editTextDes.setError("Description is required");
     }else{
       NewTask(title, description);
     }
   }
});
```

When the text is added to the Input field, we will save the individual to Strings, i.e. title and description.

Here we are also checking the form validation to ensure the form inputs are not empty. If Empty, an error message will be shown. If the input fields are not empty, we will execute a method to add a new Task. This will send a request to the server with the title and description values.

Go ahead and create the `NewTask()` method as follows:

```java
private void NewTask(String title, String description){
   //Call the interface
     
   apiService = ApiClient.ApiConnection().create(ApiService.class);
   // passing data from our text fields to our modal class.
   DataRequest modal = new DataRequest(title,description, false);

   // calling a method to create a post and passing our modal class.
   Call<DataRequest> call = apiService.createTask(modal);
   call.enqueue(new Callback<DataRequest>() {
     @Override
     public void onResponse(@NonNull Call<DataRequest> call, @NonNull Response<DataRequest> response) {
       // this method is called when we get a response from our API.
       
       Toast.makeText(getApplicationContext(), response.message(), Toast.LENGTH_LONG).show();
       
       finish();
     }

     @Override
     public void onFailure(@NonNull Call<DataRequest> call, @NonNull Throwable t) {
       Toast.makeText(getApplicationContext(), t.getMessage(), Toast.LENGTH_LONG).show();
     }
   });
}
```

Re-run the application to test if this is working as expected.

![A Complete Guide to Making API Calls in Android using Retrofit](/complete-guide-to-making-api-calls-in-android-using-retrofit/add-task.png)

Go ahead and fill in new data for a new Task as follows:

![A Complete Guide to Making API Calls in Android using Retrofit](/complete-guide-to-making-api-calls-in-android-using-retrofit/data.png)

Click the Add Task button. The new task will be added and displayed to your application.

![A Complete Guide to Making API Calls in Android using Retrofit](/complete-guide-to-making-api-calls-in-android-using-retrofit/added-data.png)

All these changes should be visible in your Strapi backend application.

![A Complete Guide to Making API Calls in Android using Retrofit](/complete-guide-to-making-api-calls-in-android-using-retrofit/strapi-new-data.png)

### Conclusion

Strapi is a great content manager for your application. It allows you to model data and consume it with a fronted framework of your choice. I hope this Android Strapi tutorial was helpful.

Happy coding!
