const functions = require("firebase-functions");

exports.myFunction = functions.firestore
    .document("chat/{message}")
    .onCreate(function(snapshot, context) {
      console.log(snapshot.data());
    });
