/*
DENG Modular XBrowser
Copyright (C) 2002-2004 Mozquito

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
*/

// ===========================================================================================
//   XML Events Namespace Definitions and Includes
// ===========================================================================================

DENG.$registerNamespace("Events", "http://www.w3.org/2001/xml-events", 1.0);

DENG.$addDefaultStylesheet("Events", "@namespace 'http://www.w3.org/2001/xml-events';\012"
                                    +"listener {display:none}\012");

#include "com/mozquito/deng/namespaces/events/CEvent.as"
#include "com/mozquito/deng/namespaces/events/CEventsWnd.as"
#include "com/mozquito/deng/namespaces/events/CEventsCssProperties.as"
#include "com/mozquito/deng/namespaces/events/DOM2_XMLNode.as"
#include "com/mozquito/deng/namespaces/events/CEvents_LISTENER.as"
