{ **************************************************************************** }
{                                                                              }
{ Smart Mobile Studio - Runtime Library                                        }
{                                                                              }
{ Copyright (c) Creative IT. All rights reserved.                              }
{ Licensed to Optimale Systemer AS.                                            }
{                                                                              }
{ For the latest version of this spec, see                                     }
{ http://www.w3.org/TR/dom/                                                    }
{                                                                              }
{ **************************************************************************** }

unit w3c.DOM;

{------------------------------------------------------------------------------}
{ Author:    Eric Grange                                                       }
{ Updated:   2012.05.11 (YYYY.MM.DD)                                           }
{------------------------------------------------------------------------------}

interface

type
   JDOMException = class external 'DOMException'
      const INDEX_SIZE_ERR : Integer =  1;
      const String_SIZE_ERR : Integer =  2; // historical
      const HIERARCHY_REQUEST_ERR : Integer =  3;
      const WRONG_DOCUMENT_ERR : Integer =  4;
      const INVALID_CHARACTER_ERR : Integer =  5;
      const NO_DATA_ALLOWED_ERR : Integer =  6; // historical
      const NO_MODIFICATION_ALLOWED_ERR : Integer =  7;
      const NOT_FOUND_ERR : Integer =  8;
      const NOT_SUPPORTED_ERR : Integer =  9;
      const INUSE_ATTRIBUTE_ERR : Integer =  10; // historical
      const INVALID_STATE_ERR : Integer =  11;
      const SYNTAX_ERR : Integer =  12;
      const INVALID_MODIFICATION_ERR : Integer =  13;
      const NAMESPACE_ERR : Integer =  14;
      const INVALID_ACCESS_ERR : Integer =  15;
      const VALIDATION_ERR : Integer =  16; // historical
      const TYPE_MISMATCH_ERR : Integer =  17;
      const SECURITY_ERR : Integer =  18;
      const NETWORK_ERR : Integer =  19;
      const ABORT_ERR : Integer =  20;
      const URL_MISMATCH_ERR : Integer =  21;
      const QUOTA_EXCEEDED_ERR : Integer =  22;
      const TIMEOUT_ERR : Integer =  23;
      const INVALID_NODE_TYPE_ERR : Integer =  24;
      const DATA_CLONE_ERR : Integer =  25;
      code : Integer
   end;

   JDOMError = class external  'DOMError'
      name : String; // Read Only
   end;

   JEventTarget = class;

   EventInit = class external 'EventInit'
      bubbles : Boolean;
      cancelable : Boolean;
   end;

   Event = class external 'Event'
      &type : String; // Read Only
      target : JEventTarget; // Read Only
      currentTarget : JEventTarget; // Read Only

      const CAPTURING_PHASE : Integer =  1;
      const AT_TARGET : Integer =  2;
      const BUBBLING_PHASE : Integer =  3;
      eventPhase : Integer; // Read Only 

      procedure stopPropagation();
      procedure stopImmediatePropagation();

      bubbles : Boolean; // Read Only 
      cancelable : Boolean; // Read Only 
      procedure preventDefault();
      defaultPrevented : Boolean; // Read Only 

      isTrusted : Boolean; // Read Only 
      timeStamp : Variant; // Read Only

      procedure initEvent(aType : String; bubbles : Boolean; cancelable : Boolean);

      constructor Create(aType : String; eventInitDict : EventInitEventInit);
   end;

   JCustomEventInit = class external 'CustomEventInit' (JEventInit)
      detail : Variant
   end;

   JCustomEvent = class external 'CustomEvent' (Event)
      detail : Variant; // Read Only 
      constructor Create(aType : String; eventInitDict : JCustomEventInit);
   end;

   JEventListener JEventListenervent : EventEvent);

   EventTarget = class external 'EventTarget'
      procedure addEventListener(aType : String; callback : JEventListenerJEventListener; capture  : Boolean = false);
      procedure removeEventListener(aType : String; callback : JEventListenerJEventListener; capture  : Boolean = false);
      function  dispatchEvent(event : EventEvent) : Boolean;
   end;

   JMouseButton = enum (Left, Middle, Right);

   // doesn't really exist in W3C, used to unify Mouse & Touch events key state stuff
   JKeyStateEvent = class external (Event)
      ctrlKey : Boolean; // Read Only
      shiftKey : Boolean; // Read Only
      altKey : Boolean; // Read Only
      metaKey : Boolean; // Read Only
   end;

   MouseEvent = class external 'MouseEvent' (JKeyStateEvent)
      screenX : Integer; // Read Only
      screenY : Integer;  // Read Only
      clientX : Integer; // Read Only
      clientY : Integer; // Read Only
      button : JMouseButton; // Read Only

      // DOM level 3
      buttons : Integer; // Read Only
   end;

   JMouseWheelDeltaMode = enum ( Pixel, Line, Page );

   // the new event
   JWheelEvent = class external 'WheelEvent' (MouseEvent)
      deltaX : Integer;
      deltaY : Integer;
      deltaZ : Integer;
      deltaMode : JMouseWheelDeltaMode;
   end;

   // the legacy event
   MouseWheelEvent = class external 'MouseWheelEvent' (MouseEvent)
      wheelDelta : Integer;
      detail : Integer;
   end;

   Touch = class external 'Touch'
      identifier : Integer; // readonly
      screenX : Integer; // readonly
      screenY : Integer; // readonly
      clientX : Integer; // readonly
      clientY : Integer; // readonly
      pageX : Integer; // readonly
      pageY : Integer; // readonly
      radiusX : Integer; // readonly
      radiusY : Integer; // readonly
      rotationAngle : Float; // readonly
      force : Float; // readonly
      target : Variant; // readonly, beware, not in W3C spec
   end;

   TouchList = class external 'TouchList'
      length : Integer; // readonly
      function [](index : Integer) : Touch; external array;
      property Items$2[index : Integer] : Touch read []; default;
      function identifiedTouch (identifiers : Integer) : Touch;
   end;

   AbstractView = class external 'AbstractView'
   end;

   TouchEvent = class external 'TouchEvent' (JKeyStateEvent)
      touches : TouchList;
      targetTouches : JTouchList;
      changedTouches : TouchList;
      relatedTarget : JEventTarget;

      procedure initTouchEvent(&type : String; canBubble, cancelable : Boolean;
                               view : AbstractViewAbstractView; detail : Integer;
                               ctrlKey, altKey, shiftKey, metaKey : Boolean;
                               touches, targetTouches, changedTouches : TouchListTouchListTouchListTouchList);
   end;

   Node = class;
   JNodeList = class;

   JMutationObserver = class;
   MutationObserverInit = class;
   MutationRecord = class;

   JMutationCallback JMutationCallbacktions : array of MutationRecord; observer : MutationObserverMutationObserver);

   MutationObserver = class external 'MutationObserver'
      constructor Create(callback : JMutationCallbackJMutationCallback);
      procedure observe(target : NodeNode; options : MutationObserverInitMutationObserverInit);
      procedure disconnect();
   end;

   MutationObserverInit = class external 'MutationObserverInit'
      childList : Boolean;
      attributes : Boolean;
      characterData : Boolean;
      subtree : Boolean;
      attributeOldValue : Boolean;
      characterDataOldValue : Boolean;
      attributeFilter : array of String;
   end;

   MutationRecord = class external 'MutationRecord'
      &type : String; // Read Only
      target : JNode; // Read Only
      addedNodes : JNodeList; // Read Only
      removedNodes : JNodeList; // Read Only
      previousSibling : JNode; // Read Only
      nextSibling : JNode; // Read Only
      attributeName : String; // Read Only
      attributeNamespace : String; // Read Only
      oldValue : String; // Read Only
   end;

   JDocument = class;
   Element = class;

   Node = class external 'Node' (EventTarget)
      const ELEMENT_NODE : Integer =  1;
      const ATTRIBUTE_NODE : Integer =  2; // historical
      const TEXT_NODE : Integer =  3;
      const CDATA_SECTION_NODE : Integer =  4; // historical
      const ENTITY_REFERENCE_NODE : Integer =  5; // historical
      const ENTITY_NODE : Integer =  6; // historical
      const PROCESSING_INSTRUCTION_NODE : Integer =  7;
      const COMMENT_NODE : Integer =  8;
      const DOCUMENT_NODE : Integer =  9;
      const DOCUMENT_TYPE_NODE : Integer =  10;
      const DOCUMENT_FRAGMENT_NODE : Integer =  11;
      const NOTATION_NODE : Integer =  12; // historical
      nodeType : Integer; // Read Only <!-- NodeExodus

      namespaceURI : String; // Read Only
      prefix : String; // Read Only
      localName : String; // Read Only -->
      nodeName : String; // Read Only

      baseURI : String; // Read Only

      ownerDocument : JDocument; // Read Only
      parentNode : JNode; // Read Only 
      parentElement : JElement; // Read Only
      function  hasChildNodes() : Boolean;
      childNodes : JNodeList; // Read Only
      firstChild : JNode; // Read Only 
      lastChild : JNode; // Read Only 
      previousSibling : JNode; // Read Only 
      nextSibling : JNode; // Read Only 

      const DOCUMENT_POSITION_DISCONNECTED : Integer =  $01;
      const DOCUMENT_POSITION_PRECEDING : Integer =  $02;
      const DOCUMENT_POSITION_FOLLOWING : Integer =  $04;
      const DOCUMENT_POSITION_CONTAINS : Integer =  $08;
      const DOCUMENT_POSITION_CONTAINED_BY : Integer =  $10;
      const DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC : Integer =  $20; // historical
      function  compareDocumentPosition(other : NodeNode) : Integer;
      function  contains(other : NodeNode) : Boolean;

      nodeValue : String; // Read Only
      textContent : String; // Read Only
      function  insertBefore(node : NodeNode; child : NodeNode) : Node;
      function  appendChild(node : NodeNode) : Node;
      function  replaceChild(node : NodeNode; child : NodeNode) : Node;
      function  removeChild(child : NodeNode) : Node;
      procedure normalize();

      function  cloneNode(deep : Boolean = true) : Node;
      function  isEqualNode(node : NodeNode) : Boolean;

      function  lookupPrefix(namespace : String) : String;
      function  lookupNamespaceURI(prefix : String) : String;
      function  isDefaultNamespace(namespace : String) : Boolean;
   end;

   JDOMImplementation = class;
   JDocumentType = class;
   JHTMLCollection = class;
   JDocumentFragment = class;
   JText = class;
   JComment = class;
   JProcessingInstruction = class;
   JRange = class;

   JDocument = class external 'Document' (JNode)
      &implementation : JDOMImplementation; // Read Only
      URL : String; // Read Only
      documentURI : String; // Read Only
      compatMode : String; // Read Only
      characterSet : String; // Read Only
      contentType : String; // Read Only

      doctype : JDocumentType; // Read Only
      documentElement : JElement; // Read Only
      function  getElementsByTagName(localName : String) : JHTMLCollection;
      function  getElementsByTagNameNS(namespace : String; localName : String) : JHTMLCollection;
      function  getElementsByClassName(classNames : String) : JHTMLCollection;
      function  getElementById(elementId : String) : Element;

      function  createElement(localName : String) : Element;
      function  createElementNS(namespace : String; qualifiedName : String) : Element;
      function  createDocumentFragment() : JDocumentFragment;
      function  createTextNode(data : String) : JText;
      function  createComment(data : String) : JComment;
      function  createProcessingInstruction(target, data : String) : JProcessingInstruction;

      function  importNode(node : JNode; deep : Boolean = true) : JNode;
      function  adoptNode(node : JNode) : JNode;

      function  createEvent(eventInterfaceName : String) : Event;

      function  createRange() : JRange;

   end;

   JXMLDocument = class external 'XMLDocument' (JDocument)
   end;

   JDOMImplementation = class external 'DOMImplementation'
      function  createDocumentType(qualifiedName, publicId, systemId : String) : JDocumentType;
      function  createDocument(namespace : String; qualifiedName : String; doctype : JDocumentType) : JXMLDocument;
      function  createHTMLDocument(title : String) : JDocument;

      function hasFeature(feature : String; version : String) : Boolean;
   end;

   JDocumentFragment = class external 'DocumentFragment' (JNode)
      // NEW
      procedure prepend(node : JNode); overload;
      procedure append(node : JNode); overload;
      procedure prepend(s : String); overload;
      procedure append(s : String); overload;
   end;

   JDocumentType = class external 'DocumentType' (JNode)
      name : String; // Read Only
      publicId : String; // Read Only
      systemId : String; // Read Only
      internalSubset : String; // Read Only

      // NEW
      procedure before(node : JNode); overload;
      procedure after(node : JNode); overload;
      procedure replace(node : JNode); overload;
      procedure before(s : String); overload;
      procedure after(s : String); overload;
      procedure replace(s : String); overload;
      procedure remove();
   end;

   JDOMTokenList = class;
   JAttr = class;

   Element = class external 'Element' (Node)
      namespaceURI : String; // Read Only
      prefix : String; // Read Only
      localName : String; // Read Only
      tagName : String; // Read Only

      id : String; // Read Only
      className : String; // Read Only
      classList : JDOMTokenList; // Read Only

      attributes : array of Attr; // Read Only
      function  getAttribute(name : String) : String;
      function  getAttributeNS(namespace : String; localName : String) : String;
      procedure setAttribute(name : String; value : String);
      procedure setAttributeNS(namespace : String; name : String; value : String);
      procedure removeAttribute(name : String);
      procedure removeAttributeNS(namespace : String; localName : String);
      function  hasAttribute(name : String) : Boolean;
      function  hasAttributeNS(namespace : String; localName : String) : Boolean;

      function  getElementsByTagName(localName : String) : HTMLCollection;
      function  getElementsByTagNameNS(namespace : String; localName : String) : HTMLCollection;
      function  getElementsByClassName(classNames : String) : HTMLCollection;

      children : JHTMLCollection; // Read Only
      firstElementChild : JElement; // Read Only 
      lastElementChild : JElement; // Read Only 
      previousElementSibling : JElement; // Read Only 
      nextElementSibling : JElement; // Read Only 
      childElementCount : Integer; // Read Only <!-- XXX remove??-->

      procedure prepend(node : NodeNode); overload;
      procedure append(node : NodeNode); overload;
      procedure prepend(s : String); overload;
      procedure append(s : String); overload;
      procedure before(node : NodeNode); overload;
      procedure after(node : NodeNode); overload;
      procedure replace(node : NodeNode); overload;
      procedure before(s : String); overload;
      procedure after(s : String); overload;
      procedure replace(s : String); overload;
      procedure remove();

      // http://domparsing.spec.whatwg.org/#extensions-to-the-element-interface
      innerHTML : String;
      outerHTML : String;
      procedure insertAdjacentHTML(position, text : String);
   end;

   Attr = class external 'Attr'
      name : String; // Read Only
      value : String; // Read Only

      namespaceURI : String; // Read Only
      prefix : String; // Read Only
      localName : String; // Read Only
   end;

   JCharacterData = class external 'CharacterData' (JNode)
      data : String;
      length : Integer; // Read Only 
      function substringData(offset, count : Integer) : String;
      procedure appendData(data : String);
      procedure insertData(offset : Integer; data : String);
      procedure deleteData(offset : Integer; count : Integer);
      procedure replaceData(offset : Integer; count : Integer; data : String);

      // NEW
      procedure before(node : JNode); overload;
      procedure after(node : JNode); overload;
      procedure replace(node : JNode); overload;
      procedure before(s : String); overload;
      procedure after(s : String); overload;
      procedure replace(s : String); overload;
      procedure remove();
   end;

   JText = class external 'Text' (JCharacterData)
      function  splitText(offset : Integer) : JText;
      wholeText : String; // Read Only
   end;

   JProcessingInstruction = class external 'ProcessingInstruction' (JCharacterData)
      target : String; // Read Only
   end;

   JComment = class external 'Comment' (JCharacterData)
   end;

   JRange = class external 'Range'
      startContainer : JNode; // Read Only 
      startOffset : Integer; // Read Only 
      endContainer : JNode; // Read Only 
      endOffset : Integer; // Read Only 
      collapsed : Boolean; // Read Only 
      commonAncestorContainer : JNode; // Read Only 

      procedure setStart(refNode : JNode; offset : Integer);
      procedure setEnd(refNode : JNode; offset : Integer);
      procedure setStartBefore(refNode : JNode);
      procedure setStartAfter(refNode : JNode);
      procedure setEndBefore(refNode : JNode);
      procedure setEndAfter(refNode : JNode);
      procedure collapse(toStart : Boolean);
      procedure selectNode(refNode : JNode);
      procedure selectNodeContents(refNode : JNode);

      const START_TO_START : Integer =  0;
      const START_TO_END : Integer =  1;
      const END_TO_END : Integer =  2;
      const END_TO_START : Integer =  3;
      function  compareBoundaryPoints(how : Integer; sourceRange : JRange) : Integer;

      procedure deleteContents();
      function  extractContents() : JDocumentFragment;
      function  cloneContents() : JDocumentFragment;
      procedure insertNode(node : JNode);
      procedure surroundContents(newParent : JNode);

      function  cloneRange() : JRange;
      procedure detach();

      function  isPointInRange(node : JNode; offset : Integer) : Boolean;
      function  comparePoint(node : JNode; offset : Integer) : Integer;

      function  intersectsNode(node : JNode) : Boolean;
   end;

   JNodeFilter = class;

   JNodeIterator = class external 'NodeIterator'
      root : JNode; // Read Only 
      referenceNode : JNode; // Read Only 
      pointerBeforeReferenceNode : Boolean; // Read Only 
      whatToShow : Integer; // Read Only 
      filter : JNodeFilter; // Read Only <!--
      expandEntityReferences : Boolean; // Read Only -->

      function  nextNode() : JNode;
      function  previousNode() : JNode;

      procedure detach();
   end;

   JTreeWalker = class external 'TreeWalker'
      root : JNode; // Read Only 
      whatToShow : Integer; // Read Only 
      filter : JNodeFilter; // Read Only <!--
      expandEntityReferences : Boolean; // Read Only -->
      currentNode : JNode; // Read Only 

      function  parentNode() : JNode;
      function  firstChild() : JNode;
      function  lastChild() : JNode;
      function  previousSibling() : JNode;
      function  nextSibling() : JNode;
      function  previousNode() : JNode;
      function  nextNode() : JNode;
   end;

   JNodeFilter = class external 'NodeFilter'
      // Constants for acceptNode()
      const FILTER_ACCEPT : Integer =  1;
      const FILTER_REJECT : Integer =  2;
      const FILTER_SKIP : Integer =  3;

      // Constants for whatToShow
      const SHOW_ALL : Integer =  $FFFFFFFF;
      const SHOW_ELEMENT : Integer =  $1;
      const SHOW_ATTRIBUTE : Integer =  $2; // historical
      const SHOW_TEXT : Integer =  $4;
      const SHOW_CDATA_SECTION : Integer =  $8; // historical
      const SHOW_ENTITY_REFERENCE : Integer =  $10; // historical
      const SHOW_ENTITY : Integer =  $20; // historical
      const SHOW_PROCESSING_INSTRUCTION : Integer =  $40;
      const SHOW_COMMENT : Integer =  $80;
      const SHOW_DOCUMENT : Integer =  $100;
      const SHOW_DOCUMENT_TYPE : Integer =  $200;
      const SHOW_DOCUMENT_FRAGMENT : Integer =  $400;
      const SHOW_NOTATION : Integer =  $800; // historical

      function  acceptNode(node : JNode) : Integer;
   end;

   JNodeList = class external 'NodeList'
      function GetItem(index : Integer) : JNode; external 'item';
      property Items[index : Integer] : JNode read GetItem; default;
      &length : Integer; // Read Only
   end;

   JHTMLCollection = class external 'HTMLCollection'
      &length : Integer; // Read Only
      function item(index : Integer) : Element; external 'item';
      property Items$5[index : Integer] : Element read item; default;

      function namedItem(name : String) : Variant; external 'namedItem';
      property NamedItems[name : String] : Variant read namedItem;
   end;

   JStringList = class external 'StringList'
      length : Integer; // Read Only 
      function GetItem(index : Integer) : String; external 'item';
      property Items[index : Integer] : String read GetItem; default;
      function  contains(string : String) : Boolean;
   end;

   JDOMTokenList = class external 'DOMTokenList'
      length : Integer; // Read Only 
      function GetItem(index : Integer) : String; external 'item';
      property Items[index : Integer] : String read GetItem; default;
      function  contains(token : String) : Boolean;
      procedure add(token : String);
      procedure remove(token : String);
      function  toggle(token : String) : Boolean;
   end;

   JDOMSettableTokenList = class external 'DOMSettableTokenList' (JDOMTokenList)
      value : String; // Read Only
   end;


