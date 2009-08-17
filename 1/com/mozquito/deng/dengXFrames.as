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
//   XFrames Namespace Definitions and Includes
// ===========================================================================================

DENG.$registerNamespace("XFrames", "http://www.w3.org/2002/06/xframes", 1.0);
DENG.$setRenderDelay("XFrames", 0);

// XFrames wrapper classes
#include "com/mozquito/deng/namespaces/xframes/CXFramesCssProperties.as"
#include "com/mozquito/deng/namespaces/xframes/CXFramesWnd.as"
#include "com/mozquito/deng/namespaces/xframes/CXFramesElemText.as"
#include "com/mozquito/deng/namespaces/xframes/CXFrames_GROUP.as"
#include "com/mozquito/deng/namespaces/xframes/CXFrames_FRAME.as"
#include "com/mozquito/deng/namespaces/xframes/CXFrames_FRAMES.as"
#include "com/mozquito/deng/namespaces/xframes/CXFrames_STYLE.as"
#include "com/mozquito/deng/namespaces/xframes/CXFrames_TITLE.as"

