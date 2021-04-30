PRO DET_FEATURE, wavelength, flux, rdshft, $
                 anot_x, anot_y, elem, DISP_PLOT=disp_plot
;+
; NAME:
;     READ_SPECTRA
;
; PURPOSE:
;     Procedure to determine the feature in a spectra and calculate
;     reshift from the shift in the feature
;
; INPUT:
;     NONE
;
; OUTPUT:
;     WAVELENGTH = wavelength of the observed feature (in Angstroms)
;     FLUX       = flux (intensity) of the feature
;     RDSHFT     = redshift
;     ANOT_X     = same as WAVELENGTH
;     ANOT_Y     = same as FLUX
;     ELEM       = name of feature inputted by user
;
; KEYWORDS:
;     DISP_PLOT  = display spectrum with annotations
;
; MODIFICATION HISTORY:
; Jeimin A. Garibnavajwala, April 17, 2021
;
;-
                                ;
  on_error, 2
  compile_opt idl2
                                ;
  if N_PARAMS() EQ 0 then begin
     print, "DET_FEATURE, WAVELENGTH, FLUX"
     retall
  end
                                ;
                                ; restore elements with their
                                ; rest wavelengths
  restore, '/users/garibnavajwala/idl/elements.idl'
                                ;
  ;msg="select three features..."
  ;print, msg
                                ;
  if KEYWORD_SET(disp_plot) then begin
     plot_spec,wavelength,flux  ; display plot
  endif
                                ;
  cursor, w_obs, f, /data       ; get data from user
                                ;
  elem = ""                     ; declare a string variable
                                ;
  read, "feature: ", elem       ; feature name from user
  elem=elem.ToUpper()           ; convert elem to uppercase
                                ;
  anot_x = w_obs
  anot_y = f
                                ;
                                ; label the feature
  oplot, [w_obs, w_obs], [f, f + 1.0]
  xyouts, w_obs, (f + 1.1), elements[elem], charthick=1.8
                                ;
  rdshft=REDSHIFT(elem, w_obs)  ; calculate redshift
                                ;
end
