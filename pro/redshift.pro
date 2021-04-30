FUNCTION REDSHIFT, element, wavelength
;+
; NAME:
;     REDSHIFT
;
; PURPOSE:
;     Function to calculate the redshift from the
;     shift in feature wavelengths
;
; INPUT:
;     ELEMENT    = name of the feature (identified
;                  by the name of the element)
;     WAVELENGTH = wavelength at which feature was
;                  observed.
;                  Must be in Angstroms
;
; EXAMPLE:
;     IDL> Z = REDSHIFT(O_III_4959, 8000)
;
; MODIFICATION HISTORY:
;     Jeimin A. Garibnavajwala, April 17, 2021
;     
;-

  On_error, 2
  compile_opt idl2

  if N_PARAMS() EQ 0 then begin
     print, 'Syntax - Z = REDSHIFT(ELEMENT, WAVELENGTH)'
     return, -1
     retall
  endif
                                ;
                                ; restore ref_wave.idl
                                ; ref_wave.idl contains HASH table
                                ; key: feature name
                                ; value: rest wavelength
  restore, '/users/garibnavajwala/idl/ref_wave.idl'
                                ;
                                ; calculate redshift
  z = wavelength/ref_wave[element]
  z -= 1
                                ; return expression
  return, z
                                ;
end
