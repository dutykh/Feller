# Feller's diffusion equation
----

Numerical simulation of Feller's diffusion equation using an adaptive Lagrangian scheme with moving grid nodes on semi-infinite domain.

![Feller's diffusion equation](/pics/fellereq.png)

![Trajectory of nodes](/pics/ExpandingTrajSmall.png)

The present Matlab (TM) scripts provides a numerical code to simulate the celebrated Feller diffusion equation, which arises in probabilities, wave turbulence theory, *etc*. The main pecularities of this equation include:
* It is posed on a semi-infinite domain (R^+);
* The diffusion is practically unbounded;
* Due to the retention property, the support of the solution may grow indefinitely.

The numerical scheme is described in the following publication:

* D. Dutykh. *Numerical Simulation of Feller's Diffusion Equation*. Mathematics, 7(11), 1067. https://doi.org/10.3390/math7111067

Basically, we use an adaptive Lagrangian scheme with moving grid nodes. The picture above shows the trajectories of grid nodes in one experiment, where the support of the probability distribution extends towards the positive infinity.

## Authors

* [Denys DUTYKH](http://www.denys-dutykh.com/) ([CNRS](http://www.cnrs.fr/insmi/) - [LAMA](http://lama.univ-savoie.fr/index.php), [Université Savoie Mont Blanc](https://www.univ-smb.fr/), France)
* [Laurent GOSSE](https://sites.google.com/site/laurentgossecnr/) ([CNR](https://www.cnr.it/) - [IAC](http://www.iac.rm.cnr.it/), Italy)

Any questions/comments are welcome!