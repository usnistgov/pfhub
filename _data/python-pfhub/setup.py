#!/usr/bin/env python

"""PFHub - Phase Field Community Hub

"""

from setuptools import setup, find_packages
import versioneer


def setup_args():
    """Get the setup arguments not configured in setup.cfg"""
    return {
        "packages": find_packages(),
        "package_data": {
            "": [
                "tests/*.py",
                "templates/*.mustache",
                "templates/*.yaml",
                "schema/*.yaml",
            ]
        },
        "include_package_data": True,
        "data_files": ["setup.cfg"],
        "version": versioneer.get_version(),
        "cmdclass": versioneer.get_cmdclass(),
    }


setup(**setup_args())
