# Copyright (C) 2012-2014  CEA/DEN, EDF R&D
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
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

INCLUDE(${SWIG_USE_FILE})

# --- options ---

IF(WIN32)                                       # if platform is Windows 64 bit 
  IF("${CMAKE_SIZEOF_VOID_P}" EQUAL "8")          
    ADD_DEFINITIONS(/bigobj)                    # to avoid error C1128
  ENDIF()
ENDIF()

# additional include directories
INCLUDE_DIRECTORIES(
  ${PTHREAD_INCLUDE_DIR}
  ${OMNIORB_INCLUDE_DIR}
  ${PYTHON_INCLUDE_DIRS}
  ${PROJECT_BINARY_DIR}/idl
  ${PROJECT_BINARY_DIR}
  ${PROJECT_SOURCE_DIR}/src/bases
  ${PROJECT_SOURCE_DIR}/src/engine
  ${CMAKE_CURRENT_SOURCE_DIR}
  ${CMAKE_CURRENT_BINARY_DIR}
)

# swig flags
SET_SOURCE_FILES_PROPERTIES(pilot.i pypilot.i PROPERTIES 
				    CPLUSPLUS ON 
				    SWIG_DEFINITIONS "-shadow")
SET_PROPERTY(SOURCE pilot.i pypilot.i PROPERTY 
		    SWIG_FLAGS "-noexcept" "-DYACS_PTHREAD")

# additional preprocessor / compiler flags
ADD_DEFINITIONS(
  ${PYTHON_DEFINITIONS}
  ${OMNIORB_DEFINITIONS}
  )

# libraries to link to
SET(_link_LIBRARIES
  YACSlibEngine
  ${PYTHON_LIBRARIES}
  ${OMNIORB_LIBRARIES}
  )

# --- sources ---
SET(pilot_SOURCES
  ExecutorSwig.cxx
  )
# --- headers ---
SET(pilot_HEADERS
  ExecutorSwig.hxx
  )
# --- sources ---
SET(pypilot_SOURCES
  
  )
# --- headers ---
SET(pypilot_HEADERS
  )

# --- scripts ---
# scripts / swig wrappings
SET(_swig_SCRIPTS
  ${CMAKE_CURRENT_BINARY_DIR}/pilot.py
  ${CMAKE_CURRENT_BINARY_DIR}/pypilot.py
)

IF(WIN32)
  SET(SET_CMD set)
  SET(SEP_CMD &&)
ENDIF(WIN32)

IF(SALOME_BUILD_DOC)
  ADD_CUSTOM_TARGET(docengine.i
    ${SET_CMD} DOXSRCDIR=${PROJECT_SOURCE_DIR}/src/engine ${SEP_CMD} ${DOXYGEN_EXECUTABLE} ${PROJECT_SOURCE_DIR}/Misc/Doxyfile
    COMMAND ${PYTHON_EXECUTABLE} ${PROJECT_SOURCE_DIR}/Misc/doxy2swig.py -n xml/index.xml docengine.i
    VERBATIM
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    )
ENDIF(SALOME_BUILD_DOC)

# --- rules ---
SET(ENGINEINCLUDES 
  ../engine/Any.hxx     
  ../engine/DeploymentTree.hxx  
  ../engine/InputDataStreamPort.hxx         
  ../engine/OutPort.hxx               
  ../engine/SharedPtr.hxx 
  ../engine/AnyInputPort.hxx         
  ../engine/Dispatcher.hxx      
  ../engine/InputPort.hxx                   
  ../engine/OutputDataStreamPort.hxx  
  ../engine/StaticDefinedComposedNode.hxx 
  ../engine/Bloc.hxx                 
  ../engine/DynParaLoop.hxx     
  ../engine/InvalidExtractionException.hxx  
  ../engine/OutputPort.hxx            
  ../engine/Switch.hxx 
  ../engine/ComponentInstance.hxx    
  ../engine/ElementaryNode.hxx  
  ../engine/LinkInfo.hxx                    
  ../engine/Pool.hxx                  
  ../engine/Task.hxx 
  ../engine/ComposedNode.hxx         
  ../engine/Executor.hxx        
  ../engine/Logger.hxx                      
  ../engine/Port.hxx                  
  ../engine/TypeCode.hxx 
  ../engine/ConditionInputPort.hxx   
  ../engine/LogRecord.hxx                   
  ../engine/Proc.hxx                  
  ../engine/Visitor.hxx 
  ../engine/Container.hxx            
  ../engine/ForEachLoop.hxx     
  ../engine/Loop.hxx                        
  ../engine/RefCounter.hxx            
  ../engine/VisitorSaveSchema.hxx 
  ../engine/ConversionException.hxx  
  ../engine/ForLoop.hxx         
  ../engine/Node.hxx                        
  ../engine/Runtime.hxx               
  ../engine/VisitorSaveState.hxx 
  ../engine/DataFlowPort.hxx         
  ../engine/InGate.hxx          
  ../engine/OptimizerAlg.hxx                
  ../engine/Scheduler.hxx             
  ../engine/WhileLoop.hxx 
  ../engine/DataPort.hxx             
  ../engine/InlineNode.hxx      
  ../engine/OptimizerLoop.hxx               
  ../engine/ServiceInlineNode.hxx     
  ../engine/ComponentDefinition.hxx 
  ../engine/DataStreamPort.hxx       
  ../engine/InPort.hxx          
  ../engine/OutGate.hxx                     
  ../engine/ServiceNode.hxx           
  ../engine/Catalog.hxx  
  ../engine/PropertyInterface.hxx    
  ../engine/AnyOutputPort.hxx   
  ../engine/Pool.hxx
  ../engine/InPropertyPort.hxx
)
SET(SWIGINCLUDES ${ENGINEINCLUDES} 
		 "${PROJECT_SOURCE_DIR}/src/bases/yacsconfig.h" 
		 "ExecutorSwig.hxx")
SWIG_ADD_MODULE(pilot   python pilot.i ExecutorSwig.cxx)
SWIG_ADD_MODULE(pypilot python pypilot.i)
ADD_CUSTOM_TARGET(_pilot_files DEPENDS pilot.i engtypemaps.i docengine.i ${SWIGINCLUDES})
ADD_CUSTOM_TARGET(_pypilot_files DEPENDS pypilot.i pilot.i engtypemaps.i _pilot ${SWIGINCLUDES})
ADD_DEPENDENCIES(_pilot _pilot_files)
ADD_DEPENDENCIES(_pypilot _pypilot_files)

SWIG_LINK_LIBRARIES(pilot   "${_link_LIBRARIES}")
SWIG_LINK_LIBRARIES(pypilot "${_link_LIBRARIES}")
IF(WIN32)
  SET_TARGET_PROPERTIES(_pilot   PROPERTIES DEBUG_OUTPUT_NAME _pilot_d)
  SET_TARGET_PROPERTIES(_pypilot PROPERTIES DEBUG_OUTPUT_NAME _pypilot_d)
ENDIF(WIN32)

INSTALL(TARGETS ${SWIG_MODULE_pilot_REAL_NAME} ${SWIG_MODULE_pypilot_REAL_NAME} DESTINATION ${SALOME_INSTALL_PYTHON})

SALOME_INSTALL_SCRIPTS("${_swig_SCRIPTS}"  ${SALOME_INSTALL_PYTHON})
