import os


def test(*args):
    r"""Run all the module tests.

    Equivalent to running ``py.test pymks`` in the base of
    PyMKS. Allows an installed version of PyMKS to be tested.

    Args:
      *args: add arguments to pytest

    To test an installed version of PyMKS use

    .. code-block:: bash

       $ python -c "import pymks; pymks.test()"

    """
    import pytest  # pylint: disable=import-outside-toplevel

    path = os.path.join(os.path.split(__file__)[0])
    pytest.main(args=[path, "--doctest-modules", "-r s"] + list(args))
