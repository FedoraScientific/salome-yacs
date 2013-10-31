# Copyright (C) 2013  CEA/DEN, EDF R&D, OPEN CASCADE
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

# Expat detection for Salome
#
#  !! Please read the generic detection procedure in SalomeMacros.cmake !!
#
SALOME_FIND_PACKAGE_AND_DETECT_CONFLICTS(Expat EXPAT_ROOT_DIR 0)
MARK_AS_ADVANCED(EXPAT_LIBRARIES EXPAT_INCLUDE_DIR)
#IF(Expat_FOUND OR EXPAT_FOUND)
#  MESSAGE(STATUS "EXPAT include dir is: ${EXPAT_INCLUDE_DIR}")
#ENDIF()

IF(Expat_FOUND OR EXPAT_FOUND)
  SALOME_ACCUMULATE_HEADERS(EXPAT_INCLUDE_DIR)
  SALOME_ACCUMULATE_ENVIRONMENT(LD_LIBRARY_PATH ${EXPAT_LIBRARIES})
ENDIF()