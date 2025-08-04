Process
============

.. toctree::
   :maxdepth: 4

MCQuantLib provides two stochastic process models, which are Black-Scholes and Heston. These models describe market dynamic. You should have basic understanding about what is a stochastic process and how it works before using it to price your option.

Black-Scholes
^^^^^^^^^^^^^^^^^^^^

A Black-Scholes process. A Black-Scholes market has two securities: a risky asset and a risk-free bond.

Dynamics of the asset price is driven by a geometric Brownian motion:

.. math::

    \mathrm{d}S_t=(r-q) S_t\mathrm{d}t + \sigma S_t \mathrm{d}W_t

and the log-return follows:

.. math::

    \mathrm{d}\left(\mathrm{log}{S_t}\right)=
    (r-q-\frac{\sigma^2}{2})\mathrm{d}t+\sigma\mathrm{d}W_t

where the drift (under the risk-neutral measure) is the risk-free rate.

You should set parameters ``r``, ``q``, ``v`` and ``dayCounter`` to use it:
::

    bs = BlackScholes(r=0.03, q=0, v=0.25, dayCounter=252)

Heston
^^^^^^^^^^^^^

A stochastic-volatility model due to Heston (1993).

.. math::
    \begin{align*}
    \mathrm{d}S_t&=(r - q)S_t\mathrm{d}t + \sqrt{v_t} S_t \mathrm{d}W_t \\
    \mathrm{d}v_t&=\kappa(\theta-v_t)\mathrm{d}t +
        \xi \sqrt{v_t} \mathrm{d}Z_t
    \end{align*}

When passing a Heston process into the Monte Carlo engine, products will be valued by discounting the payoff at the risk-free rate.

**Notice** : If you request Greeks using Heston model, the vega will be calculated as: 

.. math::

    vega=\frac{\delta({option\ price})}{\delta({long\ term\ vol\ level})}

You should set parameters ``r``, ``q``, ``rho``, ``theta``, ``kappa``, ``xi``, ``v0default``, ``dayCounter`` to use it:
::

    hst = Heston(r=0.017, q=0, rho=-0.07196, theta=0.0625, kappa=13.3601, xi=1.0394,  v0default=0.08946, dayCounter=252)





