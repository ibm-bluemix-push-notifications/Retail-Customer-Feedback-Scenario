Mood-based-push-sample
===========================================

 Mood based push sample is an intuitive example usage of [Bluemix push notification Service](https://console.ng.bluemix.net/docs/services/mobilepush/index.html?pos=2) with the help of [Watson Tone Analyzer Service](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/tone-analyzer.html) , [OpenWhisk](https://developer.ibm.com/open/openwhisk/) and [Cloudant Service](https://cloudant.com/). 


   ![Alt text](Resource/flowchart.png?raw=true "Optional Title")

   [![Alt Demo video]((Resource/video.png?raw=true "Optional Title"))](https://youtu.be/9Qx91S2ZO6I)
   

## Overview
 
The Mood-based-push-sample impliments the core features of the scenario described above. It showcases OpenWhisk, Watson APIs, Cloudant with Bluemix Push Notifications Service and demonstrates mobile integration capabilities. The Feedback app will register a feedback on recent purchased item to the cloudant `complaints` database. The openWhisk will read the changes in the `complaints` and will send the data to Watson Tone Analyzer. The tone analyzer will send back the results to openwhisk , by analyzing the result openWhisk will fetch appropriate message from cloudant `moods` database and constructs a valid message . This message get pushed to `IBM Push Notification Service` and deliver to the mobile device.
 

## Requirements

### Setup Bluemix and Cloudant.

Follow the steps below ,

 1. Create a [Bluemix Application](http://console.ng.bluemix.net). Configure the Bluemix Push Notification service.

 2. Create and Bind a Watson Tone Analyzer Service to your application.

 3. Create a database named Mood in your [Cloudant](https://cloudant.com/). In the `mood` database create a view named `new_view` and design named `moodPick`.

 4. Click on the new design document you created in above step and Edit it with the below lines. You do not have to change the `_id` and `_rev` values.

	```
	 {
	  "_id": "_design/moodPick",
	  "_rev": "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
	  "indexes": {
	    "fields": {
	      "analyzer": "keyword",
	      "index": "function(doc) {index("default", doc._id, {"facet": true});if ((doc.mood) || (doc.mood===0)){index("doc.mood", doc.mood);}if ((doc.message) || (doc.message===0)){index("message", doc.message);}}"
	    }
	  },
	  "views": {
	    "new_view": {
	      "map": "function (doc) { emit(doc.mood,doc.message);}"
	    }
	  },
	  "language": "javascript"
	}
	
    ```

 5. In the above created db we have to add messages for each emotions - `Fear, Sadness, andDisgust, Anger and Joy` (Watson Tone Analyzer outputs). For example,

	```
	{
	  "mood": "Joy",
	  "message": "thank you very much for your valuable feedback. We are extremely happy to here from you. Come back again have a wonderfull shopping experience with us."
	}
	```
6. In your Cloudant create one more database named `complaints`.


## Sending Push Notifications

  The `sendFeedback.js` file will need the following parameters to complete the actions. 

- `appId` - Bluemix app GUID.

- `appSecret` - Bluemix Push Service appSecret.

- `version` - This is the version of the Tone analyzer service .

- `message` - The test value that is passing to the Tone analyzer service as user Input.

- `cloudantUserName` - Your cloudant username. This is for accessing your `mood` database in cloudant.

- `cloudantPassword` - Your cloudant password. This is for accessing your `mood` database in cloudant.

- `appRegion` - Region where your bluemix app is hosted. Eg for US Dallas -`.ng.bluemix.net`.

- `deviceIds` - The deviceId to which the message need to be send. This data will come from the `complaints` database.
- `name` - Name of the customer. This data will come from the `complaints` database.


### Setup the OPenWhisk.

OpenWhisk you have to get the auth from the [Bluemix OpenWhisk](https://new-console.ng.bluemix.net/openwhisk/cli). Setup OpneWhisk CLI and Auth for OpenWhisk.

### Example App.

  The example app have Feedback sending feature. The following setup needed for running the example app.


1. Create an `action` using the following command.

	``` 
	wsk action update  yourActionName sendFeedback.js -p version 'toneAnalyserVersion' -p cloudantUserName '' -p cloudantPassword '' -p appSecret '' -p appId '' -p appRegion '.ng.bluemix.net' 
	```

2. Create a `Trigger`.

	```
	wsk trigger create yourTriggerName --feed /yourNameSpace/CloudantPackage/changes -p dbname complaints -p includeDoc true -p username 'cloudantUsername' -p password 'cloudantPassword' -p host 'cloudantUsername.cloudant.com'
	```
3. Create Rule and join the `yourActionName` and `yourTriggerName`.

	```
	wsk rule create --enable yourRule yourTriggerName yourActionName
	```
4. Enable the activation Poll.

	```
	wsk activation poll
	```
5. Open the Example app in `XCode.app`. Go to the `Info.plist` file and add values for `cloudantPermission` and `cloudantUserName`. 
    
    ![Alt text](images/plist.png?raw=true "Optional Title")

6. Do `carthage update` in the application to add the [Bluemix Push service SDK](https://github.com/ibm-bluemix-mobile-services/bms-clientsdk-swift-push).

7. Run the application and register for push notification and close the app.

8. Reopen the app again, it will ask for Feedback, go to the feedback page send a feed back.

9. You will get push notification as feedback response. 


### License

Copyright 2015-2016 IBM Corporation

Licensed under the [Apache License, Version 2.0 (the "License")](http://www.apache.org/licenses/LICENSE-2.0.html).

Unless required by applicable law or agreed to in writing, software distributed under the license is distributed on an "as is" basis, without warranties or conditions of any kind, either express or implied. See the license for the specific language governing permissions and limitations under the license.










