***********************************************************************;
**                                                                   **;
**                  Install AutoML for IoT                           **; 
**                                                                   **;
***********************************************************************;

*INSTALL THE AUTOMLFORIOT DIRECTORY IN THE BELOW FOLDER;
%global INSTALLDIRECTORY WORKBENCH;
%let INSTALLDIRECTORY=/workspaces/volume;
%let WORKBENCH=Y;


*****************************************************;
* BEGIN INSTALLATION SCRIPT;

  %sysmstoreclear; options nomstored;
  libname store "%sysfunc(tranwrd(&_SASPROGRAMFILE.,/Install_SASAutoMLforIoT.sas,))";
  options mstored sasmstore=store;
  %installAutoMLforIoT;
  %sysmstoreclear; options nomstored;

* END INSTALLATION SCRIPT;
*****************************************************;


/*
Copyright 2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
*/
