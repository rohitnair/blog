---
layout: default
title: Real Time Voting App with Node.js, Socket.io and mongoDB
date: 2013-02-05 06:58:48+00:00
tags: ['post']  
---

Tried my hand at building a real time voting app this weekend using Node.js, Socket.io and Mongoose. I had used Node.js and Socket.io before, so I was fairly familiar with them, but this was my first experience with Mongoose (and actually MongoDB as well) Some lessons learnt



	
  * Things move fast in Node.js land. And things break fast as well. There were several instances where some of the code I had written against older versions of Node.js/Express were just not valid anymore. Even the socket.io documentation has different steps for Express v3 and v2. 


	
  * Redis makes things like this trivial to implement. Redis has pubsub baked into it, and you can simply publish events to it that your socket.io code can react to (and push to the browser) Your application code need not even be written in Node.js. You could have a Rails/Django/PHP website and just use Node.js to push out events to the browser, and use Redis pubsub as the intermediate queue. I had already tried Redis (and absolutely *love* it), and I wanted to stick with a Mongo only approach, since this was just for a hackday.


	
  * Mongo has a tailable cursor (the analogy they provide for this is the Unix tail -f command) that seems ideal for use cases like this. However, this works only for capped collections. Capped means that you need to specify the max. size up front, and more importantly, updates and retrieves are done in the order of insertion. I believe you can convert a non-capped collection to a capped collection, but I read about it after I deleted and recreated the one I had. (I didn't have any data, in any case) Not sure about the performance impacts of using a tailable cursor though. You could also skip or read the same data multiple times (cursor goes back to the start when it gets reset I believe).

	
  * Mongoose documentation makes almost no mention of tailable cursors. In fact, I couldn't find many examples of people using tailable cursors to implement a real time app like this. The one example I did find ([mongolab/tractorpush-server](https://github.com/mongolab/tractorpush-server/blob/master/app.js) ) used native Mongo drivers instead of Mongoose, but that was good enough to get me started (it also convinced me that something like this was possible)


	
  * [Mongoose 2.7.x](http://mongoosejs.com/docs/2.7.x/docs/query.html) documentation mentions tailable cursors (for some reason the 3.5.x one does not) Fortunately, the API listed there still seemed to work. This is the code I used to react to insertions into my collection 
```javascript
var Vote = mongoose.model('Vote');
var stream = Vote.find().tailable().stream();
stream.on('data', function(vote) {
    // do stuff like socket.emit
});
```
You can add filters to the find() query as well. 


	
  * socket.io is simply awesome. On that note, Heroku doesn't actually support websockets. You need to configure socket.io to use AJAX long polling instead. Fortunately, this *is* documented [here](https://devcenter.heroku.com/articles/using-socket-io-with-node-js-on-heroku). We found this to be near real-time and a pretty acceptable option.


	
  * Node.js is great for API servers/exposing JSON etc. but for some reason, I had a tough time finding a templating engine that was easy to use. Jade just didn't work, while the other popular ones were all no-logic, no HTML type stuff. I just wanted to write some simple HTML and embed a few dynamic values, goddamnit! I finally went with [Swig](http://paularmstrong.github.com/swig/) which was fairly similar to the stuff I'm used to (i.e, erb/django templates or even PHP for that matter) More importantly, it had clear instructions for use with express, and the instructions actually worked!



Overall, it was a good, learning experience and I eventually got it all to work. However, I don't think Node.js would be my default choice next time if I had to quickly mock up some web pages (it might be for a REST API server) The code is at [rohitnair/sportshackday](https://github.com/rohitnair/sportshackday) if anyone's insterested, although most of it might be useless. 
 
