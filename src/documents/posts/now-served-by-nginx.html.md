---
author: admin
comments: true
date: 2012-01-19 10:10:58+00:00
layout: post
slug: now-served-by-nginx
title: Now served by nginx!
wordpress_id: 200
categories:
- Tech
tags: ['post']
---

A few months back, my blog web server(apache) randomly stopped responding to HTTP requests.(My EC2 instance once stopped responding to pings as well, but that was an entirely different issue) The error log said that apache had hit MaxClients. This was surprising considering that my server/blog gets virtually zero traffic. A quick restart and things seemed to be back to normal. But the issue kept repeating, and I had to come up with a long term fix. I could have spent some time trying to debug the issue, and tinker with apache's default settings (which might not be the best for an EC2 Micro Instance). But I decided to go the easier route and just switched to nginx. I had absolutely no experience of working with nginx, but the term "lightweight" had always been associated with it in my mind, and it seemed to be an ideal choice for the 613MB of memory that an EC2 Micro Instance provides. Read up a bit on setting it up, tried a few things with the configuration and things were up and running in a few minutes. The blog has been fairly stable since and I've hardly noticed any downtime. The memory usage, as expected, is pretty low, and it's noticeably faster as well!
