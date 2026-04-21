***********************************************************************;
**                                                                   **;
**                   Update AutoML for IoT                           **; 
**                                                                   **;
***********************************************************************;

*UPDATE THE AUTOMLFORIOT INSTALL IN THE BELOW FOLDER;
*INSERT THE FULL PATH OF THE AUTOMLFORIOT FOLDER HERE;
%global UPDATEDIRECTORY;
%let UPDATEDIRECTORY=/cisviya-export/cisviya/homes/Steven.Enck@sas.com/AutoMLforIoT;


*****************************************************;
* BEGIN UPDATE SCRIPT;

  %sysmstoreclear; options nomstored;
  libname store "%sysfunc(tranwrd(&_SASPROGRAMFILE.,/Update_SASAutoMLforIoT.sas,))";
  options mstored sasmstore=store;
  %updateAutoMLforIoT;
  %sysmstoreclear; options nomstored;

* END UPDATE SCRIPT;
*****************************************************;


/*
Copyright 2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
*/
