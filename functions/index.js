const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().functions);

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });


exports.onCreateNotifiactionItem = functions.firestore.document('/notification/${userId}/userNotification/${notificationId}').onCreate(async(snapshot,context) => {
    const userId = context.params.userId;
    const userRef = admin.firestore().doc(`users/${userId}`);
    const doc = await userRef.get();
    const androidToken = doc.data().androidToken;

    if(androidToken){
        sendNotifcation(androidToken,snapshot.data());
    }else {
        console.log("No Token");
    }

    function sendNotifcation(androidToken,notificationItem) {
        let body,title;
            switch(notificationItem.type){
                case"comment":
                title = "comment";
                body = "comment";
                break;
                case"follow":
                title = "follow";
                body = "follow";
                break;
                case"like":
                title = "like";
                body = "like";
                break;
            }
            const message = {
                notification: {title,body},
                token:androidToken,
                data: {recipient: userId}
            };

            const response = await admin.messaging().sendToDevice(androidToken,message);
    }
});