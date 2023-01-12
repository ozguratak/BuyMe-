# BuyMe-
BuyMe! is a e-shopping application like e-bay for IOS platforms. You can add a new Item to DB. In this app, I prefer firebase for database. 

For first run the app on your system follow these steps;

1. Clone the branch to your mac. This method will keep the files in an updatable structure.

1.1. You must be sure the cocoapods are already installed on your system. If the cocoapods are not installed yet, you should to be add cocoapods firstly. Other steps are accepted with cocoapods already installed. If you don't know how to add cocoapods to your system you can check this link: https://stackoverflow.com/questions/20755044/how-do-i-install-cocoapods

2. Run the terminal. Do not open the xCode when you before the 7th step.

3. Find the folder where you cloned the files via Finder, find the BuyMe folder without accessing the file contents.

4. Write on the terminal "cd" add space and drag and drop your BuyMe file to your terminal window. Then, press enter.

5. After that, write "pod init" on your terminal then press the enter.

6. When pod initilized, again write "pod install" on your terminal.

7. Now, you can run the xworkspace file but it will not be run on the simulator truely. 

8. If you want to run the app clealry, you must create a new firebase project. In this app I used authentication, firestore and firebase extensions. So that you need an "Google-Info.plist" file which one is adapted to your project on firebase. For creating a new project on firebase you can follow these directions: 

8.1. Creating a new project; https://console.firebase.google.com/

    a. Log in to the Firebase console, then click Add project.
    b. Select your existing Google Cloud project from the dropdown menu, then click Continue.
    c. (Optional) Enable Google Analytics for your project, then follow the prompts to select or create a Google Analytics account.
    d. Click Add Firebase.

8.2. Enable authentication for your Firebase project to use Firestore:

    a. In the Firebase console, click Authentication from the navigation panel.
    b. Go to the Sign-in Method tab.
    c. Enable Email/Password and Google authentication.

8.3. Add Firebase to your app by following the platform-specific guide:
   a. Apple platforms: https://firebase.google.com/docs/ios/setup

9. When you create a new project on firebase, the firebase post you an "Google-Info.plist" file. Download it and copy to your xCode project file with xCode. For copying the file follow these steps:

9.1 Open xworkspace file,
9.2 Find your Google-Info.plist file,
9.3 Drag the Google-Info.plist file on xCode file window which one is located the left side of xCode and drop under the BuyMe files. 

10. You can use your app on the simulator.

10. If you think had a problem about the code you can contact with me. You can find my e-mail adress on ozguratak repo. 
