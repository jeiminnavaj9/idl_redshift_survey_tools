pro read_spectra, FITS, savefile, SAVE=save, PS=ps, CREATE=create
;+
; NAME:
;     READ_SPECTRA
;
; PURPOSE:
;     Read spectra from FITS file and calculate the redshift
;     from the shifted features
;
; INPUT:
;     FITS spectra
;
; OUTPUTS:
;     Corresponding redshift
;
; MODIFICATION HISTORY:
;     Jeimin A. Garibnavajwala, April 2021
;
;-
  on_error, 2
  compile_opt idl2
                                ;
  if N_PARAMS() EQ 0 then begin
     print, "READ_SPECTRA, FITS, SAVFILE, SAVE=SAVE, PS=PS"
     retall
  end
                                ;
                                ; create HASH table to store the data
  dat=HASH("OBJ_ID",list(), $   ; object id
           "NAME",list(), $     ; name
           "FIBER_ID",list(),$  ; fiber id
           "PLATE_ID",list(),$  ; plate id
           "Z",list(), $        ; redshift
           "Zerr",list(), $     ; error in redshift
           "RA",list(), $       ; right ascension
           "DEC",list(), $      ; declination
           "MJD",list())        ; MJD
                                ;
                                ; if two parameters are passed
  if N_PARAMS(0) EQ 2 then begin
                                ; path where the savefile is located
     path='/users/garibnavajwala/idl/'
     files=FILE_SEARCH(path+savefile, /fold_case)
                                ;
     if files EQ '' then begin  ; if file does not exist
                                ; create a file with filename
                                ; eq to savefile
                                ;
        if KEYWORD_SET(create) then begin
                                ;
           save, dat, filename=savefile
                                ;
        endif else begin        ; else display an error message
                                ;
           print, savefile + ' does not exist in ' + path
           print, 'add keyword CREATE to create new'
           retall
        end
                                ;
     endif
                                ;
  endif else begin              ; if parameters are less than 2 and
                                ; save keyword is passed
                                ;
     if KEYWORD_SET(save) then begin
        savefile = 'new_file.idl'
        save, dat, filename=savefile
     endif
                                ;
  endelse                       ; end ELSE
                                ;
                                ; read FITS
  fits_read,FITS,d0,h0,exten=0  ; from extension 0
  fits_read,FITS,d1,h1,exten=1  ; from extension 1
                                ;
  flux=tbget(h1,d1,'FLUX')      ; flux column from bin table
  wave=tbget(h1,d1,'LOGLAM')    ; wavelength column from bin table
  wave=10.0^wave                ; log10 to Angstroms
                                ;
  window, xsi=1000, ysi=700     ; create window to display spectra
                                ;
  title = 'spectra: '+$
          HDGET(h0, "PLATEID")+$
          '-'+HDGET(h0,"MJD")+$
          '-'+HDGET(h0,"FIBERID")
                                ;
  plot_spec,wave,flux,title ; plot spectra
                                ;
  print, "select three features..."
                                ;
                                ; determine features
  det_feature,wave,flux,z1,x1,y1,elem1
  det_feature,wave,flux,z2,x2,y2,elem2
  det_feature,wave,flux,z3,x3,y3,elem3
                                ;
  rdshft=[z1, z2, z3]           ; redshift array
                                ;
  z=MEAN(rdshft)                ; mean redshift
  z_err=STDDEV(rdshft)          ; standard deviation
                                ;
                                ; print the measured redshift
  print, "measured redshift is ", z
  print, "error in measured redshift is ", z_err
                                ;
                                ; convert redshift to string
  str_z=STRING(z)
  rm_ewhites, str_z
  str_z_err = STRING(z_err)
  rm_ewhites, str_z_err
                                ;
                                ; display redshift on graph
  xyouts, 0.4, 0.9, TEXTOIDL("Z = " + str_z + " \pm " + str_z_err), $
          /normal, charthick=1.8
                                ; object's right ascension
  ra = HDGET(h0, "PLUG_RA")
  ra = STRING(ra)
  rm_ewhites, ra
                                ; RA on graph
  xyouts, 0.4, 0.85, "RA: " + ra, /normal, charthick=1.8
                                ; object's declination
  dec = HDGET(h0, "PLUG_DEC")
  dec = STRING(dec)
  rm_ewhites, dec
                                ; dec on graph
  xyouts, 0.4, 0.8, "DEC: " + dec, /normal, charthick=1.8
                                ;
                                ; if save keyword passed
  if KEYWORD_SET(save) then begin
                                ;
     restore, savefile          ; restore data from savefile
                                ; update the data
     dat["OBJ_ID"] += LIST(hdget(h0, "THING_ID"))
     dat["NAME"] += LIST(hdget(h0, "NAME"))
     dat["FIBER_ID"] += LIST(HDGET(h0, "FIBERID"))
     dat["PLATE_ID"] += LIST(HDGET(h0, "PLATEID"))
     dat["Z"] += LIST(z)
     dat["Zerr"] += LIST(z_err)
     dat["RA"] += LIST(hdget(h0, "PLUG_RA"))
     dat["DEC"] += LIST(hdget(h0, "PLUG_DEC"))
     dat["MJD"] += LIST(hdget(h0, "MJD"))
                                ;
     save,dat,filename=savefile ; save the data
                                ;
  endif
                                ;
  if KEYWORD_SET(ps) then begin ; write to PostScript
     psname = 'spec-'+HDGET(h0, "PLATEID")+$
          '-'+HDGET(h0,"MJD")+$
          '-'+HDGET(h0,"FIBERID")
     ps, psname+'.ps', /start
  endif
                                ;
  restore, 'elements.idl'       ; restore LaTex labels for elements
                                ;
                                ; plot spectrum and label the observed
                                ; features, redshift, RA, and dec
  plot_spec, wave, flux, title
                                ;
  oplot, [x1, x1], [y1, y1 + 1]
  xyouts, x1, (y1 + 1.1), elements[elem1], charthick=1.8
                                ;
  oplot, [x2, x2], [y2, y2 + 1]
  xyouts, x2, (y2 + 1.1), elements[elem2], charthick=1.8
                                ;
  oplot, [x3, x3], [y3, y3 + 1]
  xyouts, x3, (y3 + 1.1), elements[elem3], charthick=1.8
                                ;
  xyouts, 0.4, 0.9, textoidl("Z = " + str_z + " \pm " + str_z_err), $
          /normal, charthick=1.8
  xyouts, 0.4, 0.85, "RA: " + ra, /normal, charthick=1.8
  xyouts, 0.4, 0.8, "DEC: " + dec, /normal, charthick=1.8
                                ;
  if KEYWORD_SET(ps) then begin ; close PostScript
     ps, /close
  endif
                                ;
end

