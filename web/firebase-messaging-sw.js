importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyAzRGMSzkJ85Oa6gxw9PId-DkuRyQOyTh0",
  authDomain: "fluentydz.firebaseapp.com",
  projectId: "fluentydz",
  storageBucket: "fluentydz.firebasestorage.app",
  messagingSenderId: "416381337314",
  appId: "1:416381337314:web:8c7166fe13a5ad5331a8bb"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/icons/Icon-192.png'
  };
  self.registration.showNotification(notificationTitle, notificationOptions);
});
