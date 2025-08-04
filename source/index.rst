..
   Note: Items in this toctree form the top-level navigation. See `api.rst` for the `autosummary` directive, and for why `api.rst` isn't called directly.

.. toctree::
   :hidden:

   Home Page <self>
   modules.rst
   Install.rst
   Engine.rst
   Process.rst
   Payoff.rst
   Calendar.rst
   Product.rst
   SelfDefinedOption.rst

Welcome to Use MCQuantLib
===========================

MCQuantLib is a derivative of Quantlib, a famous quantitative library of financial engineering. Unlike QuantLib, however, MCQuantLib focuses on Monte Carlo simulation in option pricing. It provides different kinds of Payoffs, Structures, Product models and Calendar Tools.

Why Should I Use MCQuantLib?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

* All handles and quotes in QuantLib make it very difficult to maintain a robust option pricing project. MCQuantLib is designed to **simplify** the whole procedure of pricing, enhance **stability** and provides **user-friendly** API.

* Calendar state is usually global in QuantLib, which will creates huge problems when you have couples of options for revaluation. Updating even one date may be time-consuming and may not render to correct results. MCQuantLib avoids using global date and calendar, suitable for pricing and re-valuating **portfolio of options**.

* QuantLib focuses on continuously observed options, while MCQuantLib focuses on **discretely observed options**. This is a great difference because price of options may be different even if they have the same name in QuantLib and MCQuantLib.

* MCQuantLib is much **faster** than Monte Carlo Engines provided by QuantLib. MCQuantLib is based on numpy and can use multiple CPU cores to simulate paths. Almost every function in MCQuantLib is fine-tuned and optimized for speed. For vanilla option, MCQuantLib can simulate 10^8 paths in 56s, or 10^6 paths in 3.4s, or 10^5 paths in 3s.

Who Can Use MCQuantLib?
^^^^^^^^^^^^^^^^^^^^^^^^^

MCQuantLib is designed to boost Monte Carlo option pricing. It is optimized in speed and scalability. it's recommanded to be used by financial analyst or students in business school. It's especially useful when dealing with analysis of portfolio with multiple kinds of options.

Important Notice
^^^^^^^^^^^^^^^^^^^^

If you are using python on Windows system, to unleash full power of MCQuantLib, you have to run powershell or terminal by **administrator privileges**. Then run your python script by:
::

    python yourScript.py

Running without administrator privileges will force ``joblib`` to fall back into single-process mode and not to really perform multi-process computing.

Install
^^^^^^^^^^^^^

You can install MCQuantLib as follows:
::

   pip install MCQuantLib

Quick Start
^^^^^^^^^^^^^^^
You should always import stochastic process module and monte carlo engine module before any pricing:
::

    from MCQuantLib import Engine, BlackScholes, Heston
    batchSize = 100
    numIteration = 900
    r = 0.03
    q = 0
    v = 0.25
    dayCounter = 252
    mc = Engine(batchSize, numIteration)
    bs = BlackScholes(r, q, v, dayCounter)

To price a vanilla Call Option, use:
::

    from MCQuantLib import VanillaCallOption
    option = VanillaCallOption(
        spot=100,
        observationDay=np.linspace(1, 252, 252),
        strike=100
    )
    option.calculateValue(mc, bs, requestGreek=True)

If you prefer a ``QuantLib Style`` and want to use calendar object:
::

    import pandas as pd
    import QuantLib as ql
    from MCQuantLib import VanillaCall, Calendar
    calendar = Calendar(ql.Japan())
    start = pd.Timestamp(2024, 7, 9)
    observationDate = calendar.makeScheduleByPeriod(start, '1d', 253, True)[1:]
    option = VanillaCall(start, observationDate, strike=100, calendar=calendar)
    option.value(start, 100, mc, bs)

**Notice**: Both ``option.calculateValue`` and ``option.value`` will return the result of computing, and you should print it if you want to see it.

Price a Self-Defined Option
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

It is convient to price your own option with exotic structures with MCQuantLib. 

To do this, you have to inherit from ``InstrumentMC`` and deploy your own ``__init__`` and ``pvLogPath`` function. 

The ``__init__`` must have at least two parameter named as ``spot`` and ``observationDay`` , and must define the attribute ``_simulatedTimeArray`` . Refer to Chapter **Self-Defined Option** for more information. For now, you can write ``__init__`` just as the example showed as follows.

The ``pvLogPath`` function must have two parameter named as ``logPath`` and ``discountFactor`` , and must return a scalar. Make sure you understand the basic of risk-neutral option pricing to write this function.

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
