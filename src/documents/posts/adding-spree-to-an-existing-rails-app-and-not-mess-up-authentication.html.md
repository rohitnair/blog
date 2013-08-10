---
author: admin
comments: true
date: 2012-06-11 01:46:13+00:00
layout: post
slug: adding-spree-to-an-existing-rails-app-and-not-mess-up-authentication
title: Adding Spree to an Existing Rails app (and not mess up authentication)
wordpress_id: 334
categories:
- Tech
tags: ['post']
---

**tl;dr** - Read [Custom authentication (#1512)](https://github.com/spree/spree/pull/1512) on Github and follow the instructions mentioned there

The Problem - You have an existing rails app. You've implemented a user authentication layer for it (this could be using something like Devise) Now, you want your app to have some e-commerce capabilities and decide to use Spree, an excellent and extremely comprehensive open source solution. You follow their instructions, do a spree install etc. and things break (especially authentication). A lot of people have posted this problem on stackoverflow and the Spree mailing list, but no one actually provides a clear solution. 

The current version of Spree expects developers to build their apps around it and not the other way around. It completely takes over authentication, and worse, renames your existing users table to spree_users and completely changes the schema as well. It also takes over your routing, your landing page now points to the Spree landing page, and if you had your own '/admin' page, (this could be via something like rails_admin) that now points to the spree admin page.

Fortunately, there's a branch in active development that aims to rip out the whole spree_auth component and fix the authentication problem. You can follow the entire thread on Github - [Custom authentication (#1512)](https://github.com/spree/spree/pull/1512) In particular, look at [this comment](https://github.com/spree/spree/pull/1512#issuecomment-6002989) and follow the instructions there. Essentially, these changes would make sure that your users table is untouched, and you can tell Spree to just use whatever authentication you already have in your existing rails app. The guide mentioned there lists out all the steps required, but there are a couple of other changes that I had to do. I've listed them [here](https://github.com/spree/spree/pull/1512#issuecomment-6214659).
