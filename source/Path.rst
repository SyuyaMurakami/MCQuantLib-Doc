Path
============

.. toctree::
   :maxdepth: 4

``Path`` is used to filter the simulated paths. It can also calculate the knock time of any barrier options.

If you are trying to price your own exotic option, which has barrier structure, you may use this class to re-write your ``pvLogPath`` function.

Up Barrier
^^^^^^^^^^^^^^^^^^

To use it, just import it:
::

   from MCQuantLib import UpBarrier
   upBarrierFilter = UpBarrier(barrier=105)

``upBarrierFilter`` is a callable object, after given a path array, it can returns the index of path that knocked the specified barrier. Use it like:
::

   knockIndex = upBarrierFilter(pathArray)

``knockIndex`` is a ``bool`` array, if the path knock the barrier, then its value is ``True``, otherwise it is ``False``.

This class can also accept two other optional arguments, which are ``returnIndex`` and ``returnTime``. 

If ``returnIndex=True`` and ``returnTime=True``, it returns ``(knockTime, knockIndex, notKnockIndex)``.

If ``returnIndex=True`` and ``returnTime=False``, it returns ``knockIndex``.

If ``returnIndex=False`` and ``returnTime=True``, it returns ``(knockTime[knockIndex], path[knockIndex], path[notKnockIndex])``.

If ``returnIndex=False`` and ``returnTime=False``, it returns ``path[knockIndex]``.

By default, MCQuantLib use ``returnIndex=True`` and ``returnTime=False``, which is the same as:
::

   upBarrierFilter = UpBarrier(barrier=105, returnIndex=True, returnTime=False)

DownBarrier
^^^^^^^^^^^^^^^^^^

To use it, just import it:
::

   from MCQuantLib import DownBarrier
   downBarrierFilter = DownBarrier(barrier=85)

``downBarrierFilter`` is a callable object, after given a path array, it can returns the index of path that knocked the specified barrier. Use it like:
::

   knockIndex = downBarrierFilter(pathArray)

Also, it accepts ``returnIndex`` and ``returnTime``. These parameters have the same meaning with those in ``UpBarrier``.
