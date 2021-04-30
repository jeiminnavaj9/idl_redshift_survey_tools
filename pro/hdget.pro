function hdget, header, key
;+
; NAME:
;     HDGET
;
; PURPOSE:
;     Function to retrieve data from FITS header
;
; INPUT:
;     HEADER = FITS header outputted by FITS_READ
;     KEY    = String to retrieve data for
;
; EXAMPLE:
;     IDL> fits_read, file, data, header
;     IDL> ra = hdget(header, "RA")
;
; MODIFICATION HISTORY:
;     Jeimin A. Garibnavajwala, April 17, 2021
;     
;-
  on_error, 2
  compile_opt idl2
                                ;
                                ; print message when no parameters are passed
  if N_PARAMS() EQ 0 then begin
     print, "HDGET, HEADER, KEY"
     print, "HEADER outputted by FITS_READ"
     return, -1
     retall
  end
                                ;
  key = key.ToUpper()           ; convert to uppercase
                                ;
  hdData = HASH()               ; create HASH to store the data
                                ;
; iterate through each line in the header
  FOREACH line, header[0:-2]  do begin
                                ; chop line at "=" into array
     str = STRSPLIT(line,"=", /extract)
                                

                                ; enter IF block if line is not a
                                ; comment
                                ;
                                ; example of a header comment:
                                ; COMMENT  *** Column formats ***
     if N_ELEMENTS(str) GT 1 then begin
                                ; chop second element of STR into array
                                ; chop at ' /'
        str1 = STRSPLIT(str[1], ' /', /extract, /regex)

                                ; str1[0] contains the required data 
        data = str1[0]          ; data = STRSPLIT(str1[0], /extract)
        ascii_vals = BYTE(data) ; convert each character to its ASCII value

        isNum = 1               ; check if data is a number
        isFloat = 0             ; check if data is a floating point

        i = 0                   ; iterating index for while loop
                                ; while loop to check if data is a number
                                ;
                                ; ASCII VALUES
                                ; 45: '-'
                                ; 46: '.'
                                ; 48 to 57: '0' to '9'
        while i LT N_ELEMENTS(ascii_vals) && isNum EQ 1 do begin
                                ;
           if (ascii_vals[i] EQ 45 || (ascii_vals[i] EQ 46)) $
              || ((ascii_vals[i] GE 48) && (ascii_vals[i] LE 57)) then  begin
                                ;
              if ascii_vals[i] EQ 46 then begin
                 isFloat = 1    ; float is ASCII VALUE is 46
              endif
                                ;
           endif else begin
              isNum = 0         ; isNum is 0 in ELSE block
           endelse
                                ;
           i++                  ; increment iterating index by
                                ; one to check other characters
        endwhile
                                ;
        if isNum then begin     ; enter IF block if isNum is 1
                                ;
           if isFloat then begin  ; enter IF block is isFloat is 1
              data = DOUBLE(data) ; convert data to double precision
                                ;
           endif else begin     ; enter ELSE block
              data = LONG(data) ; convert data to long
           endelse              ; end ELSE
                                ; write to HASH
           hdData[str[0].compress()] = data
                                ;
        endif else begin        ; enter ELSE block
                                ; write to HASH
                                ;
           rm_ewhites, data     ; remove white space from ends
           hdData[str[0].compress()] = data
        endelse                 ; end ELSE
     endif
                                ;
  ENDFOREACH
; end for loop
                                ; return required data
  return, hdData[key]
                                ;
end
  
