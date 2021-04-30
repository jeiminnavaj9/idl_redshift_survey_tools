pro rm_ewhites, str
;+
; NAME:
;     RM_EWHITES
;
; PURPOSE:
;     Procedure to remove white space from the
;     ends
;
; INPUT:
;     STR = A string
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
     print, "RM_EWHITES, STR"
     retall
  end
                                ;
  for i=0, n_elements(str)-1 do begin
                               
     ascii = BYTE(str[i])          ; array of ASCII values for each
                                ; character in STR
                                ;
     elems = N_ELEMENTS(ascii)  ; number of elements in ascii
                                ;
     pre = 0                    ; starting index
     post = elems-1             ; ending index
                                ;
                                ; ASCII value for white space: 32
                                ; ASCII value for ': 39
     while pre LT elems && $
        (ascii[pre] EQ 32 || ascii[pre] EQ 39)do begin
        pre++
     endwhile
                                ;
     while post GE 0 && $
        (ascii[post] EQ 32 || ascii[post] EQ 39)do begin
        post--
     endwhile
                                ;
     str[i]=str[i].substring(pre, post) ; substring of STR
                                ;
  endfor
  
end
