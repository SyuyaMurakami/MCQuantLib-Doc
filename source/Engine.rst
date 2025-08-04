Engine
============

.. toctree::
   :maxdepth: 4

Engine defines how to parallel simulation of Monte Carlo and coordinate between CPU cores and processes. 

Engine class is defined as:
::

   class Engine(batchSize, numIteration, caller=None)

BatchSize and NumIteration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The total number of simulated path is ``batchSize * numIteration`` . If your computer is equipped with large RAM, then a larger ``batchSize`` will be suitable for you. If not, a smaller ``batchSize`` and larger ``numIteration`` will be a good combination.

Caller
^^^^^^^^^^^

caller in a function which decides how to run simulations, especially how to parallel your CPU jobs. It takes at least two arguments which are ``function`` and ``seedList`` , it should return a list. Parameter ``function`` is a function which accepts a random seed and returns the pricing result or what ever you want to calculate. By defalut, MCQuantLib uses ``joblib`` as its multi-processes caller:
::

    def callerJoblib(func: Callable, iterator: Sequence, **kwargs):
        func = delayed(wrap_non_picklable_objects(func))
        with Parallel(**kwargs) as p:
            res = p(func(s) for s in iterator)
        return res

This default caller is roughly equivalent to:
::

    def caller(calcFunc, seedSequence, /, **kwargs):
        calcFunc = joblib.delayed(calcFunc)
        kwargs["n_jobs"] = cpu_counts() if "n_jobs" not in kwargs else kwargs["n_jobs"]
        with joblib.Parallel(**kwargs) as parallel:
            res = parallel(calcFunc(seed) for seed in seedSequence)
        return res

To implement Monte Carlo with your own caller, for example one with no parallel computation, define the caller as follows:
::

    def selfDefinedCaller(calcFunc, seedSequence):
        return [calcFunc(s) for s in seedSequence]

You may also set the default caller so that you do not need to specify ``caller`` every time ``calculate`` is called.
::

    mc.caller = selfDefinedCaller

To revert to the joblib caller, delete the caller or set it to ``None``:
::

    del mc.caller
    mc.caller = None

