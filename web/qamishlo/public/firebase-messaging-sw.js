importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js");

firebase.initializeApp({
    apiKey: "AIzaSyA5ZE9ICOa1ER2RW5_TMKfG0i6GZAC2DYY",
    authDomain: "waar-taxi.firebaseapp.com",
    projectId: "waar-taxi",
    messagingSenderId: "80733184068",
    appId: "1:80733184068:web:19da98e7c5a01c40969c11",
});


const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
    const title = payload.notification?.title || "New Notification";
    const body = payload.notification?.body || "";
    const icon = payload.notification?.icon || "/favicon.ico";

    self.registration.showNotification(title, { body, icon });
});