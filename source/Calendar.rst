Calendar
============

.. toctree::
   :maxdepth: 4

You can use ``Calendar`` object in ``MCQuantLib`` to reform your pricing. It is based on ``QuantLib``. To use it, just import ``QuantLib`` and import ``Calendar`` from ``MCQuantLib``:
::

    import QuantLib as ql
    from MCQuantLib import Calendar

``Calendar`` accepts a ``QuantLib`` calendar instance as its input. You can use any calendar object that ``QuantLib`` provides, such as:
::

    jp = Calendar(ql.Japan())
    uk = Calendar(ql.UnitedKingdom())

Add Holiday
^^^^^^^^^^^^^^^^^

Use ``addHolidays`` to add some holiday so that it can suit your condition. This function accepts a collection of ``pandas.Timestamp``:
::

    jp.addHolidays([pd.Timestamp('20250104'), pd.Timestamp('20250204')])

Trading Days
^^^^^^^^^^^^^^^^

Most useful function of ``Calendar`` instance is ``isTrading``, it returns ``True`` or ``False``, after given a ``pandas.Timestamp``:
::

    jp.isTrading(pd.Timestamp('20250104'))

To generate a trading days list between given start day and end day, use:
::

    jp.tradingDaysBetween(start=pd.Timestamp('20250104'), end=pd.Timestamp('20250204'))

To get the next trading day, or last trading day, or trading day in one month later, or any period later or before, you can use ``offset``, like:
::

    jp.offset(date=pd.Timestamp('20250104'), n=1, period=ql.Days)  # get the next trading day
    jp.offset(date=pd.Timestamp('20250104'), n=3, period=ql.Days)  # get 3 trading days later
    jp.offset(date=pd.Timestamp('20250104'), n=1, period=ql.Months)  # get the trading day after 1 month
    jp.offset(date=pd.Timestamp('20250104'), n=1, period=ql.Years)  # get the trading day after 1 year
    jp.offset(date=pd.Timestamp('20250104'), n=-16, period=ql.Weeks)  # get the trading day before 16 weeks

To calculate how many trading days exist between start day and end day, use:
::

    jp.numTradingDaysBetween(start=pd.Timestamp('20250104'), end=pd.Timestamp('20250204'))

To calculate how many trading days exist between start day and a list of target day, use:
::

    jp.numTradingDaysBetweenGrid(start=pd.Timestamp('20250104'), dateList=[pd.Timestamp('20250204'), pd.Timestamp('20250304')])

Schedule
^^^^^^^^^^^^^^^

To generate a trading day list between start and end day, with a given step, use:
::

    jp.makeSchedule(start=pd.Timestamp('20250104'), end=pd.Timestamp('20250704'), period='3w')

You can use a string to specify period, such as: ``1d``, ``18d``, ``3w``, ``2m``, ``2y``. 

This function also has parameter named ``forwardAdjust`` and ``forwardScale``. If ``forwardAdjust`` is ``True``, then the day will be adjusted to next trading day if it is not a trading day. If ``False``, it will be adjusted to last trading day.

If ``forwardScale`` is ``True``, then the last period of generated list could be shorter than given. If ``False``, then the first period of generated list could be shorter than given

To generate a trading day list given period and number of period, use:
::

    jp.makeScheduleByPeriod(start=pd.Timestamp('20250104'), period='3w', count=5)

It also accepts a bool as parameter named as ``forwardAdjust``, if ``True``, a day will be adjusted into next trading day if it is not a trading day, else it will be adjusted to last trading day.

Self-Defined Calendar
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If you want to define your own calendar, you just need to initialize a ``Calendar`` object with ``ql.NullCalendar()`` and add your own holidays:
::

    import QuantLib as ql
    myCalendar = Calendar(ql.NullCalendar())
    myCalendar.addHolidays([pd.Timestamp('20250104'), pd.Timestamp('20250105')])

It is so crazy that you only rest rwo days in a year, but anyway, you have your own calendar now.



