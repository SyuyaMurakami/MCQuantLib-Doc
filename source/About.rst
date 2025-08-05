About
============

.. toctree::
   :maxdepth: 4

History
^^^^^^^^^^^^

This project started a long time ago. I remember it is the summer of 2020, not long after I started the development of RiskQuantLib. However, RiskQuantLib was published very quickly, while MCQuantLib was delayed until 2025. What a funny thing that things goes so differently.

The reason why it takes such a long time is that my friend Daniel does not think a new Monte Carlo engine would be necessary. When I told he I want to build a new Monte Carlo engine for option pricing, based on python, optimized for speed. He said I must have too much time and don't know how to spend it. He suggested a long vacation rather than a new python library would be my best choice.

He was right. At that time, we all knew almost every big investment bank has their own pricing models, delicate and powerful, well-maintained and stable. Our python-based model shall never be match for those models developed by C++. So if we were going to do it, it would fall into another toy for students majoring in financial engineering, and they may even mock at our design because it is neither creative nor academic at all.

That was why I started the first version and then abandoned it. The second time I picked it up, it was already 3 years later. The first scratch was lost and I must start again. Should it even exist, I don't think I could use it. This was not a long-planned certainty, this was just a flash of inspiration. At that day, I searched many libraries in Github and wanted to find a good toy for Monte Carlo option pricing, I was astonished that I could not even find a good one, not good enough for me. So I decided to build a new one.

Why not? At the very beginning, Steve Jobs was just trying to build a new toy for Geeks like him.

Design
^^^^^^^^^^^^

The first thing came into my mind is that this library must be easy to use, just like ``pandas``, the second thing is that it must be fast. What I want is always the same, which is programmers should use this library because they want to use it, not because they have to use it.

    `A good toy is the toy you want, for no reason, not the toy you have to get, for whatever reason.`

So that is where we are now. MCQauntLib does not provide as many instruments as QuantLib, however, it does provide simple APIs and calculation speed. 

Challenge
^^^^^^^^^^^^^^^^^

Here comes the next question which was posed by Daniel:

    `You want to follow the step of Steve Jobs, I see it, looks like you made something called iPad.`

This was not a compliment, not even close. He never likes iPad, he thinks it is a middle form between laptop and mobile phone, but much more useless than laptop, much more inconvenient than mobile phone.

He was trying to diliver a point, which is MCQuantLib is not as fast as the industrial pricing library, and it is not as academic as QuantLib. It is neither a good tool nor a good toy, it is neither suitable for employee nor students.

Ouch! How bad friend he is. But I have to admit he was right. Fortunately, I am not the one who easily lose hope. I told him if he should know how may iPads has been sold, he would change his mind about iPad.

My point is MCQuantLib is neither the fastest, nor the most academic. However, it achieves a great balance between speed, simplicity and extendability. And maybe that's why someone wants it.

I hope someday MCQuantLib would be as famous as QuantLib, even that is just a glimmer of hope. I know I can't do it by myself, so if you are interested in developing this library, start an issue on Github and join us. Have a good day!






