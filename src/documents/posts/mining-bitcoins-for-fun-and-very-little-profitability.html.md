---
author: admin
comments: true
date: 2012-02-29 21:39:04+00:00
layout: post
slug: mining-bitcoins-for-fun-and-very-little-profitability
title: Mining Bitcoins for Fun (and very little profitability)
wordpress_id: 205
categories:
- Random
- Tech
tags: ['post']
---

So what do you do with $60 worth of Amazon EC2 credits that expire in a few days? Why yes, you think of ways to waste them! (and give the evil, big corporation the least amount of satisfaction). I _could_ have donated computing resources to Science or even used them for my own research project. But none of that comes close to making a few Bitcoins, in the hope that one day the world's economy will crumble and you'll be a billionaire thanks to this virtual currency. 

I decided to go for the meanest and most expensive EC2 instance type (the cg1.4xlarge Cluster GPU instance that costs $2.10 per hour) Mining bitcoins is compute intensive, and you almost definitely need some GPU power, although it appears that Nvidia GPUs are not best for this particular kind of computation. Next, I created an account on [deepbit](https://deepbit.net/) and followed the instructions mentioned [here](https://bitcointalk.org/index.php?topic=8405.0) to install all the necessary software/libraries. As of now, you might need to do a few things differently. The following additional steps were enough to get things working for me. 

``` bash
# Install source for current package before trying to run the nVidia installers
yum -y install kernel-devel-$(uname -r)
# Download and run latest installer, and point installer to source directory which was installed above
bash devdriver_3.2_linux_64_260.19.26.run --update --kernel-source-path=/usr/src/kernels/2.6.35.14-97.44.amzn1.x86_64
# use updated syntax for poclbm.py
screen -d -m python poclbm.py username:password@deepbit.net:8332 -v -w 256 --device 0
```

And finally, some numbers. I got 28 hours worth of EC2 compute time and an average of around 200 MH/s using the instance. What does that translate to? According to [this](http://bitcoinx.com/profit/index.php) profitability calculator, 200MH/s can earn you around 0.1462 BTC. In 24 hours. In other words, 60$ of EC2 compute power got me less than 0.2 BTC (which is barely worth a glorious $1) Oh well, it was a fun experiment, and IMHO, totally worth it! :D




