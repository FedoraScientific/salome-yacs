// Copyright (C) 2006-2014  CEA/DEN, EDF R&D
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.
//
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
//
// See http://www.salome-platform.org/ or email : webmaster.salome@opencascade.com
//

#ifndef __SALOMECONTAINER_HXX__
#define __SALOMECONTAINER_HXX__

#include "YACSRuntimeSALOMEExport.hxx"
#include "Container.hxx"
#include "SalomeContainerTools.hxx"
#include "SalomeContainerHelper.hxx"
#include "Mutex.hxx"
#include <string>
#include <vector>
#include CORBA_CLIENT_HEADER(SALOME_Component)

namespace YACS
{
  namespace ENGINE
  {
    class SalomeComponent;

    class YACSRUNTIMESALOME_EXPORT SalomeContainer : public Container
    {
      friend class SalomeComponent;
    public:
      SalomeContainer();
      SalomeContainer(const SalomeContainer& other);
      //! For thread safety for concurrent load operation on same Container.
      void lock();
      //! For thread safety for concurrent load operation on same Container.
      void unLock();
      bool isAlreadyStarted(const ComponentInstance *inst) const;
      Engines::Container_ptr getContainerPtr(const ComponentInstance *inst) const;
      void start(const ComponentInstance *inst) throw (Exception);
      Container *clone() const;
      Container *cloneAlways() const;
      std::string getPlacementId(const ComponentInstance *inst) const;
      std::string getFullPlacementId(const ComponentInstance *inst) const;
      void checkCapabilityToDealWith(const ComponentInstance *inst) const throw (Exception);
      void setProperty(const std::string& name, const std::string& value);
      std::string getProperty(const std::string& name) const;
      void clearProperties();
      void addComponentName(const std::string& name);
      void addToResourceList(const std::string& name);
      virtual CORBA::Object_ptr loadComponent(ServiceNode *inst);
      void shutdown(int level);
      // Helper methods
      std::map<std::string,std::string> getResourceProperties(const std::string& name) const;
      std::map<std::string,std::string> getProperties() const;
    protected:
#ifndef SWIG
      virtual ~SalomeContainer();
#endif
    protected:
      //! thread safety in Salome ???
      YACS::BASES::Mutex _mutex;
      std::vector<std::string> _componentNames;
      SalomeContainerHelper *_launchModeType;
      int _shutdownLevel;
      SalomeContainerTools _sct;
    };
  }
}

#endif
