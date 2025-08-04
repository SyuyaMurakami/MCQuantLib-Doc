Payoff
============

.. toctree::
   :maxdepth: 4

Payoff in MCQuantLib is very like those in QuantLib. The difference is that MCQuantLib use numpy to calculate payoff, which require all functions should be vectorized.

To use payoff, just import them from ``MCQuantLib``, and pass them into instance of ``InstrumentMC`` .

Plain Vanilla Payoff
^^^^^^^^^^^^^^^^^^^^^^^^^

For call option, if ``underlyingPrice > strike``, return ``underlyingPrice - strike``, else return ``0``.

For put option, if ``underlyingPrice < strike``, return ``strike - underlyingPrice``, else return ``0``.

To use it:
::

    from MCQuantLib import PlainVanillaPayoff
    payoff = PlainVanillaPayoff(optionType=1, strike=100)

Constant Payoff
^^^^^^^^^^^^^^^^^^^^^^

Return amount no matter option type or underlyingPrice. To use it:
::

    from MCQuantLib import ConstantPayoff
    payoff = ConstantPayoff(amount=100)

Asset Or Nothing Payoff
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

For call option, if ``underlyingPrice > strike``, return ``underlyingPrice``, else return ``0``.

For put option, if ``underlyingPrice < strike``, return ``underlyingPrice``, else return ``0``.

To use it:
::

    from MCQuantLib import AssetOrNothingPayoff
    payoff = AssetOrNothingPayoff(optionType=1, strike=100)

Cash Or Nothing Payoff
^^^^^^^^^^^^^^^^^^^^^^^^^^^

For call option, if ``underlyingPrice > strike``, return ``cashAmount``, else return ``0``.

For put option, if ``underlyingPrice < strike``, return ``cashAmount``, else return ``0``.

To use it:
::

    from MCQuantLib import CashOrNothingPayoff
    payoff = CashOrNothingPayoff(optionType=1, strike=100, cashAmount=100)

Gap Payoff
^^^^^^^^^^^^^^^^

For call option, if ``underlyingPrice > strike``, return ``underlyingPrice - strikePayoff``, else return ``0``.

For put option, if ``underlyingPrice < strike``, return ``strikePayoff - underlyingPrice``, else return ``0``.

To use is:
::

    from MCQuantLib import GapPayoff
    payoff = GapPayoff(optionType=1, strike=100, strikePayoff=105)

Operation
^^^^^^^^^^^^^^^^

Payoff object can be plused and substracted. It can also be multiplied with a scalar, such as:
::

    payoff_1 = PlainVanillaPayoff(optionType=1, strike=100)
    payoff_2 = ConstantPayoff(amount=100)

    payoff_plus = payoff_1 + payoff_2
    payoff_substract = payoff_1 - payoff_2
    payoff_multiply = payoff_1 * 3.89

Self-Defined Payoff
^^^^^^^^^^^^^^^^^^^^^^^^^

To define your own payoff, you should inherit ``Payoff`` class from MCQuantLib, and then you should deploy your own ``__init__`` function.

Due to ``Payoff`` class is highly abstracted, it could look like a bit of unnecessary to do this, but the first thing you should do is to define a staticmethod of your class, which describes how your payoff works. This function should accepts at least one parameter ``underlyingPrice: Union[np.ndarray, Real]``, which can be a ``1-d array`` or a scalar. Also, this function should return a ``1-d array`` or a scalar.

For example, in plain vanilla payoff definition, we can see:
::

    @staticmethod
    @ValueAsserter(argIndexList=[1], argKeyList=['optionType'], value={1, -1})
    def plainVanillaPayoff(underlyingPrice: Union[np.ndarray, Real], optionType: int, strike: Real) -> Union[np.ndarray, Real]:
        return np.maximum(underlyingPrice - strike, 0) if optionType == 1 else np.maximum(strike - underlyingPrice, 0)

The second thing is to use this function in your ``__init__`` function, like:
::

    def __init__(self, optionType: int, strike: Real) -> None:
        super(PlainVanillaPayoff, self).__init__(PlainVanillaPayoff.plainVanillaPayoff, optionType=optionType, strike=strike)

You should pass your staticmethod function to ``__init__`` of Parent class ``Payoff`` and use it as the first parameter. You should also pass other parameters you need when initialization.







