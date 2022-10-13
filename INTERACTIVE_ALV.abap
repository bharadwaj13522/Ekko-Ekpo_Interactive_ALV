*&---------------------------------------------------------------------*
*& Report YZINTERACTIVE_ALV01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT YZINTERACTIVE_ALV01.
TABLES: EKKO,EKPO.
TYPE-POOLS: SLIS.


TYPES : BEGIN OF TY_EKKO,
          EBELN TYPE EKKO-EBELN,
          BUKRS TYPE EKKO-BUKRS,
          BSTYP TYPE EKKO-BSTYP,
          BSART TYPE EKKO-BSART,
          AEDAT TYPE EKKO-AEDAT,
          ERNAM TYPE EKKO-ERNAM,
          LIFNR TYPE EKKO-LIFNR,
          ZBD1T TYPE EKKO-ZBD1T,
        END OF TY_EKKO,

        BEGIN OF TY_EKPO,
          EBELN TYPE EKPO-EBELN,
          EBELP TYPE EKPO-EBELP,
          AEDAT TYPE EKPO-AEDAT,
          MATNR TYPE EKPO-MATNR,
          BUKRS TYPE EKPO-BUKRS,
          WERKS TYPE EKPO-WERKS,
          LGORT TYPE EKPO-LGORT,
          BEDNR TYPE EKPO-BEDNR,
          MATKL TYPE EKPO-MATKL,
        END OF TY_EKPO.

DATA : IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
       WA_FCAT TYPE SLIS_FIELDCAT_ALV,
       WA_LAYO TYPE SLIS_LAYOUT_ALV.

DATA: IT_EKKO TYPE STANDARD TABLE OF TY_EKKO,
      WA_EKKO TYPE TY_EKKO,
      IT_EKPO TYPE STANDARD TABLE OF TY_EKPO,
      WA_EKPO TYPE TY_EKPO.

DATA: SYREPID TYPE SY-REPID.


SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: P_EBELN FOR EKKO-EBELN.
SELECT-OPTIONS: P_ERDAT FOR EKKO-AEDAT.
SELECT-OPTIONS:P_ERNAM  FOR EKKO-ERNAM.
SELECTION-SCREEN END OF BLOCK B1.


SELECT * FROM EKKO
  INTO CORRESPONDING FIELDS OF TABLE IT_EKKO
  WHERE EBELN IN P_EBELN AND
        AEDAT IN P_ERDAT AND
        ERNAM IN P_ERNAM.

*************************************** FIELD CATALOG ******************************************
CLEAR WA_FCAT.
WA_FCAT-COL_POS = '1'.
WA_FCAT-FIELDNAME = 'EBELN'.
WA_FCAT-SELTEXT_L = 'Purchasing Document Number'.
WA_FCAT-HOTSPOT = 'X'.
APPEND WA_FCAT TO IT_FCAT.

CLEAR WA_FCAT.
WA_FCAT-COL_POS = '2'.
WA_FCAT-FIELDNAME = 'BUKRS'.
WA_FCAT-SELTEXT_L = 'COMPANY CODE'.
APPEND WA_FCAT TO IT_FCAT.

CLEAR WA_FCAT.
WA_FCAT-COL_POS = '3'.
WA_FCAT-FIELDNAME = 'BSTYP'.
WA_FCAT-SELTEXT_L = 'Purchasing Document CATEGORY'.
APPEND WA_FCAT TO IT_FCAT.

CLEAR WA_FCAT.
WA_FCAT-COL_POS = '4'.
WA_FCAT-FIELDNAME = 'BSART'.
WA_FCAT-SELTEXT_L = 'Purchasing Document TYPE'.
APPEND WA_FCAT TO IT_FCAT.

CLEAR WA_FCAT.
WA_FCAT-COL_POS = '5'.
WA_FCAT-FIELDNAME = 'AEDAT'.
WA_FCAT-SELTEXT_L = 'DATE'.
APPEND WA_FCAT TO IT_FCAT.

CLEAR WA_FCAT.
WA_FCAT-COL_POS = '6'.
WA_FCAT-FIELDNAME = 'ERNAM'.
WA_FCAT-SELTEXT_L = 'NAME'.
APPEND WA_FCAT TO IT_FCAT.

CLEAR WA_FCAT.
WA_FCAT-COL_POS = '7'.
WA_FCAT-FIELDNAME = 'LIFNR'.
WA_FCAT-SELTEXT_L = 'VENDOR ACCOUNT NUMBER'.
APPEND WA_FCAT TO IT_FCAT.

CLEAR WA_FCAT.
WA_FCAT-COL_POS = '8'.
WA_FCAT-FIELDNAME = 'ZBD1T'.
WA_FCAT-SELTEXT_L = 'DISCOUNT DAYS'.
APPEND WA_FCAT TO IT_FCAT.

WA_LAYO-COLWIDTH_OPTIMIZE ='X'.

***************************************************** DISPLAY DATA ***********************************************

CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    I_CALLBACK_PROGRAM      = SY-REPID            " Name of the calling program
    I_CALLBACK_USER_COMMAND = 'USER_COMMAND'            " EXIT routine for command handling
*   I_CALLBACK_TOP_OF_PAGE  = SPACE            " EXIT routine for handling TOP-OF-PAGE
    IS_LAYOUT               = WA_LAYO          " List layout specifications
    IT_FIELDCAT             = IT_FCAT           " Field catalog with field descriptions
  TABLES
    T_OUTTAB                = IT_EKKO             " Table with data to be displayed
  EXCEPTIONS
    PROGRAM_ERROR           = 1                " Program errors
    OTHERS                  = 2.
IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*   WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.

****************************************************************************************

FORM USER_COMMAND USING R_UCOMM TYPE SY-UCOMM
      R_SELFIELD TYPE SLIS_SELFIELD.

  CASE R_UCOMM.
    WHEN '&IC1'.
      READ TABLE IT_EKKO INTO WA_EKKO INDEX  R_SELFIELD-TABINDEX.
      IF SY-SUBRC EQ 0.
        SELECT * FROM EKPO
          INTO CORRESPONDING FIELDS OF TABLE IT_EKPO
          WHERE EBELN = WA_EKKO-EBELN.

        IF IT_EKPO IS NOT INITIAL.

         REFRESH IT_FCAT.

          CLEAR WA_FCAT.
          WA_FCAT-COL_POS = '1'.
          WA_FCAT-FIELDNAME = 'EBELN'.
          WA_FCAT-SELTEXT_L = 'Purchasing Document Number'.
          APPEND WA_FCAT TO IT_FCAT.

          CLEAR WA_FCAT.
          WA_FCAT-COL_POS = '2'.
          WA_FCAT-FIELDNAME = 'EBELP'.
          WA_FCAT-SELTEXT_L = 'Item Number of Purchasing Document'.
          APPEND WA_FCAT TO IT_FCAT.

          CLEAR WA_FCAT.
          WA_FCAT-COL_POS = '3'.
          WA_FCAT-FIELDNAME = 'AEDAT'.
          WA_FCAT-SELTEXT_L = 'DATE'.
          APPEND WA_FCAT TO IT_FCAT.

          CLEAR WA_FCAT.
          WA_FCAT-COL_POS = '4'.
          WA_FCAT-FIELDNAME = 'AEDAT'.
          WA_FCAT-SELTEXT_L = 'DATE'.
          APPEND WA_FCAT TO IT_FCAT.

          CLEAR WA_FCAT.
          WA_FCAT-COL_POS = '5'.
          WA_FCAT-FIELDNAME = 'MATNR'.
          WA_FCAT-SELTEXT_L = 'MATERIAL NUMBER'.
          APPEND WA_FCAT TO IT_FCAT.

          CLEAR WA_FCAT.
          WA_FCAT-COL_POS = '6'.
          WA_FCAT-FIELDNAME = 'BUKRS'.
          WA_FCAT-SELTEXT_L = 'COMPANY CODE'.
          APPEND WA_FCAT TO IT_FCAT.

          CLEAR WA_FCAT.
          WA_FCAT-COL_POS = '7'.
          WA_FCAT-FIELDNAME = 'WERKS'.
          WA_FCAT-SELTEXT_L = 'PLANT'.
          APPEND WA_FCAT TO IT_FCAT.

          CLEAR WA_FCAT.
          WA_FCAT-COL_POS = '8'.
          WA_FCAT-FIELDNAME = 'LGORT'.
          WA_FCAT-SELTEXT_L = 'STORAGE LOCATION'.
          APPEND WA_FCAT TO IT_FCAT.

          CLEAR WA_FCAT.
          WA_FCAT-COL_POS = '9'.
          WA_FCAT-FIELDNAME = 'BEDNR'.
          WA_FCAT-SELTEXT_L = 'REQUIREMENT TRACKING NUMBER'.
          APPEND WA_FCAT TO IT_FCAT.

          CLEAR WA_FCAT.
          WA_FCAT-COL_POS = '10'.
          WA_FCAT-FIELDNAME = 'MATKL'.
          WA_FCAT-SELTEXT_L = 'MATERIAL GROUP'.
          APPEND WA_FCAT TO IT_FCAT.

          WA_LAYO-COLWIDTH_OPTIMIZE ='X'.


          CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
            EXPORTING
              IS_LAYOUT                   =      WA_LAYO            " List layout specifications
              IT_FIELDCAT                 =      IT_FCAT            " Field catalog with field descriptions
            TABLES
              T_OUTTAB                    =   IT_EKPO               " Table with data to be displayed
            EXCEPTIONS
              PROGRAM_ERROR               = 1                " Program errors
              OTHERS                      = 2
            .
          IF SY-SUBRC <> 0.
           MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
             WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
          ENDIF.

        ENDIF.

      ENDIF.
  ENDCASE.
ENDFORM.
