"""PFHub - Phase Field Community Hub

See the documentation at https://github.com/usnistgov/pfhub
"""

import os
from . import _version


def test(*args):
    r"""Run all the module tests.

    Equivalent to running ``py.test pfhub`` in the base

    Args:
      *args: add arguments to pytest

    To test an installed version of PFHub use

    .. code-block:: bash

       $ python -c "import pfhub; pfhub.test()"

    """
    import pytest  # pylint: disable=import-outside-toplevel

    path = os.path.join(os.path.split(__file__)[0])
    pytest.main(args=[path, "--doctest-modules", "-r s"] + list(args))


__version__ = _version.get_versions()["version"]
