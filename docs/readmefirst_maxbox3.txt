****************************************************************
Release Notes maXbox 3.9.9.80 November 2013
****************************************************************
SPS Utils WDOS, Plc BitBus (PetriNet), 40 more units
emax layers: system-package-component-unit-class-function-block
HighPrecision Timers,  Indy Package6, AutoDetect, UltraForms

582 unit uPSI_IdRawBase;
583 unit uPSI_IdNTLM;
584 unit uPSI_IdNNTP;
585 unit uPSI_usniffer; //PortScanForm
586 unit uPSI_IdCoderMIME;
587 unit uPSI_IdCoderUUE;
588 unit uPSI_IdCoderXXE;
589 unit uPSI_IdCoder3to4;
590 unit uPSI_IdCookie;
591 unit uPSI_IdCookieManager;
592 unit uPSI_WDosSocketUtils;
593 unit uPSI_WDosPlcUtils;
594 unit uPSI_WDosPorts;
595 unit uPSI_WDosResolvers;
596 unit uPSI_WDosTimers;
597 unit uPSI_WDosPlcs;
598 unit uPSI_WDosPneumatics;
599 unit uPSI_IdFingerServer;
600 unit uPSI_IdDNSResolver;
601 unit uPSI_IdHTTPWebBrokerBridge;
602 unit uPSI_IdIntercept;
603 unit uPSI_IdIPMCastBase;
604 unit uPSI_IdLogBase;
605 unit uPSI_IdIOHandlerStream;
606 unit uPSI_IdMappedPortUDP;
607 unit uPSI_IdQOTDUDPServer;
608 unit uPSI_IdQOTDUDP;
609 unit uPSI_IdSysLog;
610 unit uPSI_IdSysLogServer;
611 unit uPSI_IdSysLogMessage;
612 unit uPSI_IdTimeServer;
613 unit uPSI_IdTimeUDP;
614 unit uPSI_IdTimeUDPServer;
615 unit uPSI_IdUserAccounts;
616 unit uPSI_TextUtils;
617 unit uPSI_MandelbrotEngine;
618 unit uPSI_delphi_arduino_Unit1;
619 unit uPSI_DTDSchema2;
620 unit uPSI_fplotMain;

SHA1 Win 3.9.9.80: ADEB3B3F764F75D98F6CBD51642320BED4C6B7E2

****************************************************************
Release Notes maXbox 3.9.9.60 November 2013
****************************************************************
Tool Section, SOAP Tester, Hot Log Logger2, TCPPortScan, 39 more Units
BOLD Package, Indy Package5, maTRIx. matheMAX, JSON, CSS

538 unit uPSI_frmExportMain;                   //Synedit
539 unit uPSI_SynDBEdit;
540 unit uPSI_SynEditWildcardSearch;
541 unit uPSI_BoldComUtils;
542 unit uPSI_BoldIsoDateTime;
543 unit uPSI_BoldGUIDUtils; //inCOMUtils
544 unit uPSI_BoldXMLRequests;
545 unit uPSI_BoldStringList;
546 unit uPSI_BoldFileHandler;
547 unit uPSI_BoldContainers;
548 unit uPSI_BoldQueryUserDlg;
549 unit uPSI_BoldWinINet;
550 unit uPSI_BoldQueue;
551 unit uPSI_JvPcx;
552 unit uPSI_IdWhois;
553 unit uPSI_IdWhoIsServer;
554 unit uPSI_IdGopher;
555 unit uPSI_IdDateTimeStamp;
556 unit uPSI_IdDayTimeServer;
557 unit uPSI_IdDayTimeUDP;
558 unit uPSI_IdDayTimeUDPServer;
559 unit uPSI_IdDICTServer;
560 unit uPSI_IdDiscardServer;
561 unit uPSI_IdDiscardUDPServer;
562 unit uPSI_IdMappedFTP;
563 unit uPSI_IdMappedPortTCP;
564 unit uPSI_IdGopherServer;
565 unit uPSI_IdQotdServer;
566 unit uPSI_JvRgbToHtml;
567 unit uPSI_JvRemLog,
568 unit uPSI_JvSysComp;
569 unit uPSI_JvTMTL;
570 unit uPSI_JvWinampAPI;
571 unit uPSI_MSysUtils;
572 unit uPSI_ESBMaths;
573 unit uPSI_ESBMaths2;
574 unit uPSI_uLkJSON;
575 unit uPSI_ZURL;  //Zeos
576 unit uPSI_ZSysUtils;
577 lib unaUtils internals
578 unit uPSI_ZMatchPattern;
579 unit uPSI_ZClasses;
580 unit uPSI_ZCollections;
581 unit uPSI_ZEncoding;

SHA1 Win 3.9.9.60: AB8E0030A965B46047AB34F5A24D5B016E04D7AB
(4371 files)

****************************************************************
Release Notes maXbox 3.9.9.20 October 2013
****************************************************************
RestartDialog, RTF, SQL Scanner, RichEdit, Logger, 16 more Units
fireboX browser kit, maXtex docu kit, maXpaint draw kit

521 unit uPSI_ulambert;
522 unit uPSI_ucholesk;
523 unit uPSI_SimpleDS;
524 unit uPSI_DBXSqlScanner;
525 unit uPSI_DBXMetaDataUtil;
526 unit uPSI_Chart;
527 unit uPSI_TeeProcs;
528 lib mXBDEUtils;
529 unit uPSI_MDIEdit; //richedit
530 unit uPSI_CopyPrsr;
531 unit uPSI_SockApp;
532 unit uPSI_AppEvnts;
533 unit uPSI_ExtActns;
534 unit uPSI_TeEngine;
535 unit uPSI_CoolMain; //browser
536 unit uPSI_StCRC;
537 unit uPSI_StDecMth2;

SHA1 Win 3.9.9.20:  D2D826D94B3F21F1F63CDD3D99996E90AA88633F


News in Detail:
>>>Menu
- Context Menu add Richedit <Ctrl Alt R>
- Menu Help, new Config File / Config Update opener
- Menu Help, ToDo List
- Compile HotKey <Alt C> and F9

>>>Options Add-Ons
- Easy Browser 
- ADO SQL Workbench
- new examples 390 - 402, add 15 bitmap ressources
- VERSIONCHECK in ini-file
- Types List in maxbox_types.pdf

>>>Editor /IDE
- check Overwrite prompt Scripts with same name save
- Indent / Unindent with Tab 3 Steps set
- checks if modified /changed file on menu File New and Clear Editor
- Short Key Manager

>>>mXFramework
- Log file of last instance running: maxboxlog.log
- New Form Template Library: Browser and Richedit
- Assign() in more classes added
- FindComponent fixed
- Full Text Finder V3 dblclick open File and Open/Save Dialog



****************************************************************
Release Notes maXbox 3.9.9.18 October 2013
****************************************************************
Gamma Functions, IndyPackage4, HotLog Threadable, FormTemplateLibrary FTL
Nonlinear regression, ADO Workbench Addon, Assign fixing, IntfNavigator fixing, Applet
30 more Units preCompiled, QRCode Indy Service, add Cfunction like CFill or SRand

492 unit uPSI_JclMath_Class;                    //JCL RTL
493 unit ugamdist; //Gamma function	//DMath
494 unit uibeta, ucorrel; //IBeta
495 unit uPSI_SRMgr;
496 unit uPSI_HotLog;
497 unit uPSI_DebugBox;  //FTL
498 unit uPSI_ustrings;
499 unit uPSI_uregtest;
500 unit uPSI_usimplex;
501 unit uPSI_uhyper;
502 unit uPSI_IdHL7;
503 unit uPSI_IdIPMCastBase,
504 unit uPSI_IdIPMCastServer;
505 unit uPSI_IdIPMCastClient;
506 unit uPSI_unlfit; //nlregression
507 unit uPSI_IdRawHeaders;
508 unit uPSI_IdRawClient;
509 unit uPSI_IdRawFunctions;
510 unit uPSI_IdTCPStream;
511 unit uPSI_IdSNPP;
512 unit uPSI_St2DBarC;
513 unit uPSI_ImageWin;  //FTL
514 unit uPSI_CustomDrawTreeView; //FTL
515 unit uPSI_GraphWin;  //FTL
516 unit uPSI_actionMain;  //FTL
517 unit uPSI_StSpawn;
518 unit uPSI_CtlPanel;
519 unit uPSI_IdLPR;
520 unit uPSI_SockRequestInterpreter;

//Provider=MSDASQL;DSN=mX3base;Uid=sa;Pwd=admin

SHA1 Win 3.9.9.18:  1F9AC60552ABDA3D25E4F4A2646C791B5D93303E

****************************************************************
Release Notes maXbox 3.9.9.16 September 2013
****************************************************************
Routines for LaTeX/PS, Utils Addon, Indy Package3, TAR Archive, @Callbacks
First LCL of Lazarus, CmdLine API, ToDo List, 50 more Units preCompiled
QRCode Service, more CFunctions like CDateTime of Synapse Utils

443 unit uPSI_IdTelnet;
444 unit uPSI_IdTelnetServer,
445 unit uPSI_IdEcho,
446 unit uPSI_IdEchoServer,
447 unit uPSI_IdEchoUDP,
448 unit uPSI_IdEchoUDPServer,
449 unit uPSI_IdSocks,
450 unit uPSI_IdAntiFreezeBase;
451 unit uPSI_IdHostnameServer;
452 unit uPSI_IdTunnelCommon,
453 unit uPSI_IdTunnelMaster,
454 unit uPSI_IdTunnelSlave,
455 unit uPSI_IdRSH,
456 unit uPSI_IdRSHServer,
457 unit uPSI_Spring_Cryptography_Utils;
458 unit uPSI_MapReader,
459 unit uPSI_LibTar,
460 unit uPSI_IdStack;
461 unit uPSI_IdBlockCipherIntercept;
462 unit uPSI_IdChargenServer;
463 unit uPSI_IdFTPServer,
464 unit uPSI_IdException,
465 unit uPSI_utexplot;
466 unit uPSI_uwinstr;
467 unit uPSI_VarRecUtils;
468 unit uPSI_JvStringListToHtml,
469 unit uPSI_JvStringHolder,
470 unit uPSI_IdCoder;
471 unit uPSI_SynHighlighterDfm;
472 unit uHighlighterProcs; in 471
473 unit uPSI_LazFileUtils,            
474 unit uPSI_IDECmdLine;                 
475 unit uPSI_lazMasks;           
476 unit uPSI_ip_misc;
477 unit uPSI_Barcode;
478 unit uPSI_SimpleXML;
479 unit uPSI_JclIniFiles;
480 unit uPSI_D2XXUnit;  {$X-}
481 unit uPSI_JclDateTime;
482 unit uPSI_JclEDI;
483 unit uPSI_JclMiscel2;
484 unit uPSI_JclValidation;
485 unit uPSI_JclAnsiStrings; {-PString}
486 unit uPSI_SynEditMiscProcs2;
487 unit uPSI_JclStreams;
488 unit uPSI_QRCode;
489 unit uPSI_BlockSocket;
490 unit uPSI_Masks,
491 unit uPSI_synautil;   //Synapse


SHA1 Win 3.9.9.16: FDBD968F03B416712E4151A2E720CD24950D7A5A


****************************************************************
Release Notes maXbox 3.9.9.7 September 2013
****************************************************************
DCOM, MDAC, MIDI, TLS support, Posmarks, Utils Addon

431 unit uPSI_JclCOM;
432 unit uPSI_GR32_Math;
433 unit uPSI_GR32_LowLevel;
434 unit uPSI_SimpleHl;
435 unit uPSI_GR32_Filters,
436 unit uPSI_GR32_VectorMaps;
437 unit uPSI_cXMLFunctions;
438 unit uPSI_JvTimer;
439 unit uPSI_cHTTPUtils;
440 unit uPSI_cTLSUtils;
441 unit uPSI_JclGraphics;
442 unit uPSI_JclSynch;

SHA1 Win 3.9.9.7: 774BBDAE21BDF92FBD76E9BA7C7F59CF8D69EECC


****************************************************************
Release Notes maXbox 3.9.9.6 August 2013
****************************************************************
New Macros, Sendmail (instant email), DevCUnits, Tetris Addon

421 unit uPSI_FileAssocs;
422 unit uPSI_devFileMonitorX;
423 unit uPSI_devrun,
424 unit uPSI_devExec;
425 unit uPSI_oysUtils;
426 unit uPSI_DosCommand;
427 unit uPSI_CppTokenizer;
428 unit uPSI_JvHLParser;
429 unit uPSI_JclMapi;
430 unit uPSI_JclShell;

SHA1 Win 3.9.9.6: 76ECD732E1531108B35457D56282B0BBBBB20BAA


****************************************************************
Release Notes maXbox 3.9.9.5 August 2013
****************************************************************
StBarCode Lib, StreamReaderClass, BarCode Package, Astro Package
more ShellAPI, add 32 more units, Simulated Annealing, GenAlgo
REST Test Lib, Multilang Component, Forth Interpreter

389 unit uPSI_XmlVerySimple;
390 unit uPSI_Services;                        //ExtPascal
391 unit uPSI_ExtPascalUtils;
392 unit uPSI_SocketsDelphi;
393 unit uPSI_StBarC;
394 unit uPSI_StDbBarC;
395 unit uPSI_StBarPN;
396 unit uPSI_StDbPNBC;
397 unit uPSI_StDb2DBC;
398 unit uPSI_StMoney;
399 unit uPSI_JvForth;
400 unit uPSI_RestRequest;
401 unit uPSI_HttpRESTConnectionIndy;
402 unit uPSI_JvXmlDatabase; //update
403 unit uPSI_StAstro;
404 unit uPSI_StSort;
405 unit uPSI_StDate;
406 unit uPSI_StDateSt;
407 unit uPSI_StBase;
408 unit uPSI_StVInfo;
409 unit uPSI_JvBrowseFolder;
410 unit uPSI_JvBoxProcs;
411 unit uPSI_urandom; (unit uranuvag;)
412 unit uPSI_usimann; (unit ugenalg;)
413 unit uPSI_JvHighlighter;
414 unit uPSI_Diff;
415 unit uPSI_SpringWinAPI;
416 unit uPSI_StBits;
417 unit uPSI_TomDBQue;
418 unit uPSI_MultilangTranslator;
419 unit uPSI_HyperLabel;
420 unit uPSI_Starter;

SHA1 Win 3.9.9.5: EC71940E7F952262522A7DB91B2BF9762F14A8C6


http://fundementals.sourceforge.net/dl.html

News in Detail:
>>>Menu
  new in menu Close/ Shortcut <Ctrl Q>
- Active Line Color <Ctrl H>  (also in Context Menu)
- Context Menu add new Bookmark #5
- Menu Output, new Style Output/Sky Style
- Context Menu, Count Words Metric now with F11
- Context Menu, Enlarge Gutter 
- Compile HotKey <Alt C>

>>>Macro
- new Macro set: #sign  (name, machine name, timestamp)
- new Macro set: #tech  (performance, threads, ip, time)
- MACRO=Y //put macros in your source header file

>>>Options Add-Ons
- FractalDemo3 with BringToFront
- Dll Spy shows simple functions of a DLL
- new examples 375 - 380, add 10 bitmap ressources
- VERSIONCHECK in ini-file
- Short Help in maxbox_functions_all.pdf

>>>Editor /IDE
- Program/Information isWin64 check /ThreadCount
- PrintFW (PrintF with write/writeln)
- GetSystemPath (Folder: Integer) : TFilename ;
- PrintFW('%.3f  ',[180+90*Rrand]);  write in line
- Statusbar in 3 panels[1-3] , [2]: Row, Col, Sel [3] Threds Count
- deprecated Dbl Click on Word Count in Context Menu (search words with highlightning found)
- Click and mark to drag a bookmark
- Syntax Check <F2> will result in default highlighter (Pascal)
- checks if modified /changed file on menu File New and Clear Editor
- memo1.setfocus after navigate

>>>mXFramework
- QueryPerformanceCounter fixed
- QueryPerformanceFrequency fixed
- TTreeView TTreeNodes fixed
- ThreadCount fixed
-  writeln(GetEnvironmentString);   



****************************************************************
Release Notes maXbox 3.9.9.1 July 2013
****************************************************************
additional SynEdit API, isKeyPressed Routine, Bookmarks, OpenToolsAPI Catalog (OTAC)
Class TMonitor, Configuration Tutorial maxbox_starter25.pdf, Chess.dll Game
arduino map() function, PMRandom Generator

Hint: If you code a loop till keypressed use function: isKeyPressed;

Add Units:
372 unit uPSI_SynHighlighterAny;   
373 unit uPSI_SynEditKeyCmds;      
374 unit uPSI_SynEditMiscProcs,    
375 unit uPSI_SynEditKbdHandler    
376 unit uPSI_JvAppInst,           
377 unit uPSI_JvAppEvent;          
378 unit uPSI_JvAppCommand;        
379 unit uPSI_JvAnimTitle;         
380 unit uPSI_JvAnimatedImage;     
381 unit uPSI_SynEditExport;       
382 unit uPSI_SynExportHTML;       
383 unit uPSI_SynExportRTF;        
384 unit uPSI_SynEditSearch;       
385 unit uPSI_fMain_back           
386 unit uPSI_JvZoom;              
387 unit uPSI_PMrand;              
388 unit uPSI_JvSticker;           

SHA1 Win 3.9.9.1: CEEBEF784CAC67F407CF81581E0CDDB6653F8D40

News in Detail:
>>>Menu
  new in menu Close/ Shortcut <Ctrl Q>
- Active Line Color <Ctrl H>  (also in Context Menu)
- Context Menu add 4 Bookmarks Menu/Editor Form Options
- Menu Output, new Style Output/Sky Style
- Context Menu, Indent-Unindent menu, Undo-Redo

>>>Macro
- new Macro set: #sign  (name, machine name, timestamp)
- MACRO=Y //put macros in your source header file

>>>Options Add-Ons
- FractalDemo3 with Matrix Fractal and Performance Test
- Dll Spy shows simple functions of a DLL
- new examples 372 - 375

>>>Editor /IDE
- Default ActiveLineColor (clWebFloralWhite)
- Statusbar in 3 panels[1-3] , [2]: Row, Col, Sel [3] Threds Count
- Dbl Click on Word in Editor search amount of words with highlightning
- Dbl Click on Bookmarks to delete
- Click and mark to drag a bookmark
- Syntax Check <F2> will result in default highlighter (Pascal)
- checks if modified /changed file on menu File New and Clear Editor


****************************************************************
Release Notes maXbox 3.9.8.9 June 2013
****************************************************************
SynEdit API, Macros, Macro Recorder, DLL Spy, Configuration Tutorial maxbox_starter25.pdf
IDE Reflection API, Session Service Shell S3

Please Note: if a script doesnt run well check switch menu: On/Off Options/ProcessMessages!

Add Units:
362 unit uPSI_SynEdit;                  
363 unit uPSI_SynEditTypes;       
364 unit uPSI_SynMacroRecorder; 
365 unit uPSI_LongIntList;               
366 unit uPSI_devCutils;   
367 unit uPSI_SynEditMiscClasses;
368 unit uPSI_SynEditRegexSearch;
369 unit uPSI_SynEditHighlighter;
370 unit uPSI_SynHighlighterPas;         
371 unit uPSI_JvSearchFiles;

SHA1 Win 3.9.8.9:  CD9BAB3E6B6E25827AE237CC4F8E4FEF658058A8

News in Detail:
>>>Menu
  new in menu Debug/Goto Line <Ctrl G>
- Active Line Color <Ctrl H>  (also in Context Menu)
- Help/Configuration (math path)-;
- Help/Config File open access
- File/Print Preview 
- Code Search with <Ctrl F3>

>>>Macro
- Macro set the macros #name, #date, #host, #path, #file, #head#, see Tutorial maxbox_starter25.pdf
- Macro Help in Functions List, line 10186 
- ini-file Macro //  ini-file Navigator
- macro information in menu Program/Information
MACRO=Y //put macros in your source header file
NAVIGATOR=Y //set the nav listbox at the right side of editor

>>>Options Add-Ons
- MP3 Player with list function duallist player
- Dll Spy shows simple functions of a DLL
- new examples 365 - 371

>>>Editor /IDE
- Uri Active Links Context Menu Editor Size Options-URI Links Click <Ctrl W>
- Close Highlighter to simple text with URI links, toogle switch back   <Ctrl W>
- new Statusbar in 3 panels[1-3] , right side S for Save and M! for Modified
- syntax highlighter for asm >better color silver> end //assembler code
- faster Code Search Engine of .pas and .txt files full text Help/Code Search 
- Dbl Click on Word in Editor search amount of words 
- SynEdit - SynMemo API open tools for coding in bootscript or macros!
- Close by Esc bug solved.

****************************************************************
Release Notes maXbox 3.9.8.8 Mai 2013
****************************************************************
Compress-Decompress Zip, Services Tutorial22, Synopse framework, PFDLib

350 unit uPSI_JvNTEventLog;
351 unit uPSI_ShellZipTool;
352 unit uPSI_JvJoystick;
353 unit uPSI_JvMailSlots;
354 unit uPSI_JclComplex;
355 unit uPSI_SynPdf;
356 unit uPSI_Registry;
357 unit uPSI_TlHelp32;
358 unit uPSI_JclRegistry;
359 unit uPSI_JvAirBrush;
360 unit uPSI_mORMotReport;
361 unit uPSI_JclLocales;

SHA1 Win 3.9.8.8:  CB7D64ACF0D65D8D18FF668D7556B263C8BF0082

****************************************************************
Release Notes maXbox 3.9.8.6 April 2013
****************************************************************
Halt-Stop Program in Menu, WebServer2, Stop Event Recompile,
Conversion Routines, Prebuild Forms, more RCData, DebugOutString
CodeSearchEngine to search code patterns in /examples <Ctrl F3>
JvChart - TJvChart Component - 2009 Public, mXGames, JvgXMLSerializer, TJvPaintFX

297 unit uPSI_JvFloatEdit;    //3.9.8 (1258 Objects)
298 unit uPSI_JvDirFrm;
299 unit uPSI_JvDualList;
300 unit uPSI_JvSwitch;
301 unit uPSI_JvTimerLst;
302 unit uPSI_JvMemTable;
303 unit uPSI_JvObjStr;
304 unit uPSI_StLArr;
305 unit uPSI_StWmDCpy;
306 unit uPSI_StText;
307 unit uPSI_StNTLog;
308 unit uPSI_xrtl_math_Integer;
309 unit uPSI_JvImagPrvw;
310 unit uPSI_JvFormPatch;
311 unit uPSI_JvPicClip;
312 unit uPSI_JvDataConv;
313 unit uPSI_JvCpuUsage; 
314 unit uPSI_JclUnitConv_mX2;
315 unit JvDualListForm;
316 unit uPSI_JvCpuUsage2;
317 unit uPSI_JvParserForm;
318 unit uPSI_JvJanTreeView;
319  unit uPSI_JvTransLED;
320 unit uPSI_JvPlaylist;
321 unit uPSI_JvFormAutoSize;
322 unit uPSI_JvYearGridEditForm;
323 unit uPSI_JvMarkupCommon;
324 unit uPSI_JvChart;
325 unit uPSI_JvXPCore; 
326 unit uPSI_JvXPCoreUtils;
327 unit uPSI_StatsClasses;
328 unit uPSI_ExtCtrls2;
329 unit uPSI_JvUrlGrabbers;
330 unit uPSI_JvXmlTree;
331 unit uPSI_JvWavePlayer;
332 unit uPSI_JvUnicodeCanvas;
333 unit uPSI_JvTFUtils;
334 unit uPSI_IdServerIOHandler;
335 unit uPSI_IdServerIOHandlerSocket;
336 unit uPSI_IdMessageCoder;
337 unit uPSI_IdMessageCoderMIME;
338 unit uPSI_IdMIMETypes;
339 unit uPSI_JvConverter;
340 unit uPSI_JvCsvParse;
341 unit uPSI_uMath; unit uPSI_ugamma;
342 unit uPSI_ExcelExport; (Native: TJsExcelExport)
343 unit uPSI_JvDBGridExport;
344 unit uPSI_JvgExport;
345 unit uPSI_JvSerialMaker;
346 unit uPSI_JvWin32;
347 unit uPSI_JvPaintFX;
348 unit uPSI_JvOracleDataSet; (beta)
349 unit uPSI_JvValidators; (preview)
350 unit uPSI_JvNTEventLog;

SHA1 Win 3.9.8.6:  F53090C44C7C8224A08ED6321A30EF22D5DC6EA2

****************************************************************
Release Notes maXbox 3.9.7.5 February 2013
****************************************************************
SimLogBox Addon, Bugfixes
add Ressources & Bitmaps, PEImage Forensic, add Units:

285 unit uPSI_IdRFCReply;
286 unit uPSI_IdIdent;
287 unit uPSI_IdIdentServer;
288 unit uPSI_JvPatchFile;
289 unit uPSI_StNetPfm;
290 unit uPSI_StNet;
291 unit uPSI_JclPeImage;
292 unit uPSI_JclPrint;
293 unit uPSI_JclMime;
294 unit uPSI_JvRichEdit;
295 unit uPSI_JvDBRichEd;
296 unit uPSI_JvDice;

SHA1 Win 3.9.7.5: 636B8937BCC03F2E38952E13CFD4C46C31AAF44C

GNU GENERAL PUBLIC LICENSE
Version 3, 29 June 2007

****************************************************************
Release Notes maXbox 3.9.7.4 January 2013
****************************************************************
SimLogicBox Package
PerformanceTester, InfoControl, MIDI
Added Units:
271 unit uPSI_JclMIDI;
272 unit uPSI_JclWinMidi;
273 unit uPSI_JclNTFS;
274 unit uPSI_JclAppInst;
275 unit uPSI_JvRle;
276 unit uPSI_JvRas32;
277 unit uPSI_JvImageDrawThread,
278 unit uPSI_JvImageWindow,
279 unit uPSI_JvTransparentForm;
280 unit uPSI_JvWinDialogs;
281 uPSI_JvSimLogic,
282 uPSI_JvSimIndicator,
283 uPSI_JvSimPID,
284 uPSI_JvSimPIDLinker,

SHA1 Win 3.9.7.4: ADEE0F6CC0B790A1B5E6C3E01AE39B486D651EFF

****************************************************************
Release Notes maXbox 3.9.7.1 December 2012
****************************************************************
FullText Finder2
IntfNavigator2
Graphics.pas with Assign()
Query by Example
JProfiler

247 unit uPSI_CPortMonitor;
248 unit uPSI_StIniStm;
249 unit uPSI_GR32_ExtImage;
250 unit uPSI_GR32_OrdinalMaps;
251 unit uPSI_GR32_Rasterizers;
252 unit uPSI_xrtl_util_Exception;
253 unit uPSI_xrtl_util_Value;
254 unit uPSI_xrtl_util_Compare;
255 unit uPSI_FlatSB;
256 unit uPSI_JvAnalogClock;
257 unit uPSI_JvAlarms;
258 unit uPSI_JvSQLS;
259 unit uPSI_JvDBSecur;
260 unit uPSI_JvDBQBE;
261 unit uPSI_JvStarfield;
262 unit uPSI_JVCLMiscal;
263 unit uPSI_JvProfiler32;
264 unit uPSI_JvDirectories,
265 unit uPSI_JclSchedule,
266 unit uPSI_JclSvcCtrl,
267 unit uPSI_JvSoundControl,
268 unit uPSI_JvBDESQLScript,
269 unit uPSI_JvgDigits,
270 unit uPSI_ImgList; //TCustomImageList


SHA1 Win 3.9.7.1: F04D41D8A402AD217941AF635DCE2690A9A8980C


****************************************************************
Release Notes maXbox 3.9.6.4 December 2012
****************************************************************
Tutorial 19 WinCOM with Arduino
Tutorial 20 RegularExpressions Coding
Script History to 9 Files
WebServer light ../Options/Addons/WebServer

231 unit uPSI_xrtl_util_COMCat;
232 unit uPSI_xrtl_util_StrUtils;
233 unit uPSI_xrtl_util_VariantUtils;
234 unit uPSI_xrtl_util_FileUtils;
235 unit xrtl_util_Compat;
236 unit uPSI_OleAuto;
237 unit uPSI_xrtl_util_COMUtils;
238 unit uPSI_CmAdmCtl;
239 unit uPSI_ValEdit2;
240 unit uPSI_GR32;  //Graphics32
241 unit uPSI_GR32_Image;
242 uPSI_xrtl_util_TimeUtils;
243 uPSI_xrtl_util_TimeZone;
244 uPSI_xrtl_util_TimeStamp;
245 uPSI_xrtl_util_Map;
246 uPSI_xrtl_util_Set;

SHA1 Win 3.9.6.4: C3E0D8BCC662EAC5DEC8396B46085A548818FFB2

****************************************************************
Release Notes maXbox 3.9.6.3 November 2012
****************************************************************
DMath DLL included incl. Demos
Interface Navigator menu/View/Intf Navigator
Unit Explorer menu/Debug/Units Explorer
EKON 16 Slides ..\maxbox3\docs\utils
Direct Excel Export maXcel

203 unit uPSI_utypes;  //for DMath.DLL
204 unit uPSI_ShellAPI;
205 unit uPSI_IdRemoteCMDClient;
206 unit uPSI_IdRemoteCMDServer;
207 unit IdRexecServer;
208 unit IdRexec; (unit uPSI_IdRexec;)
209 unit IdUDPServer;
210 unit IdTimeUDPServer;
211 unit IdTimeServer;
212 unit IdTimeUDP; (unit uPSI_IdUDPServer;)
213 unit uPSI_IdIPWatch;
214 unit uPSI_IdIrcServer;
215 unit uPSI_IdMessageCollection;
216 unit uPSI_cPEM;
217 unit uPSI_cFundamentUtils;
218 unit uPSI_uwinplot;
219 unit uPSI_xrtl_util_CPUUtils;
220 unit uPSI_GR32_System;
221 unit uPSI_cFileUtils;
222 unit uPSI_cDateTime; (timemachine)
223 unit uPSI_cTimers; (high precision timer)
224 unit uPSI_cRandom;
225 unit uPSI_ueval;
226 unit uPSI_xrtl_net_URIUtils;
227 unit xrtl_net_URIUtils;
228 unit uPSI_ufft;  (FFT of DMath)
229 unit uPSI_DBXChannel;
230 unit uPSI_DBXIndyChannel;


SHA1 Win 3.9.6.3: F576574E57F5EE240566B7D68BC44A84E3BE9938


****************************************************************
Release Notes maXbox 3.9.6 November 2012
****************************************************************
MemoryLeakReport in ini-file (MEMORYREPORT=Y)
PerlRegEx PCRE obj lib included
Perl & Python Syntax Editor
bitbox3 logic example
TAdoQuery.SQL.Add() fixed
ShLwAPI extensions
Indy HTTPHeader Extensions
194 unit uPSI_SynURIOpener;
195 unit uPSI_PerlRegEx;
196 unit uPSI_IdHeaderList;
197 unit uPSI_StFirst;
198 unit uPSI_JvCtrls;
199 unit uPSI_IdTrivialFTPBase;
200 unit uPSI_IdTrivialFTP;
201 unit uPSI_IdUDPBase;
202 unit uPSI_IdUDPClient;

SHA1 Win 3.9.6.1: B55D223159CFB5855A0BB128CB699FD8371B28CA


****************************************************************
Release Notes maXbox 3.9.4 October 2012
****************************************************************

Two new Tutorials, 17 Web Server, 18 Arduino LED
Added Units:
189 unit uPSI_cutils;
190 unit uPSI_BoldUtils;
191 unit uPSI_IdSimpleServer;
192 unit uPSI_IdSSLOpenSSL;
193 unit uPSI_IdMultipartFormData;
SHA1 Hash: Win 3.9.4.4: 8FCD41C4194F08249F085CE32F63C51B92CCC086


****************************************************************
Release Notes maXbox 3.9.3 October 2012
****************************************************************
Add Units:
161 uPSI_CheckLst;
162 uPSI_JvSimpleXml;
163 uPSI_JclSimpleXml;
164 uPSI_JvXmlDatabase;
165 uPSI_JvMaxPixel;
166 uPSI_JvItemsSearchs;
167 uPSI_StExpEng;
168 uPSI_StGenLog;
169 uPSI_JvLogFile;
170 unit uPSI_CPort; //ComPort Library v 4.11 
171 unit uPSI_CPortCtl;
172 unit uPSI_CPortEsc;
173 unit BarCodeScaner;  //frame
174 unit uPSI_JvGraph;
175 unit uPSI_JvComCtrls;
176 unit uPSI_GUITesting;  //DUnit
177 unit uPSI_JvFindFiles;
178 unit uPSI_StSystem;
179 unit uPSI_JvKeyboardStates;
180 unit uPSI_JvMail;
181 unit uPSI_JclConsole;
182 unit uPSI_JclLANMan;
183 unit uPSI_IdCustomHTTPServer;
184 unit IdHTTPServer
185 unit uPSI_IdTCPServer;
186 unit uPSI_IdSocketHandle;
187 unit uPSI_IdIOHandlerSocket;
188 unit IdIOHandler;

New add-on: Units Explorer (dependency walker)
Redesign of use case editor
Script List API in maxform1.mxnavigator
First Android code structure (Lazarus 1.0)
First Arduino Delphi LED example ex. 301 with CPort
add classes TDataModule, TGUITestCase, THTTPServer
HTTP WebServer Script 303_
menu View: Settings
maXcalc extensions (hex in the box)
Form: myform Template with <CtrJ>
SHA1 Hash: Win 3.9.3.6: C3531DC055AEB324459D2D04EB827D73D441B77E

SHA1 Hash: CLX 3.7.6.14: 199E9C3DE23C02DD7C4A32E424D5BCBC0FF47685 
add units: Turtle, JvgLogics, Expression Parser, JvStrings, HTTPServer, TCPServer and more

****************************************************************
Release Notes maXbox 3.9.2 September 2012
****************************************************************

more functions in maXcalc
more functions in RegEx
updated functionlist
152 unit uPSI_IMouse;
153 unit uPSI_SyncObjs;
154 unit uPSI_AsyncCalls; //draft for mX4
155 unit uPSI_ParallelJobs; //draft for mX4
156 unit uPSI_Variants;
157 unit uPSI_VarCmplx;
158 unit uPSI_DTDSchema;
159 unit uPSI_ShLwApi;
160 unit uPSI_IBUtils;
SHA1 Hash of maXbox 3.9.2.2: D6D993CF9F1B98BEBB44295C03E7DE29D8E8CC4B

****************************************************************
Release Notes maXbox 3.9.1 August Distribution 2012
****************************************************************
new tutorial 16 event programming
added docs & examples
no changes in compiler maxbox3.exe !
update to pas_includebox lib
SHA1 Hash of maXbox 3.9.1.2: B8686418D5F31B618E595F26F8E74BBCD39AA839 

****************************************************************
Release Notes maXbox 3.9.1 June 2012
****************************************************************
SysTools4 Integration, PicturePuzzle, HTMLJpeg

129 unit uPSI_StUtils;
130 unit uPSI_StToHTML;
131 unit uPSI_StStrms;
132 unit uPSI_StFIN;
133 unit uPSI_StAstroP;
134 unit uPSI_StStat;
135 unit uPSI_StNetCon;
136 unit uPSI_StDecMth;
137 unit uPSI_StOStr;
138 unit uPSI_StPtrns;
139 unit uPSI_StNetMsg;
140 unit uPSI_StMath;
141 unit uPSI_StExpEng;
142 unit uPSI_StCRC;
143 unit uPSI_StExport,
144 unit uPSI_StExpLog,
145 unit uPSI_ActnList;
146 unit uPSI_jpeg;
147 unit uPSI_StRandom;
148 unit uPSI_StDict;
149 unit uPSI_StBCD;
150 unit uPSI_StTxtDat;
151 unit uPSI_StRegEx;

SHA1 Hash of maXbox 3.9.1.2: B8686418D5F31B618E595F26F8E74BBCD39AA839 

****************************************************************
Release Notes maXbox 3.9.0 June 2012
****************************************************************

Object Finder, HTML Export, SynRegEx,  plus UML Signs

119 unit uPSI_DBLogDlg;
120 unit uPSI_SqlTimSt;
121 unit uPSI_JvHtmlParser;
122 unit uPSI_JvgXMLSerializer;
123 unit uPSI_JvJCLUtils;
124 unit uPSI_JvStrings;
125 unit uPSI_uTPLb_IntegerUtils;
126 unit uPSI_uTPLb_HugeCardinal;
127 unit uPSI_uTPLb_HugeCardinalUtils;
128 unit uPSI_SynRegExpr;

SHA1 Hash of maXbox Win  3.9.0.1:   CFCAB4764DDE25AED6112646BEFC48CF2A2DC306

****************************************************************
Release Notes maXbox 3.8.6.4 Mai 2012
****************************************************************
Workbench Plug-In List, threads, hexdump
Variant Support - Genetix Algorithms - Closure Tests
JBL (Jedi Base Library)-Turtle Interpreter
103 unit uPSI_JvGenetic;
104 unit uPSI_JclBase;
105 unit uPSI_JvUtils;
106 unit uPSI_JvStrUtil;
107 unit uPSI_JvStrUtils;
108 unit uPSI_JvFileUtil;
109 unit uPSI_JvMemoryInfos;
110 unit uPSI_JvComputerInfo;
111 unit uPSI_JvgCommClasses;
112 unit uPSI_JvgLogics;
113 unit uPSI_JvLED;
114 unit uPSI_JvTurtle;
115 unit uPSI_SortThds; unit uPSI_ThSort;
116 unit uPSI_JvgUtils;
117 unit uPSI_JvExprParser;
118 unit uPSI_HexDump;

SHA1 Hash of maXbox Win  3.8.6.4: E5BD4A3AA6488FE01EE0F517C2B5960AAA4BB875
SHA1 Hash of maXbox CLX 3.7.5.1: 16B0FD0CE92D6EA356804E7F1B0E6EC8534C2E58

****************************************************************
Release Notes maXbox 3.8.5.1  April 2012
****************************************************************
- added TSerial 4.3 (RS232) with app on output 
- Tutorial 15 Serial Programming
- added math formula translator of JvParsing
- onMessage and onException events
094 unit uPSI_JvCtrlUtils;
095 unit uPSI_JvFormToHtml;
096 unit uPSI_JvParsing;
097 unit uPSI_SerDlgs;
098 unit uPSI_Serial;
099 unit uPSI_JvComponent;
100 unit uPSI_JvCalc;
101 unit uPSI_JvBdeUtils;
102 unit uPSI_JvDateUtil;

SHA1 Hash of maXbox 3.8.5.1:  F8DF3B816B0CEB72DC44F0F8492E556A10E05AA5
SHA1 Hash of maXbox 3.8.5.0:  CDDA808D3B29B0D517CFE6AF2B68AF0A6D6B35D1

Release 3.8.5 Vienna Edition

****************************************************************
Release Notes maXbox 3.8.4 March 2012
****************************************************************
- PDF function help system, PHP Syntax
- new tutorial about data encryption and async programming
- added functions: Performance Counter, CryptoBox3.1, API Timer
- added crypto and JCL units:
86 unit uPSI_uTPLb_AES;                        //LockBox 3
87 unit uPSI_IdHashSHA1;                       //LockBox 3
88 unit uTPLb_BlockCipher;                     //LockBox 3
89 unit uPSI_ValEdit.pas;	               //Delphi VCL
90 unit uPSI_JvVCLUtils;  		//JCL Utils, DBUtils, AppUtils
91 unit uPSI_JvDBUtil;
92 unit uPSI_JvDBUtils;
93 unit uPSI_JvAppUtils;

SHA1 Hash of maXbox 3.8.4:     3D7BA42B0952065DBE9863E2D517C4CE9BEAFA0C  

****************************************************************
Release Notes maXbox 3.8.1 January 2012
****************************************************************
- Added Units:
76 unit uPSI_ShadowWnd; (VCL)
77 unit uPSI_ToolWin; (VCL)
78 unit uPSI_Tabs; (VCL)
79 unit uPSI_JclGraphUtils; (JCL), OpenGL
80 unit uPSI_JclCounter; (JCL)
81 unit uPSI_JclSysInfo; (JCL)
82 unit uPSI_JclSecurity; (JCL)
83 unit uPSI_JclFileUtils; (JCL)
84 unit uPSI_IdUserAccounts; (Indy) 
85 unit uPSI_IdAuthentication; (Indy)

Tested mX4 compiler
SHA1 Hash of maXbox 3.8.1: 7878D2AF674A222F8D2F1DB8CE6D16951ADFBE78
SHA1 Hash of maXbox CLX:  92D56AFDADA5A8100D57082B5686FAD4B5EA2AD1

****************************************************************
Release Notes maXbox 3.8 2012
****************************************************************
- Update Compiler from mX3 to mX4 (unit support, enhanced decompile/debug)
- Internet Version Check 
- Boot Loader Script (Auto Start) 
- Updated Examples
- mX4 adaption of syntax, compile, decompile and debug synchronisation
SHA1 Hash of maXbox 3.8:   DAB8B2834E4EE14043D440C2C57185586C2F54D1

****************************************************************
Release Notes maXbox 3.7.1 December 2011
****************************************************************

- File Information Menu, Package Loader, 2 New Tutorials 
- Added Units:
69 unit uPSI_WideStrUtils;                    
70 unit uPSI_GraphUtil;                       
71 unit uPSI_TypeTrans;                        
72 unit uPSI_HTTPApp;                          
73 unit uPSI_DBWeb;              
74 unit uPSI_DBBdeWeb;              
75 unit uPSI_DBXpressWeb;         
SHA1 Hash of maXbox 3.7.0.2 Win: CE87326ADA879A60FAF4062AB6E6CC26069B8250
SHA1 Hash of maXbox CLX:             ED8B46160A604F8162A19E0E1FBC3515D0F38C66

****************************************************************
Release Notes maXbox 3.6.3 November 2011
****************************************************************

New Units
unit uPSI_JclStatistics;
unit uPSI_JclLogic;
unit uPSI_JclMiscel;
unit uPSI_JclMath_max;
unit uPSI_uTPLb_StreamUtils;
unit uPSI_MathUtils;
unit uPSI_JclMultimedia;

Resource Finder, Script Explorer, F4 (New Instance) and F6 (Goto End.) 
SHA1 Hash of maXbox Win: 365666B4648C478D3FDB1444D3824422C5C51024 


****************************************************************
Release Notes maXbox 3.6.2 November 2011
****************************************************************
//MATLAB, maXbox, Mapple examples added;)

New Units
58 unit uPSI_CDSUtil;	//Borland MIDAS
59 unit uPSI_VarHlpr;	//Delphi RTL
60 unit uPSI_ExtDlgs;	//Delphi VCL

several bugfixes in graphics, client dataset, dialogs and RTL
allresourcelist.txt and resource dll added (maxbox_res.dll)
switch on/off Options/ProcessMessages!

20.10.2011 14:35:18 Creation Date of maXbox3
SHA1 Hash of maXbox Win: 8BE92CE1B63FACF9AA21807CA9DCDBF49D370FA7

****************************************************************
Release Notes maXbox 3.6.1.2 October 2011
****************************************************************
New Units
- unit uPSI_DBClient;	//Delphi RTL
- unit uPSI_DBPlatform;	//Delphi RTL
- unit uPSI_Provider;		//Delphi RTL
- unit uPSI_FMTBcd;	//Delphi RTL
- unit uPSI_DBCGrids;	//Delphi VCL
	
SHA1 Hash of maXbox Win:   E849BE32DDB42FFB54920ED3486735FEEA6DDCD8
SHA1 Hash of maXbox CLX:   7C3BF0DDA7C62C21F7C8E3A907DAAD423E4B6C6F
SHA1 Hash of maXbox Mac:   E849BE32DDB42FFB54920ED3486735FEEA6DDCD8

****************************************************************
Release Notes maXbox 3.6.0.2 October 2011
****************************************************************
New Units
- ComCtrls Unit
- Dialogs Unit
- StdConvs Unit
- VListView
- DebugOut Window and Android / Arduino HexDump Preparations

27.09.2011 23:52:04 Creation Date of maXbox3
SHA1 Hash of maXbox Win:   ABE2E228BE6853C9327B9623C82AD104F7369720
SHA1 Hash of maXbox CLX:   7C3BF0DDA7C62C21F7C8E3A907DAAD423E4B6C6F
Shell Version is: 393216, Version of maXbox3: 3.6.0.2

****************************************************************
Release Notes maXbox 3.5.1 September 2011
****************************************************************
- 10 Tutorials and 220 Examples
- Android/Mac Beta 0.8 as Delphi VirtualMachine
- Syntax Check F2 - Java, C Syntax in Context Menu
- Stop forever loops by edit and recompile if Options/ProcessMessages is set 
- Crypto Unit, SocketServer, UpdateService, ScriptLoader
- Enhanced OpenTools API, run example '214_mxdocudemo3.txt'
- Upgrade of upsi_allfunctionslist.txt and upsi_allobjectslist.txt
- Service Site: http://www.softwareschule.ch/maxbox.htm 
- Best of Runtime Test Routine, example 165_best_of_runtime2.txt

14.09.2011 23:39:28 Creation Date of maXbox3 for maXbox3 3.5.1.8
Shell Version is: 393216, Version of maXbox3: 3.5.1.8

****************************************************************
Release Notes maXbox 3.3 Juli 2011
****************************************************************
- prepare to WebService and CodeCompletion: uPSI_XMLUtil;  SOAPHTTPClient;            
- new Instance, componentcount, cipherbox, 15 new functions and new Examples

****************************************************************
Release Notes maXbox 3.2 April 2011
****************************************************************
- New Units: WideStrings, BDE, SqlExpr (DBX3), ADO_DB, StrHlpr, DateUtils, FileUtils
//Expansion to DateTimeLib and Expansion to Sys/File Utils
 JUtils / gsUtils / JvFunctions of Jedi Functions
- prepare to WebService: HTTPParser; HTTPUtil; uPSI_XMLUtil;  SOAPHTTPClient;            
- new Tutorial 9 and now 210 Examples

****************************************************************
Release Notes maXbox 3.1 March 2011
****************************************************************
please read also http://www.softwareschule.ch/maxboxnews.htm

Now almost 1000 functions /procedures and about 110 objects /classes from VCL, FCL, LCL or CLX
- start it from a USB stick or from a UNC Network Path
- new output menu of styles for prototyping or teaching include context menu
- include kernel functions of compiler and makro editor with RegEX2
- new Units: DB System, Tables and DataSets, Printer, MediaPlayer, Grids, Clipboard, Statusbar

****************************************************************
Release Notes maXbox 3.0 December 2010
****************************************************************

//Load examples *.txt from /examples and press F9!
//please read the readmefirst...or start with the tutorials in /help
//memo1 is script editor
//memo2 is output space

- over 600 new delphi, pascal, network and indy functions in built
- now 810 functions /procedures and 120 types and constants
  (see in the file: upsi_allfunctionslist.txt)
- png, tiff, jpg and more graphics support for canvas and TPicture
- SMTP, POP3, HTTP, FTP, sysutils, strutils, shell and ini support
- Improvments of 64Bit, PNG, and Ansi/WideStrings are done, Dialogs and Plugins are under way
  (e.g. MP3-Player and POP3-Mail Function)
- Now() is now the origin, you have to call DateTimeToStr(Now)
- maXCom examples 1-150 improved with students
- readonly Mode in ../Options/Save before Compile
- mX3 logo font is Tempus Sans ITC kursiv durchgestrichen 48
- use case designer (in speed button, popup & menu)
  note: when a model file has same name like the code file with extension *.uc
  it will load straight the use case editor from same directory 
  e.g. examples/50_program_starter.txt
         examples/50_program_starter.uc
- updating all the examples from _1 to _150 in 8 categories base, math, graphic, statistic, system, net, internet and games. 	

{ max@kleiner.com  V3.0.0.6 February 2011
  new version and examples from
     http://www.softwareschule.ch/maxbox.htm }


Information for the CLX Linux Version
****************************************************************
you can start a shell script with the name e.g. "maxboxstart.sh":
-----------------------------------------------------------------------------
#!/bin/bash
cd `dirname $0`
export LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH
./maxbox3clx
exit 0
-----------------------------------------------------------------------------
so it will include the path to the 2 symbolic links and you can start the box
 from the shell, from script or with click from a stick.
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
Release Notes on V2.9.2
- ftp, html support (based on indy sockets), examples 104-120
Release Notes on V2.9.1
- http support (based on indy sockets), examples 101-103
-----------------------------------------------------------------------------
Release Notes on V2.9.0
-----------------------------------------------------------------------------

Note about vista and win7: by using labels from TLabel set transparent:= false;
for graphics/forms concerning visibility/performance try the ProcessMessages! flag
under /Options/ProcessMessages! 

****************************************************************
Changes in maXbox 2.9 Juni 2010
****************************************************************
- font editor in menu 
- include bug in menu show include solved, also relative path 
- bitmap support for canvas and TPicture
- TDataSet and DB fields support
- use case designer (in speed button, popup & menu)
  note: when a model file has a same name like the code file but the extension *.uc
  it will load straight in the use case editor from same directory (e.g. examples)
  e.g. examples/50_program_starter.txt
       examples/50_program_starter.uc	


Changes in maXbox 2.8.1 April 2010
****************************************************************
- refresh problem after clipboard actions in editor solved
- standard math functions added (exp, ln, sqr, arctan etc.)
- doesn't hang after long running (application.processMessages)
- commandline interface in shell:>maxbox2.exe "script_file.txt"
- starter tutorial2 in /docs maxbox_starter2.pdf 


maXbox 2.8 Januar 2010
****************************************************************
- 2 file history in ini file and change between
- more perfomance in debug mode 
- starter tutorial in /docs maxbox_starter.pdf
- assign2 and reset2 functions
- special characters in edit mode 
- reptilian liquid motion function (rlmf)


Changes in maXbox 2.7.1 November 2009
****************************************************************
- debug and decompile functions with a second compile engine
- inbuilt math and stat lib
- all time and date functions internal now
- playMP3, stopMP3, closeMP3
- save bytecode bug solves (options show bytecode)

****************************************************************
News in maXbox v 2.7
****************************************************************
code completion in bds_delphi.dci - delphi compatible
escape and cut/copy paste in memo1
write() and TFileStruct bug solved
line numbers in gutter
statusline and toolbar
enhanced clipboard
check the demo: 38_pas_box_demonstrator.txt
published on http://sourceforge.net/projects/maxbox
subset was extended by the Poly data type that allows you to operate with dynamic data structures (lists, trees, and more) without using pointers and apply Pascal language in the Artificial Intelligence data domain with the same success.
PasScript supports more wide subset of the OP language. You can use such concepts as units, default parameters, overloaded routines, open arrays, records, sets, pointers, classes, objects, class references, events, exceptions, and more in a script. PasScript syntax is 98% compatible with OP.
Allow scripts to use dll functions, the syntax is like:
function FindWindow(C1, C2: PChar): Longint; external 'FindWindowA@user32.dll stdcall'; 
You can include files {$I pas_includebox.inc} and print out your work.
maXbox includes a preprocessor that allows you to use defines ({$IFDEF}, {$ELSE}, {$ENDIF}) to include other files in your script ({$I filename.inc}). 

------------------------------------------------------------------
Important First Steps and Tips and Tricks:
------------------------------------------------------------------
1. You can load a script by open the file.
2. Then you can compile /save the file (F9).
3. When using the menu options/show_linenumbers the editor is in read only mode!
4. The output window is object memo2 from TMemo and you can program it.
5. Last file, font- and window size are saved in a ini file. -->maxboxdef.ini
6. By escape <esc> you can close the box.
7. The source in the zip is almost complete, please contact for further source.
8. Some functions like random or beep do have a second one: random2, put2, beep2, assign2 etc.
9. Read the tutorial starter 1-8 in tutorial in /docs maxbox_starter.pdf


Tips of the Day for Version V3.5
----------------------------------------------

- Click on the red maXbox Sign (right on top) opens your work directory
- You can printout your scripts as a pdf-file
- You do have a context menu with the right mouse click
- With the UseCase Editor you can convert graphic formats too.
- On menu Options you find 4 Addons as compiled scripts 
- You don't need a mouse to handle maXbox, use shortcuts
- With F2 you check syntax with F9 you compile
- With escape you can leave the box
- In directory /exercises you find a few compilats 
- Drag n' drop your scripts in the box
- Open in menu Outpout a new instance of the box to compare or prepare your scripts
- You can get templates as code completion with ctrl j in the editor like
  classp or iinterface or ttimer (you type classp and then CTRL J)
- In menu output you can set output menu in edit mode by unchecking read only memo  
- To start from CD-ROM (read only mode) uncheck  in Menu /Options/Save before Compile         



just inside maXbox
         ____    ___   _      ____    _   _   _
        |  _ \  |  _| | |    |  _ \  | | | | | |
        | | . | | |_  | |    | |_| | | |_| | | |
        | | | | |  _| | |    |  __/  |  _  | | |          
        | |_. | | |_  | |__  | |     | | | | | |                      
        |____/  |___| |____| |_|     |_| |_| |_|                                   

max@kleiner.com
 
new version and examples from
http://www.softwareschule.ch/maxbox.htm
http://www.softwareschule.ch/download/maxbox3.zip
http://sourceforge.net/projects/maxbox


// to Delphi users:
 Also add this line to your project source (.DPR).
{$D-} will prevent placing Debug info to your code.
{$L-} will prevent placing local symbols to your code.
{$O+} will optimize your code, remove unnecessary variables etc.
{$Q-} removes code for Integer overflow-checking.
{$R-} removes code for range checking of strings, arrays etc.
{$S-} removes code for stack-checking. USE ONLY AFTER HEAVY TESTING !
{$Y-} will prevent placing smybol information to your code.


Dear software manufacturer,

your software maXbox is listed in the heise software directory at <http://www.heise.de/software/download/maxbox/76464> and we recently started offering version CLX 3.2 (maxbox3clx.tar.gz) for download.

Fortunately, our automatic virus checks (done in co-operation with AV-Test GmbH) with more than 40 virus scanners do not indicate a virus infection. Just in case you are interested in the scan result we are sending you the detailed scan report:

============================================================

Scan report of: 39788-maxbox3clx.tar.gz

AntiVir -
Avast -
AVG -
BitDefender -
CA-AV -
ClamAV -
Command -
Command (Online) -
Eset Nod32 -
Fortinet -
F-Prot -
G Data -
Ikarus -
K7 Computing -
Kaspersky -
Kaspersky (Online) -
McAfee -
McAfee (BETA) -
McAfee (Online) -
McAfee GW Edition (Online) -
Microsoft -
Norman -
Panda -
Panda (Online) -
PC Tools -
QuickHeal -
Rising -
Sophos -
Sophos (Online) -
Sunbelt -
Symantec -
Symantec (BETA) -
Trend Micro -
Trend Micro (Cons.) -
Trend Micro (CPR) -
VBA32 -
VirusBuster -

============================================================

The following updates have been used for the test (all times in GMT):

AntiVir vdf_fusebundle.zip 2011-06-29 16:15
Avast av5db.zip 2011-06-29 09:20
AVG avg10cmd1191a4294.zip 2011-06-29 10:10
BitDefender bdc.zip 2011-06-29 17:35
CA-AV fv_nt86.exe 2011-06-29 19:10
ClamAV daily.cvd 2011-06-29 17:00
Command antivir-z-201106291210.zip 2011-06-29 16:45
Command (Online) antivir-z-201106291210.zip 2011-06-29 16:45
Eset Nod32 minnt3.exe 2011-06-29 13:45
Fortinet vir_high 2011-06-29 18:35
F-Prot antivir.def 2011-06-29 16:05
G Data bd.zip 2011-06-29 18:45
Ikarus t3sigs.vdb 2011-06-29 16:20
K7 Computing k7cmdline.zip 2011-06-29 15:20
Kaspersky kdb-i386-cumul.zip 2011-06-29 18:40
Kaspersky (Online) kdb-i386-cumul.zip 2011-06-29 18:40
McAfee avvdat-6392.zip 2011-06-29 16:25
McAfee (BETA) avvwin_netware_betadat.zip 2011-06-29 19:25
McAfee (Online) avvdat-6392.zip 2011-06-29 16:25
McAfee GW Edition (Online) mfegw-cmd-scanner-windows.zip 2011-06-29 17:05
Microsoft mpam-fe.exe 2011-06-29 13:35
Norman nvc5oem.zip 2011-06-29 13:25
Panda pav.zip 2011-06-29 12:15
Panda (Online) pav.zip 2011-06-29 12:15
PC Tools avdb.zip 2011-06-29 18:20
QuickHeal qhadvdef.zip 2011-06-29 15:55
Rising RavDef.zip 2011-06-29 06:50
Sophos ides.zip 2011-06-29 19:30
Sophos (Online) ides.zip 2011-06-29 19:30
Sunbelt CSE39VT-EN-9725-F.sbr.sgn 2011-06-29 18:00
Symantec streamset.zip 2011-06-29 19:25
Symantec (BETA) symrapidreleasedefsv5i32.exe 2011-06-29 19:50
Trend Micro lpt255.zip 2011-06-29 03:15
Trend Micro (Cons.) cvsapi255.zip 2011-06-29 03:20
Trend Micro (CPR) lpt256.zip 2011-06-29 19:20
VBA32 vba32w-latest.rar 2011-06-29 09:45
VirusBuster vdb.zip 2011-06-29 16:10


Greetings,
your heise software team

Dear software manufacturer,

your software maXbox is listed in the heise software directory at <http://www.heise.de/software/download/maxbox/76464>. You did grant us permission to make it available on our download servers.

We would like to inform you that our automatic virus checks (done in co-operation with AV-Test GmbH) with more than 40 virus scanners generated some warnings in version 3.8 (maxbox3.zip).

This is the detailed report:

============================================================

Scan report of: 51941-maxbox3.zip

AntiVir -
Avast -
AVG -
BitDefender -
CA-AV -
ClamAV -
Command -
Command (Online) -
Eset Nod32 -
Fortinet -
F-Prot -
G Data -
Ikarus -
K7 Computing -
Kaspersky -
Kaspersky (Online) -
McAfee -
McAfee (BETA) -
McAfee (Online) -
McAfee GW Edition (Online) -
Microsoft -
Norman -
Panda -
Panda (Online) -
PC Tools -
QuickHeal Suspicious (warning)
Rising -
Sophos NirSoft (PUA)
Sophos (Online) NirSoft (PUA)
Sunbelt -
Symantec -
Symantec (BETA) -
Trend Micro -
Trend Micro (Cons.) -
Trend Micro (CPR) -
VBA32 -
VirusBuster -

============================================================

The following updates have been used for the test (all times in GMT):

AntiVir vdf_fusebundle.zip 2011-12-20 14:00
Avast av5db.zip 2011-12-20 10:00
AVG avg10cmd1191a4653.zip 2011-12-20 10:50
BitDefender bdc.zip 2011-12-20 15:50
CA-AV fv_nt86.exe 2011-12-20 08:05
ClamAV daily.cvd 2011-12-20 14:10
Command antivir-z-201112201348.zip 2011-12-20 15:10
Command (Online) antivir-z-201112201348.zip 2011-12-20 15:10
Eset Nod32 minnt3.exe 2011-12-20 13:30
Fortinet vir_high 2011-12-20 09:35
F-Prot antivir.def 2011-12-20 14:55
G Data bd.zip 2011-12-20 16:05
Ikarus t3sigs.vdb 2011-12-20 13:25
K7 Computing K7Cmdline.zip 2011-12-20 15:50
Kaspersky kdb-i386-cumul.zip 2011-12-20 15:40
Kaspersky (Online) kdb-i386-cumul.zip 2011-12-20 15:40
McAfee avvdat-6565.zip 2011-12-19 17:10
McAfee (BETA) avvwin_netware_betadat.zip 2011-12-20 15:35
McAfee (Online) avvdat-6565.zip 2011-12-19 17:10
McAfee GW Edition (Online) mfegw-cmd-scanner-windows.zip 2011-12-20 11:55
Microsoft mpam-fe.exe 2011-12-20 13:35
Norman nvc5oem.zip 2011-12-20 09:45
Panda pav.zip 2011-12-20 15:35
Panda (Online) pav.zip 2011-12-20 15:35
PC Tools avdb.zip 2011-12-20 15:05
QuickHeal qhadvdef.zip 2011-12-20 08:35
Rising RavDef.zip 2011-12-20 07:00
Sophos ides.zip 2011-12-20 12:45
Sophos (Online) ides.zip 2011-12-20 12:45
Sunbelt CSE39VT-EN-11279-F.sbr.sgn 2011-12-20 10:40
Symantec streamset.zip 2011-12-20 16:15
Symantec (BETA) symrapidreleasedefsv5i32.exe 2011-12-20 15:50
Trend Micro lpt655.zip 2011-12-20 03:55
Trend Micro (Cons.) cvsapi655.zip 2011-12-20 04:10
Trend Micro (CPR) lpt656.zip 2011-12-20 11:35
VBA32 vba32w-latest.rar 2011-12-20 15:15
VirusBuster vdb.zip 2011-12-20 12:50


This is most probably a false alarm. Therefore we are nevertheless offering the file for download but are also checking with the manufacturers of the anti-virus software. You should find an updated scan report in a few days at <http://www.heise.de/software/download/maxbox/76464> (Download-Button).

Greetings,
your heise software team

Examples Info
    examples need internet
    001_1_pas_functest.txt 
    101 - 130
    
    takes time
    044_pas_8queens_solutions.txt (2 min.)
    050_pas_primetest2.txt (1 min)
    064_pas_timetest.txt(1 min)
    070_pas_functionplotter4.txt(2 min.)

075_pas_bitmap_Artwork.txt intelligence test
065 bitcounter as performance test

SHA1 CLX3 3.7.8.24
39 68 15 24 F5 CE A8 41 3A 2E A1 78 C2 31 12 41 36 EE 09 AB 

Win Version 3.9.8.8
Amount of Functions: 6266
Amount of Procedures: 3600
Amount of Constructors: 604
Totals of Calls: 10470


Virus Check 3.9.9.1
We would like to inform you that our automatic virus checks (done in co-operation with AV-Test GmbH) with more than 40 virus scanners generated some warnings in version 3.9.9.1 (maxbox3.zip).

This is the detailed report:

============================================================

Scan report of: 83366-maxbox3.zip

Ahnlab ERROR
Avast -
AVG -
Avira -
Bitdefender -
Command ERROR
Command (Online) ERROR
Eset Nod32 -
Fortinet -
F-Prot -
G Data -
Ikarus -
K7 Computing -
Kaspersky -
Kaspersky (Online) -
McAfee -
McAfee (BETA) -
McAfee (Online) -
McAfee GW Edition (Online) -
Microsoft -
Norman -
Panda -
Panda (Online) -
QuickHeal Suspicious (warning)
Rising -
Sophos -
Sophos (Online) -
Symantec -
Symantec (BETA) -
ThreatTrack -
Total Defense -
Trend Micro -
Trend Micro (Cons.) -
Trend Micro (CPR) -
VBA32 -
VirusBuster -

============================================================

The following updates have been used for the test (all times in UTC):

Ahnlab sdscan-console.zip 2013-06-19 16:25
Avast av5stream.zip 2013-06-19 19:25
AVG avg10cmd1191a5885.zip 2013-06-19 17:15
Avira vdf_fusebundle.zip 2013-06-19 17:55
Bitdefender bdc.zip 2013-06-19 19:05
Command antivir-v2-z-201306191454.zip 2013-06-19 15:10
Command (Online) antivir-v2-z-201306191454.zip 2013-06-19 15:10
Eset Nod32 minnt3.exe 2013-06-19 17:55
Fortinet vir_high 2013-06-19 17:45
F-Prot antivir.def 2013-06-19 16:20
G Data bd.zip 2013-06-19 18:55
Ikarus t3sigs.vdb 2013-06-19 16:30
K7 Computing K7Cmdline.zip 2013-06-19 16:15
Kaspersky kdb-i386-cumul.zip 2013-06-19 18:00
Kaspersky (Online) kdb-i386-cumul.zip 2013-06-19 18:00
McAfee avvdat-7111.zip 2013-06-19 16:35
McAfee (BETA) avvwin_netware_betadat.zip 2013-06-19 18:45
McAfee (Online) avvdat-7111.zip 2013-06-19 16:35
McAfee GW Edition (Online) mfegw-cmd-scanner-windows.zip 2013-06-19 17:30
Microsoft mpam-fe.exe 2013-06-19 16:20
Norman nse7legacy.zip 2013-06-19 15:00
Panda pav.zip 2013-06-19 08:55
Panda (Online) pav.zip 2013-06-19 08:55
QuickHeal qhadvdef.zip 2013-06-19 16:30
Rising RavDef.zip 2013-06-19 06:00
Sophos ides.zip 2013-06-19 17:35
Sophos (Online) ides.zip 2013-06-19 17:35
Symantec streamset.zip 2013-06-19 19:20
Symantec (BETA) symrapidreleasedefsv5i32.exe 2013-06-19 18:25
ThreatTrack CSE39VT-EN-18864-F.sbr.sgn 2013-06-19 19:00
Total Defense fv_nt86.exe 2013-06-19 18:20
Trend Micro itbl1334001700.zip 2013-06-19 19:15
Trend Micro (Cons.) hcoth1010195.zip 2013-06-19 17:25
Trend Micro (CPR) lpt102.zip 2013-06-19 19:25
VBA32 vba32w-latest.rar 2013-06-19 12:25
VirusBuster vdb.zip 2013-06-18 11:00


This is most probably a false alarm. Therefore we are nevertheless offering the file for download but are also checking with the manufacturers of the anti-virus software. You should find an updated scan report in a few days at <http://www.heise.de/download/maxbox-1176464.html> (Download-Button).

Greetings,
your heise software team

