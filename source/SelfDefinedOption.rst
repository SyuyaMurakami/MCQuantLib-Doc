Self-Defined Option
======================

.. toctree::
   :maxdepth: 4

Method
^^^^^^^^^

It is convient to price your own option with exotic structures with MCQuantLib. 

To do this, you have to inherit from ``InstrumentMC`` and deploy your own ``__init__`` and ``pvLogPath`` function. 

**__init__**

The ``__init__`` must have at least two parameter named as ``spot`` and ``observationDay`` , and must define the attribute ``_simulatedTimeArray`` . 

``spot`` is the spot price of underlying. It must be given at the initialization time of option instance.

``observationDay`` is a critical parameter, which tells MCQuantLib when is the expiration day and how this option is observed. By default, MCQuantLib will take the last element of ``observationDay`` as expiration day.

``_simulatedTimeArray`` is another critical parameter. The simulated path will have same length with ``_simulatedTimeArray`` . 

**pvLogPath**

The ``pvLogPath`` function must have two parameter named as ``logPath`` and ``discountFactor`` , and must return a scalar. Make sure you understand the basic of risk-neutral option pricing to write this function.

``logPath`` is the log form of underlying price. 

``discountFactor`` is an array to show how the value should be discounted.

Example
^^^^^^^^^^^^

Now let's show an example to price a self-defined option. This option will give you payoff as ``max(pricePath) - min(pricePath)``. If price of the stock goes as high as ``135`` at some time before expiration day, and goes as low as ``87`` at another time. This option will give you ``135 - 87`` at expiration day. Let's call it as MaxMinOption and price it:
::

    import numpy as np
    from numbers import Number
    from MCQuantLib import InstrumentMC
    class MaxMinOption(InstrumentMC):
        def __init__(self, spot: Number, observationDay: np.ndarray):
            self._spot = spot
            self.observationDay = observationDay
            self._simulatedTimeArray = np.append([0], observationDay)

        def pvLogPath(self, logPath: np.ndarray, discountFactor: np.ndarray) -> Number:
            discountFactorTerminal = discountFactor[-1]
            price = np.exp(logPath) * self.spot
            maxPrice = np.max(price, axis=1)
            minPrice = np.min(price, axis=1)
            payoffTerminal = maxPrice - minPrice
            return np.sum(payoffTerminal * discountFactorTerminal) / len(logPath)

Then import necessary module before price it:
::

    from MCQuantLib import Engine, BlackScholes
    batchSize = 100
    numIteration = 900
    r = 0.03
    q = 0
    v = 0.25
    dayCounter = 252
    mc = Engine(batchSize, numIteration)
    bs = BlackScholes(r, q, v, dayCounter)

The last thing is creating an object and price it:
::

    maxMin = MaxMinOption(100, np.array(range(1, 253)))
    maxMin.calculateValue(mc, bs, requestGreek=True)

To see the final results, you should mark the final result and print it. For example, replace the last line of code with:
::

   print(maxMin.calculateValue(mc, bs, requestGreek=True))
