---
layout: blog
status: publish
published: true
url: /guide-to-creatinge-react-native-splash-screens-using-expo/
title: Guide to Creatinge React Native Splash Screens Using Expo
description: Implement a splash screen on a React Native EXPO application. LIKE A PRO. You will will implement a Splash screen loading the logo of a React Native app.
date: 2023-08-07T01:43:57-04:00
topics: [React Native]
excerpt_separator: <!--more-->
images:
  - url: /guide-to-creatinge-react-native-splash-screens-using-expo/hero.jpg
    alt: Guide to Creatinge React Native Splash Screens Using Expo
---

In this article, you will implement a splash screen on an expo application. A splash screen is the first screen displayed on the mobile application. It is typically non-interactive while the application is loading.

Splash screens display the name or logo of the application. Splash screens can also be used to provide a progress bar or animation to indicate how much of the loading process has been completed. However, we will implement a Splash screen that loads the logo of an application.
<!--more-->

We will use the following:

- [React Native](https://reactnative.dev/) - which is an open-source and React-based framework for creating mobile applications. With React Native, you can write code that can be used and run across both iOS and Android platforms. Using the Splash screen example, you eill be able to add the splash screen for both iOS and Android platforms.
- [Expo](https://docs.expo.dev/) - which is an open-source library that provides tools for quickly getting started with a basic React Native app. Expo provides tools to create apps for Android, iOS, and the web using React without using any native code.
- You can use tools such as Figma to create a splash screen asset. However, here we will use buildicon to highlight a simple splash screen.

### **Prerequisites**

To follow along with this article, it will be essential to have the following tools:

- [Node.js](https://nodejs.org/en/) installed on your computer.
- Prior experience working with JavaScript.

### **Setting up the project**

Create a directory that will host your project locally. Proceed to your created working directory. Go ahead and run the following command to initialize a basic React Native project using Expo:

```bash
npx create-expo-app exposplashscreen
```

This will create an exposplashscreen folder. Once the installation is done, proceed to the newly created directory:

```bash
cd exposplashscreen
```

Run the following command to install the expo-splash-screen library to your project:

```bash
npx expo install expo-splash-screen
```

### **Creating Splash Screen Assets**

We will create an icon as an image asset for our splash screen.

To generate the icon:

- Visit this [link](https://buildicon.netlify.app/). From the right selection card, pick any emoji you want and then customize the background on the left pane.

- Once you download the icon, your image should resemble the one below based on the icon and the background color:

![Guide to Creatinge React Native Splash Screens Using Expo](/guide-to-creatinge-react-native-splash-screens-using-expo/image2.png)

-  Save the image on the assets directory of the project directory.

### **Showing the splash screen**

Navigate to your application `App.js` file and add the following changes:

- Import the necessary React modules as well as the necessary React Native-based modules. Also, import the expo-splash-screen package as follows:

```js
// import the React library properties
import React,{useCallback,useEffect,useState} from 'react';

// import the expo-splash-screen to handle splash screens
import * as SplashScreen from 'expo-splash-screen';

// import components from react-native to style and structure the app
import { StyleSheet, Text, View } from 'react-native';
```

- Keep me splash screen visible:

```bash
SplashScreen.preventAutoHideAsync();
```

Inside `App()`:

- Add a state to check if the application is ready to be viewed:

```js
const [appIsReady,setAppIsReady] = useState(false);
```

-  Define a `useEffect()` for viewing the splash screen for 5 secs:

```js
useEffect(() => {
  async function show_splash_screen() {
    try {
      // our API calls will be here.

      new Promise((resolve) => setTimeout(resolve, 5000)); // wait for 5 secs
    } catch (e) {
      console.warn(e);
    } finally {
      setAppIsReady(true); // application to render.
    }
  }

  show_splash_screen();
});
```

- Define a function to hide the splash screen:

```js
const onLayoutRootView = useCallback(async () => {
  if (appIsReady) {
    // hide the splash screen.

    await SplashScreen.hideAsync();
  }
}, [appIsReady]);
```

- Avoid showing content while the splash screen is showing:

```js
if (!appIsReady) {
  return null;
}
```

-   Define the `onLayout` for `View`:

```js
return (
  <View style={styles.container} onLayout={onLayoutRootView}>
    <Text>Open up App.js to start working on your app!</Text>

    <StatusBar style="auto" />
  </View>
);

```

Open the `app.json` file: On the expo object, define a `splash` as below:

```json
"splash": {
    "image": "./assets/splash.png",
    "resizeMode": "cover",
    "backgroundColor": "#FEF9B0"    
}
```

This will ensure Expo is able to load the asset we have added. At this point, the application is ready. Ensure that the development server is running using the following command:

```bash
npm run start
```

![Guide to Creatinge React Native Splash Screens Using Expo](/guide-to-creatinge-react-native-splash-screens-using-expo/image2.png)

### Adding the splash screen on Android

Apart from the above configuration, on Android, you can customize the splash screen, i.e., you can set various splash images for different device DPIs, i.e., mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi.

To add the configurations, edit the `app.json` file as below:

```json
"android": {
    "splash": {
        "backgroundColor": "#FEF9B0",
        "image": "./assets/splash.png",
        "resizeMode": "cover",
        "mdpi": "path_or_url_to_image",
        "hdpi": "path_or_url_to_image",
        "xhdpi": "path_or_url_to_image",
        "xxhdpi": "path_or_url_to_image",
        "xxxhdpi": "path_or_url_to_image"
    }
}
```

For the above customizations, if an original image has a size of 100 * 100.

The scales will vary as follows:

The scales will vary as follows:

- mdpi: 1:1 => 100 * 100.
- hdpi : 1:1.5 => 150 * 150
- xhdpi : 1:2 => 200 * 200
- xxhdpi : 1:3 => 300 * 300
- xxxhdpi : 1:4 => 400 * 400

The customizations will vary based on your device.

### Adding the splash screen on IOS**

Apart from the general customizations, on IOS, you can add the `tabletImage` setting as follows:


```json
"ios": {
    "splash": {
        "backgroundColor": "#FEF9B0",
        "resizeMode": "cover",
        "image": "./assets/splash.png",
        "tabletImage": "local_or_remote_url"
    },
    // other configurations
}
```

Congratulations on Creatinge React Native Splash Screens Using Expo. Take your Next.js skills to new heights and learn [How to Implement Animations in React Native](https://guruspedia.com/how-to-implement-animations-in-react-native/) like a pro. You will love it.

### Conclusion

You now learned how to creatinge React Native Splash Screens Using Expo. For further understanding of the topic, consider the following references:

-   [Creating Splash Screen Asset vianFigma](https://www.youtube.com/watch?v=QSNkU7v0MPc&t=1s&ab_channel=Expo)
-   [IOS Caching of launch screens](https://docs.expo.dev/guides/splash-screens/#ios-caching)
