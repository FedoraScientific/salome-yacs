# Copyright (C) 2007-2013  CEA/DEN, EDF R&D
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
#
# See http://www.salome-platform.org/ or email : webmaster.salome@opencascade.com
#

# ------
MESSAGE(STATUS "Check for sphinx ...")
# ------

IF(SPHINX_IS_MANDATORY STREQUAL 0)
  SET(SPHINX_IS_MANDATORY 0)
  SET(SPHINX_IS_OPTIONAL 1)
ENDIF(SPHINX_IS_MANDATORY STREQUAL 0)
IF(SPHINX_IS_OPTIONAL STREQUAL 0)
  SET(SPHINX_IS_MANDATORY 1)
  SET(SPHINX_IS_OPTIONAL 0)
ENDIF(SPHINX_IS_OPTIONAL STREQUAL 0)
IF(NOT SPHINX_IS_MANDATORY AND NOT SPHINX_IS_OPTIONAL)
  SET(SPHINX_IS_MANDATORY 0)
  SET(SPHINX_IS_OPTIONAL 1)
ENDIF(NOT SPHINX_IS_MANDATORY AND NOT SPHINX_IS_OPTIONAL)

# ------

SET(SPHINX_STATUS 1)
IF(WITHOUT_SPHINX OR WITH_SPHINX STREQUAL 0)
  SET(SPHINX_STATUS 0)
  MESSAGE(STATUS "sphinx disabled from command line.")
ENDIF(WITHOUT_SPHINX OR WITH_SPHINX STREQUAL 0)

# ------

IF(SPHINX_STATUS)
  IF(WITH_SPHINX)
    SET(SPHINX_ROOT_USER ${WITH_SPHINX})
  ENDIF(WITH_SPHINX)
  IF(NOT SPHINX_ROOT_USER)
    SET(SPHINX_ROOT_USER $ENV{SPHINX_ROOT})
  ENDIF(NOT SPHINX_ROOT_USER)
  IF(NOT SPHINX_ROOT_USER)
    SET(SPHINX_ROOT_USER $ENV{SPHINXHOME})
  ENDIF(NOT SPHINX_ROOT_USER)
ENDIF(SPHINX_STATUS)

# ------

IF(SPHINX_STATUS)
  SET(SPHINX_EXECUTABLE_TO_FIND sphinx-build)
  IF(SPHINX_ROOT_USER)
    SET(BINDIR)
    IF(WINDOWS)
  SET(BINDIR ${SPHINX_ROOT_USER}/Scripts)
    ELSE(WINDOWS)
  SET(BINDIR ${SPHINX_ROOT_USER}/bin)
    ENDIF(WINDOWS)
    FIND_PROGRAM(SPHINX_EXECUTABLE ${SPHINX_EXECUTABLE_TO_FIND} PATHS ${BINDIR} NO_DEFAULT_PATH)
  ELSE(SPHINX_ROOT_USER)
    FIND_PROGRAM(SPHINX_EXECUTABLE ${SPHINX_EXECUTABLE_TO_FIND})
  ENDIF(SPHINX_ROOT_USER)
  IF(SPHINX_EXECUTABLE)
    MESSAGE(STATUS "${SPHINX_EXECUTABLE_TO_FIND} found: ${SPHINX_EXECUTABLE}")
  ELSE(SPHINX_EXECUTABLE)
    MESSAGE(STATUS "${SPHINX_EXECUTABLE_TO_FIND} not found, try to use WITH_SPHINX option or SPHINX_ROOT (or SPHINXHOME) environment variable")
    SET(SPHINX_STATUS 0)
  ENDIF(SPHINX_EXECUTABLE)
ENDIF(SPHINX_STATUS)

# ----

IF(SPHINX_STATUS)
  SET(SPHINX_IS_OK 1)
ELSE(SPHINX_STATUS)
  SET(SPHINX_IS_OK 0)
  IF(SPHINX_IS_MANDATORY)
    MESSAGE(FATAL_ERROR "sphinx not found ... mandatory ... abort")
  ELSE(SPHINX_IS_MANDATORY)
    MESSAGE(STATUS "sphinx not found ... optional ... disabled")
  ENDIF(SPHINX_IS_MANDATORY)
ENDIF(SPHINX_STATUS)

# ----
