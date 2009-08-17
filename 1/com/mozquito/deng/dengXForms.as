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
//   XHTML Namespace Definitions and Includes
// ===========================================================================================

DENG.$registerNamespace("XForms", "http://www.w3.org/2002/xforms/cr", 1.0);
DENG.$registerNamespace("XForms", "http://www.w3.org/2002/xforms", 1.0);
DENG.$registerNamespace("Deng", "http://claus.packts.net/deng", 1.0);

#include "com/mozquito/deng/xpath/XPath.as"
#include "com/mozquito/deng/namespaces/xforms/CXFormsWnd.as"
#include "com/mozquito/deng/namespaces/xforms/CXFormsElemText.as"
#include "com/mozquito/deng/namespaces/xforms/pseudos/CElemPseudo_BoundText.as"
#include "com/mozquito/deng/namespaces/xforms/pseudos/CElemPseudoValue.as"
#include "com/mozquito/deng/namespaces/xforms/pseudos/CElemPseudoChoices.as"
#include "com/mozquito/deng/namespaces/xforms/CXFormsElemText.as"
#include "com/mozquito/deng/namespaces/xforms/CXFormsControlWnd.as"
#include "com/mozquito/deng/namespaces/xforms/CXFormsItemListWnd.as"
#include "com/mozquito/deng/namespaces/xforms/CXFormsCssProperties.as"
#include "com/mozquito/deng/namespaces/xforms/CXFormsInstanceNode.as"
#include "com/mozquito/deng/namespaces/xforms/IXForms_HostDoc.as"
#include "com/mozquito/deng/namespaces/xforms/CXForms_MODEL.as"
#include "com/mozquito/deng/namespaces/xforms/CXForms_INSTANCE.as"
#include "com/mozquito/deng/namespaces/xforms/CXForms_SUBMISSION.as"
#include "com/mozquito/deng/namespaces/xforms/CXForms_BIND.as"
#include "com/mozquito/deng/namespaces/xforms/CXForms_INPUT.as"
#include "com/mozquito/deng/namespaces/xforms/CXForms_SECRET.as"
#include "com/mozquito/deng/namespaces/xforms/CXForms_GROUP.as"
#include "com/mozquito/deng/namespaces/xforms/CXForms_OUTPUT.as"
#include "com/mozquito/deng/namespaces/xforms/CXForms_LABEL.as"
#include "com/mozquito/deng/namespaces/xforms/CXForms_MESSAGE.as"
#include "com/mozquito/deng/namespaces/xforms/CXForms_TRIGGER.as"
#include "com/mozquito/deng/namespaces/xforms/CXForms_SUBMIT.as"
#include "com/mozquito/deng/namespaces/xforms/CXForms_SEND.as"
#include "com/mozquito/deng/namespaces/xforms/CXForms_REPEAT.as"
#include "com/mozquito/deng/namespaces/xforms/CXForms_SETINDEX.as"
#include "com/mozquito/deng/namespaces/xforms/CXForms_INSERT.as"
#include "com/mozquito/deng/namespaces/xforms/CXForms_DELETE.as"
#include "com/mozquito/deng/namespaces/xforms/CXForms_ACTION.as"
#include "com/mozquito/deng/namespaces/xforms/CXForms_SELECT1.as"
#include "com/mozquito/deng/namespaces/xforms/CXForms_TEXTAREA.as"
#include "com/mozquito/deng/namespaces/xforms/CXForms_ITEM.as"
#include "com/mozquito/deng/namespaces/xforms/CXForms_ITEMSET.as"
#include "com/mozquito/deng/namespaces/xforms/CXForms_VALUE.as"
#include "com/mozquito/deng/namespaces/xforms/CXForms_SETVALUE.as"
#include "com/mozquito/deng/namespaces/xforms/CXForms_LOAD.as"
// extension elements for DENG controls
#include "com/mozquito/deng/namespaces/xforms/deng-controls/CDeng_LOCATION.as"
#include "com/mozquito/deng/namespaces/xforms/deng-controls/CDeng_MEDIATYPE.as"
#include "com/mozquito/deng/namespaces/xforms/deng-controls/CDeng_INCLUDE.as"
#include "com/mozquito/deng/namespaces/xforms/deng-controls/CDeng_FILE.as"
#include "com/mozquito/deng/namespaces/xforms/deng-controls/CDeng_COPY.as"


