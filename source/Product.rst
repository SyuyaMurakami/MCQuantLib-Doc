Product
============

.. toctree::
   :maxdepth: 4

MCQuantLib provides many options types as default pricing models. This chapter is to show how to use them.

Import
^^^^^^^^^^^^^^^^^

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

Name Convention
^^^^^^^^^^^^^^^^^^^^^

MCQuantLib supports coding by two kinds of style, one is called as ``Academy Style`` and another is called as ``QuantLib Style``. The difference between them is the ``Academy Style`` coding uses array and pure number to represent dates, while ``QuantLib Style`` uses ``calendar`` and ``pandas.Timestamp`` to mark dates.

To use ``Academy Style``, you should import the class with ``Option`` suffix, such as ``VanillaCallOption`` and ``UpOutOption``. To use ``QuantLib Style``, you should import the class without ``Option`` suffix, such as ``VanillaCall`` and ``UpOut``.

Vanilla Call Option
^^^^^^^^^^^^^^^^^^^^^^^

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

Vanilla Put Option
^^^^^^^^^^^^^^^^^^^^^^^

To price a vanilla Put Option, use:
::

    from MCQuantLib import VanillaPutOption
    option = VanillaPutOption(
        spot=100,
        observationDay=np.linspace(1, 252, 252),
        strike=100
    )
    option.calculateValue(mc, bs, requestGreek=True)

If you prefer a ``QuantLib Style`` and want to use calendar object:
::

    import pandas as pd
    import QuantLib as ql
    from MCQuantLib import VanillaPut, Calendar
    calendar = Calendar(ql.Japan())
    start = pd.Timestamp(2024, 7, 9)
    observationDate = calendar.makeScheduleByPeriod(start, '1d', 253, True)[1:]
    option = VanillaPut(start, observationDate, strike=100, calendar=calendar)
    option.value(start, 100, mc, bs)

Barrier Option
^^^^^^^^^^^^^^^^^^^

Barrier Option in MCQuantLib is different with those in QuantLib, even they may have the same name. All Barrier Options in QuantLib are *continuously observed*, while barrier options in MCQuantLib are all *discretely observed*. For knock-out options, discretely observed option usually has higher price than continuously observed ones. For knock-in options, discretely observed option usually has lower price than continuously observed ones.

Up-Out Option
^^^^^^^^^^^^^^^^^^^

To price a vanilla Up-Out Barrier Option, use:
::

    from MCQuantLib import UpOutOption, PlainVanillaPayoff
    option = UpOutOption(
        spot=100,
        barrier=120,
        rebate=0,
        observationDay=np.linspace(1, 252, 252),
        payoff=PlainVanillaPayoff(optionType=1, strike=100)
    )
    option.calculateValue(mc, bs, requestGreek=True)

For time-varying barrier and rebate, pass in an array to *barrier*:
::

    from MCQuantLib import UpOutOption, PlainVanillaPayoff
    optionTimeVaryingBarrier = UpOutOption(
        spot=100,
        barrier=np.linspace(110, 120, 252),
        rebate=np.linspace(0, 3, 252),
        observationDay=np.linspace(1, 252, 252),
        payoff=PlainVanillaPayoff(optionType=1, strike=100)
    )
    optionTimeVaryingBarrier.calculateValue(mc, bs)

If you prefer a ``QuantLib Style`` and want to use calendar object:
::

    import pandas as pd
    import QuantLib as ql
    from MCQuantLib import UpOut, Calendar, PlainVanillaPayoff
    calendar = Calendar(ql.Japan())
    start = pd.Timestamp(2024, 7, 9)
    knockOutObservationDate = calendar.makeScheduleByPeriod(start, '1M', 13, True)[1:]
    option = UpOut(start, 120, 10, knockOutObservationDate, payoff=PlainVanillaPayoff(strike=100, optionType=1),calendar=calendar)
    option.value(start, 100, mc, bs)

Up-In Option
^^^^^^^^^^^^^^^^^^

To price a vanilla Up-In Barrier Option, use:
::

    from MCQuantLib import UpInOption, PlainVanillaPayoff
    option = UpInOption(
        spot=100,
        barrier=120,
        rebate=0,
        observationDay=np.linspace(1, 252, 252),
        payoff=PlainVanillaPayoff(optionType=1,strike=100)
    )
    option.calculateValue(mc, bs, requestGreek=True)

If you prefer a ``QuantLib Style`` and want to use calendar object:
::

    import pandas as pd
    import QuantLib as ql
    from MCQuantLib import UpIn, Calendar, PlainVanillaPayoff
    calendar = Calendar(ql.Japan())
    start = pd.Timestamp(2024, 7, 9)
    knockOutObservationDate = calendar.makeScheduleByPeriod(start, '1M', 13, True)[1:]
    option = UpIn(start, 120, 10, knockOutObservationDate, payoff=-PlainVanillaPayoff(strike=100, optionType=-1),calendar=calendar)
    option.value(start, 100, mc, bs)

Down-Out Option
^^^^^^^^^^^^^^^^^^^^

To price a vanilla Down-Out Barrier Option, use:
::

    from MCQuantLib import DownOutOption, PlainVanillaPayoff
    option = DownOutOption(
        spot=100,
        barrier=80,
        rebate=0,
        observationDay=np.linspace(1, 252, 252),
        payoff=PlainVanillaPayoff(optionType=1, strike=100)
    )
    option.calculateValue(mc, bs, requestGreek=True)

If you prefer a ``QuantLib Style`` and want to use calendar object:
::

    import pandas as pd
    import QuantLib as ql
    from MCQuantLib import DownOut, Calendar, PlainVanillaPayoff
    calendar = Calendar(ql.Japan())
    start = pd.Timestamp(2024, 7, 9)
    knockOutObservationDate = calendar.makeScheduleByPeriod(start, '1M', 13, True)[1:]
    option = DownOut(start, 87, 10, knockOutObservationDate, payoff=PlainVanillaPayoff(strike=100, optionType=-1),calendar=calendar)
    option.value(start, 100, mc, bs)

Down-In Option
^^^^^^^^^^^^^^^^^^^

To price a vanilla Down-In Barrier Option, use:
::

    from MCQuantLib import DownInOption, PlainVanillaPayoff
    option = DownInOption(
        spot=100,
        barrier=80,
        rebate=0,
        observationDay=np.linspace(1, 252, 252),
        payoff=PlainVanillaPayoff(optionType=1, strike=100)
    )
    option.calculateValue(mc, bs, requestGreek=True)

If you prefer a ``QuantLib Style`` and want to use calendar object:
::

    import pandas as pd
    import QuantLib as ql
    from MCQuantLib import DownIn, Calendar, PlainVanillaPayoff
    calendar = Calendar(ql.Japan())
    start = pd.Timestamp(2024, 7, 9)
    knockOutObservationDate = calendar.makeScheduleByPeriod(start, '1M', 13, True)[1:]
    option = DownIn(start, 87, 10, knockOutObservationDate, payoff=-PlainVanillaPayoff(strike=100, optionType=-1),calendar=calendar)
    option.value(start, 100, mc, bs)

Double-Out Option
^^^^^^^^^^^^^^^^^^^^^^

To price a vanilla Double-Out Barrier Option, use:
::

    from MCQuantLib import DoubleOutOption, PlainVanillaPayoff
    option = DoubleOutOption(
        spot=100,
        barrierUp=120,
        barrierDown=80,
        observationDayUp=np.linspace(1, 252, 252),
        observationDayDown=np.linspace(1, 252, 252),
        payoff=PlainVanillaPayoff(optionType=1, strike=100),
        rebateUp=1,
        rebateDown=2
    )
    option.calculateValue(mc, bs, requestGreek=True)

If you prefer a ``QuantLib Style`` and want to use calendar object:
::

    import pandas as pd
    import QuantLib as ql
    from MCQuantLib import DoubleOut, Calendar, PlainVanillaPayoff
    calendar = Calendar(ql.Japan())
    start = pd.Timestamp(2024, 7, 9)
    knockOutObservationDateUp = calendar.makeScheduleByPeriod(start, '1M', 13, True)[1:]
    knockOutObservationDateDown = calendar.makeScheduleByPeriod(start, '2M', 7, True)[1:]
    option = DoubleOut(
        spot=100,
        barrierUp=120,
        barrierDown=80,
        observationDayUp=knockOutObservationDateUp,
        observationDayDown=knockOutObservationDateDown,
        payoff=PlainVanillaPayoff(strike=100, optionType=1),
        rebateUp=3,
        rebateDown=2
    )
    option.value(start, 100, mc, bs)

Double-In Option
^^^^^^^^^^^^^^^^^^^^^

To price a vanilla Double-In Barrier Option, use:
::

    from MCQuantLib import DoubleInOption, PlainVanillaPayoff
    option = DoubleInOption(
        spot=100,
        barrierUp=120,
        barrierDown=80,
        observationDayUp=np.linspace(1, 252, 21),
        observationDayDown=np.linspace(1, 252, 252),
        rebate=2,
        payoff=PlainVanillaPayoff(optionType=1, strike=100)
    )
    option.calculateValue(mc, bs, requestGreek=True)

If you prefer a ``QuantLib Style`` and want to use calendar object:
::

    import pandas as pd
    import QuantLib as ql
    from MCQuantLib import DoubleIn, Calendar, PlainVanillaPayoff
    calendar = Calendar(ql.Japan())
    start = pd.Timestamp(2024, 7, 9)
    knockInObservationDateUp = calendar.makeScheduleByPeriod(start, '1M', 13, True)[1:]
    knockInObservationDateDown = calendar.makeScheduleByPeriod(start, '2M', 7, True)[1:]
    option = DoubleIn(
        spot=100,
        barrierUp=120,
        barrierDown=80,
        observationDayUp=knockInObservationDateUp,
        observationDayDown=knockInObservationDateDown,
        payoff=PlainVanillaPayoff(strike=100, optionType=1),
        rebateUp=3,
        rebateDown=2
    )
    option.value(start, 100, mc, bs)

SnowBall Option
^^^^^^^^^^^^^^^^^^^^

To price a Snow Ball Option, use:
::

    from MCQuantLib import SnowBallOption
    option = SnowBallOption(
        spot=100,
        upperBarrierOut=105,
        lowerBarrierIn=80,
        observationDayIn=np.linspace(1, 252, 252),
        observationDayOut=np.linspace(1, 252, 12),
        rebateOut=np.linspace(1, 15, 12),
        fullCoupon=15
    )
    option.calculateValue(mc, bs, requestGreek=True)

If you prefer a ``QuantLib Style`` and want to use calendar object:
::

    import pandas as pd
    import QuantLib as ql
    from MCQuantLib import SnowBall, PlainVanillaPayoff, Calendar
    calendar = Calendar(ql.Japan())
    start = pd.Timestamp(2024, 7, 9)
    assert calendar.isTrading(start)
    monthlyDates = calendar.makeScheduleByPeriod(start, "1m", 13)[1:]
    shortPut = - PlainVanillaPayoff(optionType=-1, strike=100)
    option = SnowBall(
        startDate=start, initialPrice=100, knockOutBarrier=105,
        knockOutObservationDate=monthlyDates, knockInBarrier=80, knockInObservationDate="daily",
        knockInPayoff=shortPut, knockOutCouponRate=0.15,
        maturityCouponRate=0.15, calendar=calendar
    )
    option.value(pd.Timestamp(2024, 8, 8), 102, False, mc, bs)


