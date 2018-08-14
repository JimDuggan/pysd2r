"""
Python model "Population.py"
Translated using PySD version 0.9.0
"""
from __future__ import division
import numpy as np
from pysd import utils
import xarray as xr

from pysd.py_backend.functions import cache
from pysd.py_backend import functions

_subscript_dict = {}

_namespace = {
    'TIME': 'time',
    'Time': 'time',
    'time': 'time',
    'Population': 'population',
    'Additions': 'additions',
    'Growth Fraction': 'growth_fraction'
}

__pysd_version__ = "0.9.0"


@cache('step')
def additions():
    """
    Real Name: b'Additions'
    Original Eqn: b'Growth_Fraction*Population'
    Units: b''
    Limits: (None, None)
    Type: component

    b''
    """
    return growth_fraction() * population()


@cache('run')
def growth_fraction():
    """
    Real Name: b'Growth Fraction'
    Original Eqn: b'0.03'
    Units: b''
    Limits: (None, None)
    Type: constant

    b''
    """
    return 0.03


@cache('step')
def population():
    """
    Real Name: b'Population'
    Original Eqn: b'Additions'
    Units: b''
    Limits: (None, None)
    Type: component

    b''
    """
    return integ_population()


integ_population = functions.Integ(lambda: additions(), lambda: 1000)


@cache('run')
def initial_time():
    """
    Real Name: b'INITIAL TIME'
    Original Eqn: b'1'
    Units: b'Months'
    Limits: None
    Type: constant

    b'The initial time for the simulation.'
    """
    return 1


@cache('run')
def final_time():
    """
    Real Name: b'FINAL TIME'
    Original Eqn: b'1'
    Units: b'Months'
    Limits: None
    Type: constant

    b'The final time for the simulation.'
    """
    return 13


@cache('run')
def time_step():
    """
    Real Name: b'TIME STEP'
    Original Eqn: b'1/4'
    Units: b'Months'
    Limits: None
    Type: constant

    b'The time step for the simulation.'
    """
    return 1 / 4


@cache('run')
def saveper():
    """
    Real Name: b'SAVEPER'
    Original Eqn: b'1/4'
    Units: b'Months'
    Limits: None
    Type: constant

    b'The time step for the simulation.'
    """
    return time_step()
