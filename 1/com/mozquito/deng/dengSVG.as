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
//   SVG Namespace Definitions and Includes
// ===========================================================================================

DENG.$registerNamespace("SVG", "http://www.w3.org/2000/svg", 1.0);

// Ahmet Zorlu's Drawing Method Collection
// http://www.zoode.org
#include "org.zoode/ASLang.as"
#include "org.zoode/MathUtilsGeometries.as"
#include "org.zoode/ZoodeGeometries2DBasics.as"
#include "org.zoode/ZoodeG2DEllipse2D.as"
#include "org.zoode/ZoodeG2DGeneralPath.as"
#include "org.zoode/ZoodeG2DLine2D.as"
#include "org.zoode/ZoodeG2DPolygon2D.as"
#include "org.zoode/ZoodeG2DRectangle2D.as"
#include "org.zoode/ZoodeG2DRoundRectangle2D.as"

// SVG Wrapper Classes
#include "com/mozquito/deng/namespaces/svg/CSVGWnd.as"
#include "com/mozquito/deng/namespaces/svg/CSVGCssProperties.as"
#include "com/mozquito/deng/namespaces/svg/CSVG_CIRCLE.as"
#include "com/mozquito/deng/namespaces/svg/CSVG_ELLIPSE.as"
#include "com/mozquito/deng/namespaces/svg/CSVG_G.as"
#include "com/mozquito/deng/namespaces/svg/CSVG_LINE.as"
#include "com/mozquito/deng/namespaces/svg/CSVG_PATH.as"
#include "com/mozquito/deng/namespaces/svg/CSVG_POLYGON.as"
#include "com/mozquito/deng/namespaces/svg/CSVG_POLYLINE.as"
#include "com/mozquito/deng/namespaces/svg/CSVG_RECT.as"
#include "com/mozquito/deng/namespaces/svg/CSVG_STYLE.as"
#include "com/mozquito/deng/namespaces/svg/CSVG_SVG.as"
#include "com/mozquito/deng/namespaces/svg/CSVG_TEXT.as"

