PRO ELEMENTS, elems
;+
; NAME:
;     ELEMENTS
;
; PURPOSE:
;     Procedure to create a dictionary of
;     elements' features and their rest wavelengths
;
; INPUT:
;     NONE
;
; OUTPUTS:
;     ELEMS = dictionary
;
; MODIFICATION HISTORY:
;     Jeimin A. Garibnavajwala, April 17, 2021
;
;-

  on_error, 2
  compile_opt idl2

  if N_PARAMS() EQ 0 then begin
     print, "ELEMENTS, ELEMS"
     retall
  end
                                ;
  elems = HASH($
          "O_VI_1033", TEXTOIDL("O VI"), $
          "LY_ALPHA", textoidl("Ly_{\alpha}"), $
          "N_V_1240", textoidl("N V"), $
          "SI_IV+O_IV", TEXTOIDL("Si IV + O IV"), $
          "C_IV_1549", textoidl("C IV"), $
          "HE_II_1640", textoidl("He II"), $
          "C_III_1908", textoidl("C III"), $
          "MG_II_2799", textoidl("Mg II"), $
          "O_II_3725", textoidl("O II"), $
          "O_II_3727", textoidl("O II"), $
          "NE_III_3868", textoidl("Ne III"), $
          "H_EPSILON", textoidl("H_{\epsilon}"), $
          "NE_III_3970", textoidl("Ne III"), $
          "H_DELTA", textoidl("H_{\delta}"), $
          "H_GAMMA", textoidl("H_{\gamma}"), $
          "O_III_4363", textoidl("O III"), $
          "He_II_4685", textoidl("He II"), $
          "H_BETA", textoidl("H_{\beta}"), $
          "O_III_4959", textoidl("O III"), $
          "O_III_5007", textoidl("O III"), $
          "HE_II_5411", textoidl("He II"), $
          "O_I_5577", textoidl("O I"), $
          "N_II_5755", textoidl("N II"), $
          "HE_I_5876", textoidl("He I"), $
          "O_I_6300", textoidl("O I"), $
          "N_II_6548", textoidl("N II"), $
          "H_ALPHA", textoidl("H_{\alpha}"), $
          "N_II_6583", textoidl("N II"), $
          "S_II_6716", textoidl("S II"), $
          "S_II_6730", textoidl("S II"), $
          "AR_III_7135", textoidl("Ar III"))
                                ;
end

