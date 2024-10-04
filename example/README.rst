****************
Fortuno examples
****************

Documented examples demonstrating the usage of the Fortuno unit testing framework for various test scenarios.

**Serial unit tests**

- `serial <serial>`_: Unit tests in pure Fortran.

- `serial-fpp <serial-fpp>`_: Unit tests utilizing fpp-style macros (which are natively understood by basically all Fortran compilers). Allows for automatically added file and line information when reporting failure.

- `serial-fypp <serial-fypp>`_: Unit tests utilizing Fypp macros (helpful if your project uses the Fypp-preprocessor). Allows for automatic test registration as well as for automatic file and line information when reporting failure.


**MPI-parallel unit tests**

* ˋmpi <mpi>ˋ_: Unit tests in pure Fortran.

* ˋmpi <mpi-fpp>ˋ_: Unit tests utilizing fpp-style macros (which are natively understood by basically all Fortran compilers). Allows for automatically added file and line information when reporting failure.

* ˋmpi <mpi-fypp>ˋ_: Unit tests utilizing Fypp macros (helpful if your   project uses the Fypp-preprocessor). Allows for automatic test registration as well as for automatic file and line information when reporting failure.

**Coarray-parallel unit tests**

* ˋcoarray <coarray>ˋ_: Unit tests in pure Fortran.

* ˋcoarray <coarray-fpp>ˋ_: Unit tests utilizing fpp-style macros (which are natively understood by basically all Fortran compilers). Allows for automatically added file and line information when reporting failure.

* ˋcoarray <coarray-fypp>ˋ_: Unit tests utilizing Fypp macros (helpful if your project uses the Fypp-preprocessor). Allows for automatic test registration as well as for automatic file and line information when reporting failure.
