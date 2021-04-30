pro plot_spec, wavelength, flux, title, PS=ps
;+
;
;
;-

  if n_params() eq 0 then begin
     print, "PLOT_SPEC, WAVELENGTH, FLUX"
     retall
  end

; write to PostScript
  if keyword_set(ps) then begin
     ps, "plot_spec.ps", /start
  endif

; LaTex Angstrom
  ang = '!3!SA!R!9!U % !N!3'

; x and y axis title
  !ytitle = 'FLUX ' + textoidl('(10^{-17} ergs/cm^2-sec-') + ang + ')'
  !x.title='!3Wavelength (' + ang + ')'

; plot
  plot, wavelength, flux, title=title, charthick=1.8, $
        xrange=[3.5e3, 10500.0], xstyle=1, $
        yrange=[20.0, 200.0], ystyle=1

; close PostScript
  if keyword_set(ps) then begin
     ps, /close
  endif

end

