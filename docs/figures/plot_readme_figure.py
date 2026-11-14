#!/usr/bin/env python3
# Dr. Denys Dutykh (Mathematics Department, Khalifa University of Science and Technology, Abu Dhabi, UAE)
"""Figure of the README: the run of runFeller.m (confining drift), nodes and probability density.

Run feller_readme_data.m first (MATLAB or GNU Octave), then, from this folder,
    python3 plot_readme_figure.py
which writes feller-confining.png. The style is the stamped copy manuscript_style.py beside it.
"""
import sys
from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
from PIL import Image
from scipy.io import loadmat

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import manuscript_style as hs  # noqa: E402

data = loadmat(HERE / "feller_nodes.mat")
T = data["T"].ravel()
X = data["X"]                         # X[k, i]: position of node i at time T[k]
P = data["P"].ravel()                 # cumulative probability carried by node i
gamma = float(data["g"].ravel()[0])
eta = float(data["e"].ravel()[0])


def density(x):
    """The density as runFeller.m draws it: forward differences of P over the nodes."""
    return np.append(np.diff(P) / np.diff(x), 0.0)


hs.configure(family="libertine")
plt.rcParams["savefig.dpi"] = 265
plt.rcParams["figure.facecolor"] = hs.PAPER
plt.rcParams["savefig.facecolor"] = hs.PAPER

fig, (left, right) = plt.subplots(1, 2, figsize=(hs.WIDTH, 2.7))
for i in range(0, X.shape[1], 4):        # every fourth node, the last one included
    left.plot(X[:, i], T, color=hs.NAVY, lw=0.45)
left.plot(X[:, -1], T, color=hs.NAVY, lw=0.45)
left.set_xlim(0.0, 30.0)
left.set_ylim(0.0, T[-1])
left.set_xlabel(r"$x$")
left.set_ylabel(r"$t$", rotation=0, labelpad=8)
hs.panel(left, "(a) trajectories of every fourth node")

x = np.linspace(0.0, 30.0, 601)
for j, (k, name) in enumerate(((0, r"$t = 0$"), (-1, rf"$t = {T[-1]:g}$"))):
    style = hs.series(j)
    style["marker"] = None
    keep = X[k, :-1] <= 30.0
    right.semilogy(X[k, :-1][keep], density(X[k])[:-1][keep], lw=1.1, label=name, **style)
steady = hs.series(2)
steady["marker"] = None
right.semilogy(x, gamma / eta * np.exp(-gamma * x / eta), lw=1.0,
               label=r"steady state $(\gamma/\eta)\,e^{-\gamma x/\eta}$", **steady)
right.set_xlim(0.0, 30.0)
right.set_ylim(1e-7, 1.0)
right.set_xlabel(r"$x$")
right.set_ylabel(r"$p(x, t)$")
hs.grid(right)
hs.panel(right, "(b) probability density")

hs.legend_outside(fig, where="upper", ncol=3)
out = HERE / "feller-confining.png"
hs.save(fig, out)
Image.open(out).convert("RGB").save(out, optimize=True)
print("written", out)
