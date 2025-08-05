With RiskQuantLib
=====================

.. toctree::
   :maxdepth: 4

If you have more than one option to price or revaluate, combining RiskQuantLib and MCQuantLib will be a great choice for you.

If you are not familiar with RiskQuantLib, you can refer to `RiskQuantLib Document <https://riskquantlib-doc.readthedocs.io/en/latest/index.html>`_.

Or if you just want to know how to quickly analyse your option portfolio, you can take RiskQuantLib as a project initializer, and take the steps below.

Install RiskQuantLib
^^^^^^^^^^^^^^^^^^^^^^^^

You can install RiskQuantLib with:
::

   pip install RiskQuantLib

Initialize Project
^^^^^^^^^^^^^^^^^^^^^^^^

Then you can start a new project by command in terminal:
::

   newRQL yourProjectPath

If ``yourProjectPath`` does not exist, it will be created. If it already exists, but it is a RiskQuantLib project, it would be over-written.

Declare Instrument
^^^^^^^^^^^^^^^^^^^^

You should see folder ``Src`` under your project path. Open it and create a new file ``pricing.py``, and write the content like:
::

   #-|attribute: option.strike, option.observationDay

   #->option@import
   from MCQuantLib import *

   #->option
   def pricing(self, batchSize, numIteration, r, q, v, dayCounter, spot):
      self.mc = Engine(batchSize, numIteration)
      self.bs = BlackScholes(r, q, v, dayCounter)
      self.option = VanillaCallOption(
          spot=spot,
          observationDay=self.observationDay,
          strike=self.strike
      )
      self.greeks = self.option.calculateValue(self.mc, self.bs, requestGreek=True)

Build Project
^^^^^^^^^^^^^^^^^^^^

Then you should build your project by running:
::

   python build.py

Collect Result
^^^^^^^^^^^^^^^^^^^^^

Open ``main.py`` and write the following code between ``path=...`` and ``print("Write you code...")``:
::

   # reform graph
   import numpy as np
   optionCode = [101, 102, 103]
   optionName = ['A', 'B', 'C']
   optionStrike = [105, 110, 115]
   optionObservation = [np.linspace(1, 252, 252) for _ in range(3)]
   optionPortfolio = optionList()
   optionPortfolio.addOptionSeries(optionCode, optionName)
   optionPortfolio.setStrike(optionCode, optionStrike)
   optionPortfolio.setObservationDay(optionCode, optionObservation)

   # calculate
   optionPortfolio.execFunc('pricing', 100, 10000, 0.02, 0, 0.25, 252, 100)

   # output
   print(optionPortfolio.toDF(['greeks']))

Then run it by:
::

   python main.py

You should be able to see the results if everything goes well.










